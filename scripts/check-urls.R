library(httr2)
library(jsonlite)
library(here)

source(here::here("scripts", "scrape_helpers.R"))

CONTENT_FIELDS <- list(
  url       = list(image = FALSE, homepage = NULL),
  rss_feed  = list(image = FALSE, homepage = "url"),
  photo_url = list(image = TRUE,  homepage = "url")
)

PACKAGE_FIELDS <- list(
  repo_url        = list(image = FALSE, homepage = NULL),
  pkdown_url      = list(image = FALSE, homepage = NULL),
  bug_reports_url = list(image = FALSE, homepage = NULL),
  logo_url        = list(image = TRUE,  homepage = "pkdown_url")
)

USER_AGENT <- "rladies-url-checker (+https://github.com/rladies/awesome-rladies-creations)"
TIMEOUT_S  <- 20L

`%||%` <- function(a, b) if (is.null(a) || (length(a) == 1 && is.na(a))) b else a

ensure_scheme <- function(url) {
  if (is.null(url) || is.na(url) || !nzchar(url)) return(NA_character_)
  if (grepl("^https?://", url, ignore.case = TRUE)) return(url)
  paste0("https://", url)
}

check_url <- function(url, expect_image = FALSE) {
  full <- ensure_scheme(url)
  if (is.na(full)) {
    return(list(status = NA_integer_, content_type = NA_character_,
                error = "could not build URL", category = "broken"))
  }
  resp <- tryCatch(
    request(full) |>
      req_user_agent(USER_AGENT) |>
      req_timeout(TIMEOUT_S) |>
      req_error(is_error = function(x) FALSE) |>
      req_perform(),
    error = function(e) e
  )
  if (inherits(resp, "error")) {
    return(list(status = NA_integer_, content_type = NA_character_,
                error = conditionMessage(resp), category = "down"))
  }
  status <- resp_status(resp)
  ctype  <- tryCatch(resp_content_type(resp), error = function(e) NA_character_)
  category <-
    if (status %in% c(404L, 410L)) "broken"
    else if (status >= 500L)       "down"
    else if (status >= 400L)       "broken"
    else if (expect_image && (length(ctype) == 0 || !grepl("^image/", ctype, ignore.case = TRUE))) "not_image"
    else "ok"
  list(status = status, content_type = ctype %||% NA_character_,
       error = NA_character_, category = category)
}

suggest_replacement <- function(homepage_url) {
  if (is_blank(homepage_url)) return(NA_character_)
  html <- fetch_html(ensure_scheme(homepage_url))
  if (is.na(html) || !nzchar(html)) return(NA_character_)
  candidate <- scrape_image(html, homepage_url)
  if (is.na(candidate) || is_blank(candidate)) return(NA_character_)
  if (identical(check_url(candidate, expect_image = TRUE)$category, "ok")) {
    return(candidate)
  }
  NA_character_
}

scan_dir <- function(dir, fields, kind) {
  if (!dir.exists(dir)) return(list())
  files <- list.files(dir, pattern = "\\.json$", full.names = TRUE)
  out <- list()
  for (f in files) {
    entry <- tryCatch(read_json(f), error = function(e) NULL)
    if (is.null(entry)) next
    for (field in names(fields)) {
      cfg <- fields[[field]]
      url <- entry[[field]]
      if (is_blank(url)) next
      res <- check_url(url, expect_image = cfg$image)
      suggestion <- NA_character_
      if (cfg$image && res$category != "ok" && !is.null(cfg$homepage)) {
        cat(sprintf("  broken %s in %s — looking for og:image...\n", field, basename(f)))
        suggestion <- suggest_replacement(entry[[cfg$homepage]])
      }
      out[[length(out) + 1]] <- data.frame(
        kind = kind,
        file = basename(f),
        field = field,
        url = url,
        status = res$status %||% NA_integer_,
        content_type = res$content_type %||% NA_character_,
        category = res$category,
        error = res$error %||% NA_character_,
        suggestion = suggestion %||% NA_character_,
        stringsAsFactors = FALSE
      )
    }
  }
  out
}

cat("Scanning data/content...\n")
content_rows <- scan_dir(here("data", "content"),  CONTENT_FIELDS, "content")
cat("Scanning data/packages...\n")
package_rows <- scan_dir(here("data", "packages"), PACKAGE_FIELDS, "package")

all_rows <- c(content_rows, package_rows)
results <- if (length(all_rows) == 0) {
  data.frame(kind = character(), file = character(), field = character(),
             url = character(), status = integer(), content_type = character(),
             category = character(), error = character(), suggestion = character())
} else {
  do.call(rbind, all_rows)
}

results <- results[order(results$category, results$kind, results$file, results$field), ]

out_path <- "url-check-report.tsv"
write.table(results, out_path, sep = "\t", row.names = FALSE, quote = FALSE, na = "")

summary_tbl <- table(factor(results$category, levels = c("broken", "not_image", "down", "ok")))
cat("Summary:\n")
for (n in names(summary_tbl)) {
  cat(sprintf("  %s: %d\n", n, summary_tbl[[n]]))
}
cat(sprintf("Wrote %s\n", out_path))

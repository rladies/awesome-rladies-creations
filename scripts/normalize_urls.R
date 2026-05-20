library(here)
source(here::here("scripts", "url_helpers.R"))

# Regex-based field rewrites so existing JSON formatting is preserved
# (whitespace, key order, indentation) — only the URL string changes.
fix_text <- function(text, field_names) {
  for (field in field_names) {
    pattern <- sprintf('("%s"[[:space:]]*:[[:space:]]*)"([^"]*)"', field)
    m <- gregexpr(pattern, text, perl = TRUE)[[1]]
    if (m[1] == -1) {
      next
    }
    starts <- as.integer(m)
    lens <- attr(m, "match.length")
    for (i in order(-starts)) {
      s <- starts[i]
      e <- s + lens[i] - 1L
      chunk <- substr(text, s, e)
      parts <- regmatches(chunk, regexec(pattern, chunk, perl = TRUE))[[1]]
      prefix <- parts[2]
      value <- parts[3]
      if (!nzchar(value)) {
        next
      }
      fixed <- normalize_url(value)
      if (identical(fixed, value)) {
        next
      }
      replacement <- sprintf('%s"%s"', prefix, fixed)
      text <- paste0(
        substr(text, 1L, s - 1L),
        replacement,
        substr(text, e + 1L, nchar(text))
      )
    }
  }
  text
}

normalize_dir <- function(dir, field_names) {
  if (!dir.exists(dir)) {
    return(invisible(NULL))
  }
  files <- list.files(
    dir,
    pattern = "\\.json$",
    full.names = TRUE,
    recursive = TRUE
  )
  changed <- character(0)
  for (f in files) {
    if (basename(f) == "_manifest.json") {
      next
    }
    original <- paste(readLines(f, warn = FALSE), collapse = "\n")
    has_trailing_newline <- grepl("\n$", original) ||
      identical(tail(readBin(f, "raw", file.info(f)$size), 1), as.raw(0x0a))
    fixed <- fix_text(original, field_names)
    if (!identical(fixed, original)) {
      writeLines(fixed, f, sep = if (has_trailing_newline) "\n" else "")
      changed <- c(changed, f)
    }
  }
  for (f in changed) {
    cat("  fixed:", sub(paste0(dir, "/"), "", f, fixed = TRUE), "\n")
  }
  cat(sprintf("%s: %d/%d files changed\n", dir, length(changed), length(files)))
}

content_fields <- c("url", "rss_feed", "photo_url", "website")
package_fields <- c("repo_url", "pkdown_url", "bug_reports_url", "logo_url")

cat(
  "Normalizing URL fields to canonical form (https?:// scheme, no trailing slash)\n"
)
normalize_dir(here::here("data", "content"), content_fields)
normalize_dir(here::here("data", "content_pending"), content_fields)
normalize_dir(here::here("data", "packages"), package_fields)
normalize_dir(here::here("data", "packages_pending"), package_fields)

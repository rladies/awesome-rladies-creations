library(jsonlite)
library(jsonvalidate)
library(here)

source(here::here("scripts", "url_helpers.R"))

validate_dir <- function(dir, schema, url_fields) {
  files <- list.files(dir, pattern = "\\.json$", full.names = TRUE)
  if (length(files) == 0) {
    cat("No JSON files in", dir, "- skipping\n")
    return(invisible(TRUE))
  }
  validator <- jsonvalidate::json_validator(schema, engine = "ajv")
  cat(
    "Validating",
    length(files),
    "files in",
    dir,
    "against",
    basename(schema),
    "\n"
  )
  failures <- character(0)
  for (f in files) {
    file_errors <- character(0)

    ok <- validator(f, verbose = TRUE, error = FALSE, greedy = TRUE)
    if (!isTRUE(ok)) {
      errors <- attr(ok, "errors")
      if (!is.null(errors)) {
        for (i in seq_len(nrow(errors))) {
          schema_path <- errors$schemaPath[i]
          msg <- errors$message[i]
          if (grepl("pattern", schema_path) && grepl("https\\?://", msg)) {
            file_errors <- c(
              file_errors,
              sprintf(
                "  %s: must match URL format ^https?://...non-trailing-slash. See url_helpers.R::normalize_url for the fix.",
                errors$instancePath[i]
              )
            )
          } else {
            file_errors <- c(
              file_errors,
              sprintf("  %s %s", errors$instancePath[i], msg)
            )
          }
        }
      }
    }

    entry <- tryCatch(read_json(f), error = function(e) NULL)
    if (!is.null(entry)) {
      url_errors <- collect_url_errors(entry, url_fields)
      if (length(url_errors) > 0) {
        file_errors <- c(file_errors, paste0("  ", url_errors))
      }
    }

    if (length(file_errors) > 0) {
      failures <- c(failures, f)
      cat("FAIL:", basename(f), "\n")
      cat(paste(file_errors, collapse = "\n"), "\n")
    }
  }
  if (length(failures) > 0) {
    return(invisible(failures))
  }
  cat("  All", length(files), "files valid.\n")
  invisible(TRUE)
}

content_failures <- validate_dir(
  here::here("data/content"),
  here::here("scripts/json_schema/content.json"),
  CONTENT_URL_FIELDS
)
package_failures <- validate_dir(
  here::here("data/packages"),
  here::here("scripts/json_schema/packages.json"),
  PACKAGE_URL_FIELDS
)

all_failures <- c(
  if (!isTRUE(content_failures)) content_failures,
  if (!isTRUE(package_failures)) package_failures
)
if (length(all_failures) > 0) {
  stop(
    "Validation failed for ",
    length(all_failures),
    " file(s).\n",
    "URLs must be canonical: start with https:// (or http://), no trailing slash, no whitespace.\n",
    "To auto-fix, run: Rscript scripts/normalize_urls.R\n\n",
    "Failing files:\n  ",
    paste(all_failures, collapse = "\n  "),
    call. = FALSE
  )
}
cat("All JSON files valid.\n")

library(jsonlite)
library(jsonvalidate)
library(here)

validate_dir <- function(dir, schema) {
  files <- list.files(dir, pattern = "\\.json$", full.names = TRUE)
  files <- files[!startsWith(basename(files), "_")]
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
    ok <- validator(f, verbose = TRUE, error = FALSE, greedy = TRUE)
    if (!isTRUE(ok)) {
      failures <- c(failures, f)
      cat("  FAIL:", basename(f), "\n")
      errors <- attr(ok, "errors")
      if (!is.null(errors)) print(errors)
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
  here::here("scripts/json_schema/content.json")
)
package_failures <- validate_dir(
  here::here("data/packages"),
  here::here("scripts/json_schema/packages.json")
)
runiverse_failures <- validate_dir(
  here::here("data/runiverse"),
  here::here("scripts/json_schema/runiverse.json")
)

all_failures <- c(
  if (!isTRUE(content_failures)) content_failures,
  if (!isTRUE(package_failures)) package_failures,
  if (!isTRUE(runiverse_failures)) runiverse_failures
)
if (length(all_failures) > 0) {
  stop(
    "Validation failed for ",
    length(all_failures),
    " file(s):\n  ",
    paste(all_failures, collapse = "\n  "),
    call. = FALSE
  )
}
cat("All JSON files valid.\n")

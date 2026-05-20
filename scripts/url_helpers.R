# Canonical URL format for JSON data files:
#   - Must start with `http://` or `https://`
#   - Must not end with a trailing slash
#   - Must not contain whitespace
#
# `normalize_url()` makes a single URL canonical.
# `validate_url()` returns NULL if canonical, otherwise a fix suggestion.
# CONTENT_URL_FIELDS / PACKAGE_URL_FIELDS describe where URLs live.

URL_PATTERN <- "^https?://[^[:space:]]+[^/[:space:]]$"

CONTENT_URL_FIELDS <- list(
  list(path = "url"),
  list(path = "rss_feed"),
  list(path = "photo_url"),
  list(path = c("authors", "social_media", "website"))
)

PACKAGE_URL_FIELDS <- list(
  list(path = "repo_url"),
  list(path = "pkdown_url"),
  list(path = "bug_reports_url"),
  list(path = "logo_url")
)

normalize_url <- function(url) {
  if (is.null(url) || length(url) == 0) {
    return(url)
  }
  if (is.na(url) || !nzchar(url)) {
    return(url)
  }
  out <- trimws(url)
  # URLs can't contain whitespace; drop CRAN-style ` (label)` annotations.
  out <- sub("[[:space:]].*$", "", out)
  if (!grepl("^https?://", out, ignore.case = TRUE)) {
    out <- paste0("https://", out)
  }
  out <- sub("/+$", "", out)
  out
}

validate_url <- function(url) {
  if (is.null(url) || length(url) == 0 || is.na(url) || !nzchar(url)) {
    return(NULL)
  }
  if (grepl(URL_PATTERN, url)) {
    return(NULL)
  }
  suggested <- normalize_url(url)
  reason <- if (!grepl("^https?://", url, ignore.case = TRUE)) {
    "missing scheme (must start with https:// or http://)"
  } else if (grepl("/$", url)) {
    "trailing slash (URLs must not end with /)"
  } else if (grepl("[[:space:]]", url)) {
    "contains whitespace"
  } else {
    "does not match canonical URL format"
  }
  sprintf("%s — fix: \"%s\"", reason, suggested)
}

walk_url_fields <- function(entry, fields, fn) {
  for (field in fields) {
    entry <- walk_one_field(entry, field$path, fn)
  }
  entry
}

walk_one_field <- function(node, path, fn) {
  if (length(path) == 0) {
    return(fn(node))
  }
  if (is.null(node)) {
    return(node)
  }
  head <- path[[1]]
  tail <- path[-1]
  if (is.list(node) && !is.null(names(node)) && head %in% names(node)) {
    node[[head]] <- walk_one_field(node[[head]], tail, fn)
    return(node)
  }
  # Unnamed list (JSON array): recurse into each item with full remaining path
  if (is.list(node) && (is.null(names(node)) || all(names(node) == ""))) {
    node <- lapply(node, function(x) walk_one_field(x, path, fn))
    return(node)
  }
  node
}

collect_url_errors <- function(entry, fields) {
  errors <- character(0)
  for (field in fields) {
    label <- paste(field$path, collapse = ".")
    visit <- function(node, p) {
      if (length(p) == 0) {
        msg <- validate_url(node)
        if (!is.null(msg)) {
          errors <<- c(errors, paste0(label, ": \"", node, "\" — ", msg))
        }
        return(invisible(NULL))
      }
      if (is.null(node)) {
        return(invisible(NULL))
      }
      head <- p[[1]]
      tail <- p[-1]
      if (is.list(node) && !is.null(names(node)) && head %in% names(node)) {
        visit(node[[head]], tail)
        return(invisible(NULL))
      }
      if (is.list(node)) {
        for (item in node) {
          visit(item, p)
        }
      }
    }
    visit(entry, field$path)
  }
  errors
}

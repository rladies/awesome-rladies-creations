library(here)
library(jsonlite)

source(here::here("scripts", "discover_helpers.R"))

packages_dir <- here::here("data/packages")
directory_dir <- here::here("..", "directory", "data", "json")

env_or_arg <- function(env_name, arg_index) {
  v <- Sys.getenv(env_name, unset = "")
  if (nzchar(v)) {
    return(v)
  }
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) >= arg_index) args[arg_index] else ""
}

# Each line of the textarea is either `pkg` or `pkg @ owner`. Owners on a line
# override the default; lines with no owner inherit `default_owner`.
parse_package_lines <- function(text, default_owner) {
  if (is_blank(text)) {
    return(list())
  }
  lines <- trimws(strsplit(text, "[\r\n]+")[[1]])
  lines <- lines[nzchar(lines)]
  out <- list()
  for (line in lines) {
    if (grepl("@", line, fixed = TRUE)) {
      halves <- trimws(strsplit(line, "@", fixed = TRUE)[[1]])
      pkg <- halves[1]
      owner <- if (length(halves) >= 2) halves[2] else ""
    } else {
      pkg <- line
      owner <- default_owner
    }
    if (!nzchar(pkg)) next
    out[[length(out) + 1]] <- list(name = pkg, owner = owner)
  }
  out
}

lookup_one <- function(pkg_name, owner_hint, repo_url_hint, cran_db) {
  if (!nzchar(owner_hint) && nzchar(repo_url_hint)) {
    owner_repo <- github_owner_repo(repo_url_hint)
    if (!is.na(owner_repo)) {
      owner_hint <- strsplit(owner_repo, "/", fixed = TRUE)[[1]][1]
      cat("  derived owner from repo URL:", owner_hint, "\n")
    }
  }

  cand <- NULL

  if (nzchar(owner_hint)) {
    cat("Querying r-universe for", owner_hint, "/", pkg_name, "...\n")
    pkg <- fetch_universe_package(owner_hint, pkg_name)
    if (!is.null(pkg) && !is_blank(pkg$Package)) {
      cand <- normalise_pkg(
        pkg,
        "r-universe",
        pkg$Maintainer %||% NA_character_,
        owner_hint,
        NA_character_
      )
      cat("  found in r-universe\n")
    } else {
      cat("  not found in r-universe\n")
    }
  }

  if (is.null(cand) && !is.null(cran_db)) {
    cat("Falling back to CRAN package db...\n")
    hit <- which(tolower(cran_db$Package) == tolower(pkg_name))
    if (length(hit) > 0) {
      row <- cran_db[hit[1], ]
      cand <- list(
        package = row$Package,
        title = row$Title,
        description = trimws(gsub("\\s+", " ", row$Description %||% "")),
        repo_owner = NA_character_,
        url = row$URL,
        bug_reports = row$BugReports,
        maintainer = row$Maintainer,
        last_updated = to_iso_date(row[["Date/Publication"]]),
        authors = parse_authors(row$Author),
        matched_author = NA_character_,
        matched_handle = NA_character_,
        matched_roles = NA_character_,
        source = "cran"
      )
      cat("  found on CRAN\n")
    } else {
      cat("  not found on CRAN\n")
    }
  }

  if (is.null(cand)) {
    return(NULL)
  }

  if (is_blank(cand$url) && nzchar(repo_url_hint)) {
    cand$url <- repo_url_hint
  }

  cand
}

write_gha_output <- function(key, value, gha_out) {
  if (!nzchar(gha_out)) return(invisible())
  delim <- paste0("EOF_", key, "_", as.integer(Sys.time()))
  lines <- c(
    paste0(key, "<<", delim),
    if (length(value) > 0) value else character(0),
    delim
  )
  con <- file(gha_out, open = "a")
  on.exit(close(con), add = TRUE)
  writeLines(lines, con)
}

pkg_names_text <- env_or_arg("PKG_NAMES", 1)
default_owner <- trimws(env_or_arg("PKG_OWNER", 2))
repo_url_hint <- trimws(env_or_arg("PKG_REPO_URL", 3))
directory_ids_text <- env_or_arg("DIRECTORY_IDS", 4)

requests <- parse_package_lines(pkg_names_text, default_owner)
if (length(requests) == 0) {
  stop("No package names provided (env PKG_NAMES).")
}

# repo_url hint only makes sense for a single package.
if (length(requests) > 1 && nzchar(repo_url_hint)) {
  cat(
    "Note: repository URL hint is ignored when more than one package is",
    "submitted in the same issue.\n"
  )
  repo_url_hint <- ""
}

cat("Processing", length(requests), "package(s)\n")

dir_lookup <- build_directory_lookup(directory_dir)
pairs <- parse_directory_id_pairs(directory_ids_text, dir_lookup)

# Pre-load CRAN once for all lookups; some requests may not need it but loading
# it here avoids re-downloading per package.
cran_db <- tryCatch(tools::CRAN_package_db(), error = function(e) NULL)

succeeded <- list()
failed <- list()

for (req in requests) {
  pkg_name <- req$name
  owner_hint <- req$owner
  cat("\n--- ", pkg_name, " ---\n", sep = "")

  cand <- tryCatch(
    lookup_one(pkg_name, owner_hint, repo_url_hint, cran_db),
    error = function(e) {
      cat("  error during lookup:", conditionMessage(e), "\n")
      NULL
    }
  )

  if (is.null(cand)) {
    failed[[length(failed) + 1]] <- list(
      name = pkg_name,
      owner = owner_hint
    )
    next
  }

  entry <- to_package_shape(cand, dir_lookup)
  if (length(pairs) > 0) {
    entry$authors <- apply_directory_id_pairs(entry$authors, pairs)
  }
  path <- write_pkg(entry, packages_dir)
  cat("  wrote", path, "\n")

  rel_path <- sub(
    paste0("^", here::here(), "/?"),
    "",
    path,
    fixed = FALSE
  )
  succeeded[[length(succeeded) + 1]] <- list(
    name = entry$name,
    file_path = rel_path,
    source = cand$source
  )
}

cat(
  "\nSummary: ",
  length(succeeded),
  " succeeded, ",
  length(failed),
  " failed.\n",
  sep = ""
)

gha_out <- Sys.getenv("GITHUB_OUTPUT", unset = "")
if (nzchar(gha_out)) {
  write_gha_output(
    "file_paths",
    vapply(succeeded, `[[`, character(1), "file_path"),
    gha_out
  )
  write_gha_output(
    "package_names",
    vapply(succeeded, `[[`, character(1), "name"),
    gha_out
  )
  write_gha_output(
    "sources",
    vapply(
      succeeded,
      function(s) sprintf("%s=%s", s$name, s$source),
      character(1)
    ),
    gha_out
  )
  write_gha_output(
    "failed",
    vapply(
      failed,
      function(f) {
        sprintf(
          "%s%s",
          f$name,
          if (nzchar(f$owner)) sprintf(" @ %s", f$owner) else ""
        )
      },
      character(1)
    ),
    gha_out
  )
}

# Fail the step only if nothing succeeded — partial successes still produce a PR.
if (length(succeeded) == 0) {
  stop("No packages could be looked up.")
}

#!/usr/bin/env Rscript
# Sync data/packages/ from the opt-in R-Universe registry.
#
# Authors opt in by adding data/runiverse/<handle>.json. The sync looks at
# https://raw.githubusercontent.com/<handle>/<handle>.r-universe.dev/HEAD/packages.json
# and treats any entry with `"rladies": true` as claimed by that handle.
#
# Two modes (set with SYNC_MODE env var):
#   - upsert: add/update package JSONs for every claimed package; write the
#             sync state file; emit the removal candidates as a GHA output.
#   - remove: delete data/packages/<pkg>.json for every previously-managed
#             package no longer claimed; rewrite the sync state file.
#
# The split exists because adds/updates land directly on main, while removals
# go through a PR (multi-author packages are tricky to auto-drop).

library(here)
library(jsonlite)

source(here::here("scripts", "discover_helpers.R"))

packages_dir <- here::here("data", "packages")
runiverse_dir <- here::here("data", "runiverse")
state_path <- file.path(runiverse_dir, "_sync_state.json")
directory_dir <- Sys.getenv(
  "DIRECTORY_DIR",
  here::here("..", "directory", "data", "json")
)

mode <- tolower(Sys.getenv("SYNC_MODE", "upsert"))
if (!mode %in% c("upsert", "remove")) {
  stop("SYNC_MODE must be 'upsert' or 'remove' (got '", mode, "').")
}

load_optins <- function(dir) {
  if (!dir.exists(dir)) {
    return(list())
  }
  files <- list.files(dir, pattern = "\\.json$", full.names = TRUE)
  files <- files[!startsWith(basename(files), "_")]
  out <- list()
  for (f in files) {
    e <- tryCatch(jsonlite::read_json(f), error = function(err) NULL)
    if (is.null(e) || is_blank(e$handle)) {
      next
    }
    out[[length(out) + 1]] <- list(
      handle = tolower(trimws(e$handle)),
      directory_id = e$directory_id %||% NA_character_
    )
  }
  out
}

fetch_runiverse_config <- function(handle) {
  for (ref in c("HEAD", "main", "master")) {
    url <- sprintf(
      "https://raw.githubusercontent.com/%s/%s.r-universe.dev/%s/packages.json",
      handle,
      handle,
      ref
    )
    h <- curl::new_handle()
    curl::handle_setopt(h, followlocation = TRUE, timeout = 15)
    resp <- tryCatch(
      curl::curl_fetch_memory(url, handle = h),
      error = function(e) NULL
    )
    if (is.null(resp) || resp$status_code != 200) {
      next
    }
    txt <- rawToChar(resp$content)
    parsed <- tryCatch(
      jsonlite::fromJSON(txt, simplifyVector = FALSE),
      error = function(e) NULL
    )
    if (!is.null(parsed)) return(parsed)
  }
  NULL
}

infer_pkg_name <- function(entry) {
  if (!is_blank(entry$package)) {
    return(sub("\\.git$", "", entry$package))
  }
  if (!is_blank(entry$url)) {
    seg <- sub("\\.git$", "", basename(entry$url))
    if (nzchar(seg)) return(seg)
  }
  NA_character_
}

write_gha_output <- function(key, values) {
  gha_out <- Sys.getenv("GITHUB_OUTPUT", unset = "")
  if (!nzchar(gha_out)) {
    return(invisible())
  }
  values <- values[nzchar(values)]
  delim <- paste0("EOF_", key, "_", as.integer(Sys.time()))
  con <- file(gha_out, open = "a")
  on.exit(close(con), add = TRUE)
  writeLines(c(paste0(key, "<<", delim), values, delim), con)
}

write_state <- function(state, path) {
  if (!dir.exists(dirname(path))) {
    dir.create(dirname(path), recursive = TRUE)
  }
  managed <- state$managed %||% list()
  ordered <- managed[order(names(managed))]
  state$managed <- ordered
  jsonlite::write_json(state, path, pretty = TRUE, auto_unbox = TRUE)
}

optins <- load_optins(runiverse_dir)
cat("Loaded ", length(optins), " opt-in registration(s).\n", sep = "")

state <- if (file.exists(state_path)) {
  jsonlite::read_json(state_path, simplifyVector = FALSE)
} else {
  list(managed = list())
}
if (is.null(state$managed)) {
  state$managed <- list()
}

dir_lookup <- build_directory_lookup(directory_dir)

claims <- list()
for (o in optins) {
  cat("Fetching packages.json for ", o$handle, "\n", sep = "")
  cfg <- fetch_runiverse_config(o$handle)
  if (is.null(cfg)) {
    cat("  could not fetch packages.json — skipping\n")
    next
  }
  marked <- 0L
  for (entry in cfg) {
    if (!isTRUE(entry$rladies)) {
      next
    }
    pkg <- infer_pkg_name(entry)
    if (is_blank(pkg)) {
      next
    }
    claims[[pkg]] <- unique(c(claims[[pkg]] %||% character(0), o$handle))
    marked <- marked + 1L
  }
  cat("  ", marked, " package(s) flagged rladies:true\n", sep = "")
}

if (mode == "upsert") {
  added <- character(0)
  updated <- character(0)
  failed <- character(0)
  for (pkg in names(claims)) {
    handles <- claims[[pkg]]
    primary <- handles[[1]]
    meta <- tryCatch(
      fetch_universe_package(primary, pkg),
      error = function(e) NULL
    )
    if (is.null(meta) || is_blank(meta$Package)) {
      cat(
        "  could not fetch metadata for ",
        pkg,
        " from ",
        primary,
        "\n",
        sep = ""
      )
      failed <- c(failed, pkg)
      next
    }
    cand <- normalise_pkg(
      meta,
      "r-universe",
      NA_character_,
      primary,
      NA_character_
    )
    entry <- to_package_shape(cand, dir_lookup)
    path <- file.path(packages_dir, paste0(entry$name, ".json"))
    existed <- file.exists(path)
    write_pkg(entry, packages_dir)
    if (existed) {
      updated <- c(updated, entry$name)
    } else {
      added <- c(added, entry$name)
    }
    state$managed[[entry$name]] <- list(handles = as.list(handles))
  }

  removal_candidates <- character(0)
  for (name in names(state$managed)) {
    if (is.null(claims[[name]])) {
      removal_candidates <- c(removal_candidates, name)
    }
  }

  write_state(state, state_path)

  write_gha_output("added", added)
  write_gha_output("updated", updated)
  write_gha_output("failed", failed)
  write_gha_output("removal_candidates", removal_candidates)

  cat("\nSummary:\n")
  cat("  added             : ", length(added), "\n", sep = "")
  cat("  updated           : ", length(updated), "\n", sep = "")
  cat("  fetch failures    : ", length(failed), "\n", sep = "")
  cat("  removal candidates: ", length(removal_candidates), "\n", sep = "")
} else {
  removed <- character(0)
  remaining <- list()
  for (name in names(state$managed)) {
    if (is.null(claims[[name]])) {
      path <- file.path(packages_dir, paste0(name, ".json"))
      if (file.exists(path)) {
        file.remove(path)
        removed <- c(removed, name)
      }
    } else {
      remaining[[name]] <- state$managed[[name]]
    }
  }
  state$managed <- remaining
  write_state(state, state_path)

  write_gha_output("removed", removed)
  cat("\nRemoved ", length(removed), " package(s).\n", sep = "")
}

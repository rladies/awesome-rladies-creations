#!/usr/bin/env Rscript
# Sync data/packages/ from the R-Universe registry.
#
# Authors opt in by adding data/runiverse/<handle>.json. Registering the handle
# is the opt-in: the sync looks at
# https://raw.githubusercontent.com/<handle>/<handle>.r-universe.dev/HEAD/packages.json
# and claims every entry for that handle *except* ones marked
# `"rladies": false`, which is the per-package opt-out.
#
# Because a universe routinely also builds packages its owner only contributes
# to or mirrors, a claim additionally has to pass an authorship check: the
# registrant must be an `aut`/`cre` (or the maintainer) of the package. Without
# that, opt-out semantics would sweep in packages the registrant did not write.
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
      directory_id = e$directory_id %||% NA_character_,
      name = e$name %||% NA_character_
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

registrant_name <- function(optin, dir_lookup) {
  if (!is_blank(optin$name)) {
    return(trimws(optin$name))
  }
  if (!is_blank(optin$directory_id)) {
    nm <- dir_lookup$by_slug[[tolower(trimws(optin$directory_id))]]
    if (!is_blank(nm)) return(nm)
  }
  slug <- dir_lookup$by_handle[[optin$handle]]
  if (!is_blank(slug)) {
    nm <- dir_lookup$by_slug[[tolower(slug)]]
    if (!is_blank(nm)) return(nm)
  }
  NA_character_
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
claim_names <- list()
claim_ids <- list()
for (o in optins) {
  cat("Fetching packages.json for ", o$handle, "\n", sep = "")
  reg_name <- registrant_name(o, dir_lookup)
  if (is.na(reg_name)) {
    cat(
      "  no display name available (add \"name\" to data/runiverse/",
      o$handle,
      ".json); authorship will fall back to repo ownership\n",
      sep = ""
    )
  }
  cfg <- fetch_runiverse_config(o$handle)
  if (is.null(cfg)) {
    cat("  could not fetch packages.json — skipping\n")
    next
  }
  marked <- 0L
  excluded <- 0L
  for (entry in as_pkg_entries(cfg)) {
    if (pkg_opted_out(entry)) {
      excluded <- excluded + 1L
      next
    }
    pkg <- infer_pkg_name(entry)
    if (is_blank(pkg)) {
      next
    }
    if (!valid_pkg_name(pkg)) {
      cat("  ignoring implausible package name: ", pkg, "\n", sep = "")
      next
    }
    claims[[pkg]] <- unique(c(claims[[pkg]] %||% character(0), o$handle))
    claim_names[[pkg]] <- unique(c(
      claim_names[[pkg]] %||% character(0),
      reg_name
    ))
    if (!is.na(reg_name) && !is_blank(o$directory_id)) {
      ids <- claim_ids[[pkg]] %||% character(0)
      ids[[reg_name]] <- trimws(o$directory_id)
      claim_ids[[pkg]] <- ids
    }
    marked <- marked + 1L
  }
  cat(
    "  ",
    marked,
    " package(s) claimed, ",
    excluded,
    " opted out\n",
    sep = ""
  )
}

# Fetch metadata once and apply the authorship gate here, before the mode
# branch, so upsert and remove agree on what is genuinely claimed.
metas <- list()
failed <- character(0)
not_authored <- character(0)
unverified <- character(0)
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
    # Keep it in `claims`: a transient fetch failure must not look like an
    # opt-out and get the package proposed for removal. Same for a rejected
    # name below — both land in `failed`, meaning "claimed but not written".
    failed <- c(failed, pkg)
    next
  }
  # Registering a universe is a blanket opt-in, so the registrant must actually
  # be an author here — universes also build packages their owner only
  # contributes to (e.g. a `ctb` on someone else's package).
  reg_names <- claim_names[[pkg]] %||% character(0)
  reg_names <- reg_names[!is.na(reg_names)]
  if (length(reg_names) > 0) {
    authored <- any(vapply(
      reg_names,
      function(nm) is_authorship(nm, meta$Author, meta$Maintainer),
      logical(1)
    ))
    if (!authored) {
      cat(
        "  skipping ",
        pkg,
        " — ",
        paste(reg_names, collapse = " / "),
        " is not aut/cre\n",
        sep = ""
      )
      not_authored <- c(not_authored, pkg)
      next
    }
  } else if (
    !any(vapply(handles, function(h) owner_match(meta, h), logical(1)))
  ) {
    cat(
      "  skipping ",
      pkg,
      " — cannot verify authorship (no name, repo not owned by opt-in)\n",
      sep = ""
    )
    unverified <- c(unverified, pkg)
    next
  }
  metas[[pkg]] <- meta
}

# Gate rejections stop being claims, so a package that no longer qualifies is
# proposed for removal. Fetch failures stay claimed and are simply not written.
gate_rejected <- c(not_authored, unverified)
claims <- claims[!(names(claims) %in% gate_rejected)]

if (mode == "upsert") {
  added <- character(0)
  updated <- character(0)
  for (pkg in names(metas)) {
    handles <- claims[[pkg]]
    primary <- handles[[1]]
    meta <- metas[[pkg]]
    cand <- normalise_pkg(
      meta,
      "r-universe",
      NA_character_,
      primary,
      NA_character_
    )
    entry <- to_package_shape(cand, dir_lookup)
    # The R-Ladies directory repo is private, so `dir_lookup` is usually empty
    # in CI and `to_package_shape` cannot attach a directory_id. We do know the
    # registrant's own slug from their opt-in file, so link at least that author.
    ids <- claim_ids[[pkg]] %||% character(0)
    if (length(ids) > 0) {
      entry$authors <- lapply(entry$authors, function(a) {
        if (is_blank(a$directory_id)) {
          for (nm in names(ids)) {
            if (names_match(a$name, nm)) {
              a$directory_id <- ids[[nm]]
              break
            }
          }
        }
        a
      })
    }
    if (!valid_pkg_name(entry$name)) {
      cat("  refusing to write implausible name: ", entry$name, "\n", sep = "")
      failed <- c(failed, pkg)
      next
    }
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
  write_gha_output("not_authored", not_authored)
  write_gha_output("unverified", unverified)
  write_gha_output("removal_candidates", removal_candidates)

  cat("\nSummary:\n")
  cat("  added             : ", length(added), "\n", sep = "")
  cat("  updated           : ", length(updated), "\n", sep = "")
  cat("  skipped, unwritable: ", length(failed), "\n", sep = "")
  cat("  skipped, not author: ", length(not_authored), "\n", sep = "")
  cat("  skipped, unverified: ", length(unverified), "\n", sep = "")
  cat("  removal candidates: ", length(removal_candidates), "\n", sep = "")
} else {
  removed <- character(0)
  remaining <- list()
  for (name in names(state$managed)) {
    if (is.null(claims[[name]]) && valid_pkg_name(name)) {
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

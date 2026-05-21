library(jsonlite)

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

ascii <- function(x) {
  if (length(x) == 0) {
    return(character(0))
  }
  iconv(x, to = "ASCII//TRANSLIT", sub = "")
}

is_blank <- function(x) {
  is.null(x) ||
    length(x) == 0 ||
    all(is.na(x)) ||
    !nzchar(trimws(paste(x, collapse = "")))
}

# Build a name/handle -> directory slug lookup from the sibling rladies/directory
# repo. The slug (filename minus .json) is the canonical directory_id.
build_directory_lookup <- function(dir) {
  if (!dir.exists(dir)) {
    message(
      "Directory repo not found at ",
      normalizePath(dir, mustWork = FALSE),
      " — directory_id lookup will be skipped."
    )
    return(list(by_handle = list(), by_name = list(), by_slug = list()))
  }
  files <- list.files(dir, pattern = "\\.json$", full.names = TRUE)
  by_handle <- list()
  by_name <- list()
  by_slug <- list()
  for (f in files) {
    entry <- tryCatch(jsonlite::read_json(f), error = function(e) NULL)
    if (is.null(entry)) {
      next
    }
    id <- sub("\\.json$", "", basename(f))
    gh <- entry$social_media$github
    if (!is_blank(gh)) {
      by_handle[[tolower(trimws(gh))]] <- id
    }
    if (!is_blank(entry$name)) {
      by_name[[tolower(trimws(ascii(entry$name)))]] <- id
      by_slug[[tolower(id)]] <- entry$name
    }
  }
  message("Loaded ", length(files), " directory entries from ", dir)
  list(by_handle = by_handle, by_name = by_name, by_slug = by_slug)
}

# Parse a "Directory IDs" textarea from the issue form. Each non-blank line is
# either:
#   - bare `slug` (we'll resolve the name from the directory entry)
#   - `Author Name = slug` or `slug = Author Name` (explicit pairing for cases
#     where the directory name doesn't quite match the package's Author field)
# Returns a list of (slug, dir_name, explicit_name) entries; lines whose slug
# isn't in the directory are dropped with a warning.
parse_directory_id_pairs <- function(text, dir_lookup) {
  if (is_blank(text)) {
    return(list())
  }
  lines <- trimws(strsplit(text, "[\r\n]+")[[1]])
  lines <- lines[nzchar(lines)]
  pairs <- list()
  for (line in lines) {
    if (grepl("=", line, fixed = TRUE)) {
      halves <- trimws(strsplit(line, "=", fixed = TRUE)[[1]])
      a <- halves[1]
      b <- if (length(halves) >= 2) halves[2] else ""
      # Slug-shaped halves are lowercase letters/digits/hyphens only.
      if (grepl("^[a-z0-9-]+$", a)) {
        slug <- a
        explicit_name <- b
      } else {
        slug <- b
        explicit_name <- a
      }
    } else {
      slug <- line
      explicit_name <- ""
    }
    slug <- tolower(trimws(slug))
    if (!nzchar(slug)) {
      next
    }
    dir_name <- dir_lookup$by_slug[[slug]]
    if (is.null(dir_name)) {
      message(
        "Directory id '",
        slug,
        "' not found in the R-Ladies directory — skipping."
      )
      next
    }
    pairs[[length(pairs) + 1]] <- list(
      slug = slug,
      dir_name = dir_name,
      explicit_name = explicit_name
    )
  }
  pairs
}

# Two names match if either is contained in the other (substring), or if
# their first and last tokens are identical, after ascii/case normalisation.
# Token comparison handles common DESCRIPTION quirks like missing middle
# names ("Athanasia Mo Mowinckel" vs "Athanasia Mowinckel").
names_match <- function(a, b) {
  if (is_blank(a) || is_blank(b)) {
    return(FALSE)
  }
  if (name_in(a, b) || name_in(b, a)) {
    return(TRUE)
  }
  ta <- strsplit(tolower(trimws(ascii(a))), "\\s+")[[1]]
  tb <- strsplit(tolower(trimws(ascii(b))), "\\s+")[[1]]
  ta <- ta[nzchar(ta)]
  tb <- tb[nzchar(tb)]
  if (length(ta) < 2 || length(tb) < 2) {
    return(FALSE)
  }
  ta[1] == tb[1] && ta[length(ta)] == tb[length(tb)]
}

apply_directory_id_pairs <- function(authors, pairs) {
  if (length(pairs) == 0) {
    return(authors)
  }
  for (p in pairs) {
    matched <- FALSE
    candidates <- c(p$dir_name, if (nzchar(p$explicit_name)) p$explicit_name)
    for (i in seq_along(authors)) {
      if (
        any(vapply(
          candidates,
          function(c) names_match(c, authors[[i]]$name),
          logical(1)
        ))
      ) {
        authors[[i]]$directory_id <- p$slug
        matched <- TRUE
        break
      }
    }
    if (!matched) {
      message(
        "Could not match directory_id '",
        p$slug,
        "' (",
        p$dir_name,
        ") to any package author. ",
        "Add `slug = Author Name` in the form to override the matching name."
      )
    }
  }
  authors
}

lookup_directory_id <- function(name, github, dir_lookup) {
  if (!is_blank(github)) {
    h <- tolower(trimws(github))
    if (!is.null(dir_lookup$by_handle[[h]])) return(dir_lookup$by_handle[[h]])
  }
  if (!is_blank(name)) {
    n <- tolower(trimws(ascii(name)))
    if (!is.null(dir_lookup$by_name[[n]])) return(dir_lookup$by_name[[n]])
  }
  NA_character_
}

to_iso_date <- function(s) {
  if (is_blank(s)) {
    return(NA_character_)
  }
  m <- regmatches(s, regexpr("\\d{4}-\\d{2}-\\d{2}", s))
  if (length(m) == 0) NA_character_ else m
}

universe_url <- function(handle) {
  sprintf(
    "https://%s.r-universe.dev/api/packages?fields=Package,Title,Description,URL,BugReports,Maintainer,Author,owner,Date/Publication,published",
    tolower(handle)
  )
}

fetch_universe <- function(handle) {
  url <- universe_url(handle)
  con <- curl::curl(url)
  on.exit(close(con), add = TRUE)
  resp <- tryCatch(readLines(con, warn = FALSE), error = function(e) NULL)
  if (is.null(resp)) {
    return(NULL)
  }
  txt <- paste(resp, collapse = "\n")
  if (!nzchar(txt) || startsWith(txt, "{")) {
    return(NULL)
  }
  tryCatch(
    jsonlite::fromJSON(txt, simplifyVector = FALSE),
    error = function(e) NULL
  )
}

fetch_universe_package <- function(owner, pkg) {
  url <- sprintf(
    "https://%s.r-universe.dev/api/packages/%s?fields=Package,Title,Description,URL,BugReports,Maintainer,Author,owner,Date/Publication,published",
    tolower(owner),
    pkg
  )
  con <- curl::curl(url)
  on.exit(close(con), add = TRUE)
  resp <- tryCatch(readLines(con, warn = FALSE), error = function(e) NULL)
  if (is.null(resp)) {
    return(NULL)
  }
  tryCatch(
    jsonlite::fromJSON(paste(resp, collapse = "\n"), simplifyVector = FALSE),
    error = function(e) NULL
  )
}

# Bioconductor packages are mirrored at bioc.r-universe.dev with the same
# fields as any other r-universe sub-universe, so we reuse the universe shape.
# Returns a list of package metadata entries, one per Bioconductor package.
fetch_bioc_db <- function() {
  fetch_universe("bioc")
}

head_ok <- function(url) {
  h <- curl::new_handle()
  curl::handle_setopt(
    h,
    customrequest = "HEAD",
    nobody = TRUE,
    followlocation = TRUE,
    timeout = 5
  )
  resp <- tryCatch(
    curl::curl_fetch_memory(url, handle = h),
    error = function(e) NULL
  )
  !is.null(resp) && resp$status_code == 200
}

# Pull "owner/repo" out of a github.com URL, or NA.
github_owner_repo <- function(repo_url) {
  if (is_blank(repo_url)) {
    return(NA_character_)
  }
  m <- regmatches(
    repo_url,
    regexec("github\\.com/([^/]+)/([^/?#]+)", repo_url)
  )[[1]]
  if (length(m) < 3) {
    return(NA_character_)
  }
  paste0(sub("\\.git$", "", m[2]), "/", sub("\\.git$", "", m[3]))
}

# Find the first <img src="..."> in the upper part of a README, looking for
# either an explicit "logo" filename or any image close to the H1 heading.
readme_logo_src <- function(readme_text) {
  lines <- strsplit(readme_text, "\n", fixed = TRUE)[[1]]
  head_lines <- head(lines, 30)
  imgs <- regmatches(
    head_lines,
    regexpr(
      "<img\\s+[^>]*?src\\s*=\\s*[\"']([^\"']+)[\"']",
      head_lines,
      perl = TRUE,
      ignore.case = TRUE
    )
  )
  imgs <- unlist(imgs)
  if (length(imgs) == 0) {
    return(NA_character_)
  }
  srcs <- sub(
    '.*src\\s*=\\s*["\']([^"\']+)["\'].*',
    "\\1",
    imgs,
    perl = TRUE,
    ignore.case = TRUE
  )
  logo_hit <- grep("logo|hex", srcs, ignore.case = TRUE, value = TRUE)
  if (length(logo_hit) > 0) {
    return(logo_hit[1])
  }
  srcs[1]
}

resolve_readme_src <- function(src, owner_repo) {
  if (grepl("^https?://", src)) {
    return(src)
  }
  if (is.na(owner_repo)) {
    return(NA_character_)
  }
  src <- sub("^\\./", "", src)
  sprintf("https://raw.githubusercontent.com/%s/HEAD/%s", owner_repo, src)
}

# Probe in order: pkgdown standard paths -> raw man/figures/logo -> README
# img tag near the H1.
probe_logo_url <- function(pkdown_url, repo_url = NA_character_) {
  if (!is_blank(pkdown_url)) {
    base <- sub("/+$", "", pkdown_url)
    pkgdown_candidates <- c(
      paste0(base, "/logo.png"),
      paste0(base, "/logo.svg"),
      paste0(base, "/reference/figures/logo.png"),
      paste0(base, "/reference/figures/logo.svg")
    )
    for (u in pkgdown_candidates) {
      if (head_ok(u)) return(u)
    }
  }

  owner_repo <- github_owner_repo(repo_url)
  if (is.na(owner_repo)) {
    return(NA_character_)
  }

  raw_candidates <- c(
    sprintf(
      "https://raw.githubusercontent.com/%s/HEAD/man/figures/logo.png",
      owner_repo
    ),
    sprintf(
      "https://raw.githubusercontent.com/%s/HEAD/man/figures/logo.svg",
      owner_repo
    )
  )
  for (u in raw_candidates) {
    if (head_ok(u)) return(u)
  }

  readme_url <- sprintf(
    "https://raw.githubusercontent.com/%s/HEAD/README.md",
    owner_repo
  )
  readme <- tryCatch(
    {
      h <- curl::new_handle()
      curl::handle_setopt(h, followlocation = TRUE, timeout = 8)
      resp <- curl::curl_fetch_memory(readme_url, handle = h)
      if (resp$status_code != 200) {
        return(NA_character_)
      }
      rawToChar(resp$content)
    },
    error = function(e) NA_character_
  )
  if (is.na(readme)) {
    return(NA_character_)
  }

  src <- readme_logo_src(readme)
  if (is.na(src)) {
    return(NA_character_)
  }
  resolved <- resolve_readme_src(src, owner_repo)
  if (is.na(resolved) || !head_ok(resolved)) {
    return(NA_character_)
  }
  resolved
}

owner_match <- function(pkg, handle) {
  isTRUE(tolower(pkg$`_owner` %||% "") == tolower(handle))
}

name_in <- function(needle, haystack) {
  if (is_blank(needle) || is_blank(haystack)) {
    return(FALSE)
  }
  grepl(tolower(ascii(needle)), tolower(ascii(haystack)), fixed = TRUE)
}

accepted_roles <- c("cre", "aut")

roles_for <- function(name, author_text) {
  if (is_blank(author_text)) {
    return("unknown")
  }
  hay <- tolower(ascii(author_text))
  needle <- tolower(ascii(name))
  pos <- regexpr(needle, hay, fixed = TRUE)
  if (pos == -1) {
    return(character(0))
  }
  tail <- substr(hay, pos + attr(pos, "match.length"), nchar(hay))
  m <- regmatches(tail, regexpr("\\s*\\[([^]]+)\\]", tail))
  if (length(m) == 0) {
    return("unknown")
  }
  inside <- sub("^\\s*\\[", "", sub("\\]$", "", m))
  trimws(strsplit(inside, ",")[[1]])
}

is_authorship <- function(name, author_text, maintainer_text) {
  if (name_in(name, maintainer_text)) {
    return(TRUE)
  }
  r <- roles_for(name, author_text)
  if (identical(r, "unknown")) {
    return(TRUE)
  }
  any(r %in% accepted_roles)
}

split_author_entries <- function(text) {
  s <- gsub("\\s+", " ", text)
  chars <- strsplit(s, "", fixed = TRUE)[[1]]
  if (length(chars) == 0) {
    return(character(0))
  }
  depth_b <- 0L
  depth_p <- 0L
  cuts <- integer(0)
  for (i in seq_along(chars)) {
    ch <- chars[i]
    if (ch == "[") {
      depth_b <- depth_b + 1L
    } else if (ch == "]") {
      depth_b <- max(depth_b - 1L, 0L)
    } else if (ch == "(") {
      depth_p <- depth_p + 1L
    } else if (ch == ")") {
      depth_p <- max(depth_p - 1L, 0L)
    } else if (ch == "," && depth_b == 0L && depth_p == 0L) {
      cuts <- c(cuts, i)
    }
  }
  starts <- c(1L, cuts + 1L)
  ends <- c(cuts - 1L, length(chars))
  parts <- vapply(
    seq_along(starts),
    function(k) {
      paste(chars[starts[k]:ends[k]], collapse = "")
    },
    character(1)
  )
  trimws(parts[nzchar(trimws(parts))])
}

parse_authors <- function(text) {
  if (is_blank(text)) {
    return(list())
  }
  parts <- split_author_entries(text)
  lapply(parts, function(p) {
    roles_m <- regmatches(p, regexpr("\\[([^]]*)\\]", p))
    roles <- if (length(roles_m) > 0) {
      trimws(strsplit(gsub("^\\[|\\]$", "", roles_m), ",")[[1]])
    } else {
      character(0)
    }
    orcid_m <- regmatches(
      p,
      regexpr("\\d{4}-\\d{4}-\\d{4}-\\d{3}[0-9X]", p, perl = TRUE)
    )
    orcid <- if (length(orcid_m) > 0) orcid_m else NA_character_
    boundary <- regexpr("[\\[\\(]", p, perl = TRUE)
    name <- if (boundary > 0) trimws(substr(p, 1, boundary - 1)) else trimws(p)
    name <- trimws(sub("\\s*<[^>]*>\\s*$", "", name))
    list(name = name, roles = as.list(roles), orcid = orcid)
  })
}

parse_pkg_urls <- function(url_str) {
  if (is_blank(url_str)) {
    return(list(
      repo_url = NA_character_,
      pkdown_url = NA_character_,
      other = list()
    ))
  }
  parts <- trimws(unlist(strsplit(url_str, "[,\n]")))
  parts <- parts[nzchar(parts)]
  is_gh <- grepl("github\\.com|gitlab\\.com|codeberg\\.org", parts)
  list(
    repo_url = if (any(is_gh)) parts[which(is_gh)[1]] else NA_character_,
    pkdown_url = if (any(!is_gh)) parts[which(!is_gh)[1]] else NA_character_,
    other = as.list(c(parts[is_gh][-1], parts[!is_gh][-1]))
  )
}

parse_maintainer_str <- function(m) {
  if (is_blank(m)) {
    return(list(name = NA_character_, email = NA_character_))
  }
  email_m <- regmatches(m, regexpr("<([^>]+)>", m))
  email <- if (length(email_m) > 0) gsub("[<>]", "", email_m) else NA_character_
  name <- trimws(sub("\\s*<[^>]*>\\s*$", "", m))
  list(name = name, email = email)
}

# Build a single person entry (name, roles, orcid, directory_id). Used for
# both `authors` and `maintainers` arrays. Maintainer-specific fields like
# `email` are added by the caller.
person_entry <- function(person, dir_lookup) {
  out <- list(name = person$name)
  if (length(person$roles) > 0) {
    out$roles <- person$roles
  }
  if (!is_blank(person$orcid)) {
    out$orcid <- person$orcid
  }
  did <- lookup_directory_id(person$name, NA, dir_lookup)
  if (!is.na(did)) {
    out$directory_id <- did
  }
  out
}

to_package_shape <- function(cand, dir_lookup) {
  urls <- parse_pkg_urls(cand$url)
  m <- parse_maintainer_str(cand$maintainer)

  repo_url <- urls$repo_url
  if (
    is.na(repo_url) && !is_blank(cand$repo_owner) && !is_blank(cand$package)
  ) {
    repo_url <- sprintf(
      "https://github.com/%s/%s",
      cand$repo_owner,
      cand$package
    )
  }
  if (is.na(repo_url) && !is_blank(cand$bug_reports)) {
    repo_url <- sub("/issues/?$", "", cand$bug_reports)
  }

  parsed <- cand$authors
  # Some old DESCRIPTION fields are role-less; if we know who the maintainer is
  # from the Maintainer field but they're missing from Author, attach "cre" to
  # the matching entry. If the maintainer isn't in Author at all, append them.
  has_cre <- any(vapply(
    parsed,
    function(a) "cre" %in% unlist(a$roles),
    logical(1)
  ))
  if (!has_cre && !is.na(m$name)) {
    match_idx <- which(vapply(
      parsed,
      function(a) names_match(a$name, m$name),
      logical(1)
    ))
    if (length(match_idx) > 0) {
      idx <- match_idx[1]
      parsed[[idx]]$roles <- as.list(unique(c(
        unlist(parsed[[idx]]$roles),
        "cre"
      )))
    } else {
      parsed <- c(
        parsed,
        list(list(name = m$name, roles = list("cre"), orcid = NA_character_))
      )
    }
  }

  authors <- lapply(parsed, function(a) {
    entry <- person_entry(a, dir_lookup)
    if (!is.na(m$email) && name_in(a$name, m$name)) {
      entry$email <- m$email
    }
    entry
  })

  logo_url <- probe_logo_url(urls$pkdown_url, repo_url)

  list(
    name = cand$package,
    title = str_or_na(cand$title),
    description = str_or_na(cand$description),
    repo_url = str_or_na(repo_url),
    pkdown_url = str_or_na(urls$pkdown_url),
    bug_reports_url = str_or_na(cand$bug_reports),
    logo_url = str_or_na(logo_url),
    last_updated = str_or_na(cand$last_updated),
    authors = authors
  )
}

merge_pkg <- function(existing, new) {
  if (length(existing) == 0) {
    return(new)
  }
  scalar_fields <- c(
    "name",
    "title",
    "description",
    "repo_url",
    "pkdown_url",
    "bug_reports_url",
    "logo_url",
    "last_updated"
  )
  for (f in scalar_fields) {
    if (is_blank(existing[[f]]) && !is_blank(new[[f]])) {
      existing[[f]] <- new[[f]]
    }
  }
  if (is_blank(existing$authors) && length(new$authors) > 0) {
    existing$authors <- new$authors
  }
  existing
}

write_pkg <- function(entry, dir) {
  path <- file.path(dir, paste0(entry$name, ".json"))
  existing <- if (file.exists(path)) jsonlite::read_json(path) else list()
  merged <- merge_pkg(existing, entry)
  # Normalise scalar fields to NA_character_ when missing/NULL so write_json
  # serialises them as `null` (per `na = "null"` below) rather than `{}`,
  # which would otherwise happen on a read+rewrite cycle and fail schema
  # validation (string|null fields can't be empty objects).
  scalar_fields <- c(
    "name",
    "title",
    "description",
    "repo_url",
    "pkdown_url",
    "bug_reports_url",
    "logo_url",
    "last_updated"
  )
  for (f in scalar_fields) {
    if (is.null(merged[[f]]) || length(merged[[f]]) == 0) {
      merged[[f]] <- NA_character_
    }
  }
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  jsonlite::write_json(
    merged,
    path,
    pretty = TRUE,
    auto_unbox = TRUE,
    na = "null"
  )
  path
}

str_or_na <- function(x) {
  if (is_blank(x)) NA_character_ else as.character(x)
}

normalise_pkg <- function(
  pkg,
  source,
  matched_author,
  handle = NA,
  roles = NULL
) {
  desc <- str_or_na(pkg$Description)
  if (!is.na(desc)) {
    desc <- trimws(gsub("\\s+", " ", desc))
  }
  last_updated <- to_iso_date(pkg$`Date/Publication`) %||%
    to_iso_date(pkg$`_published`)
  list(
    package = str_or_na(pkg$Package),
    title = str_or_na(pkg$Title),
    description = desc,
    repo_owner = str_or_na(pkg$`_owner`),
    url = str_or_na(pkg$URL),
    bug_reports = str_or_na(pkg$BugReports),
    maintainer = str_or_na(pkg$Maintainer),
    last_updated = last_updated,
    authors = parse_authors(pkg$Author),
    matched_author = matched_author,
    matched_handle = handle,
    matched_roles = roles %||% NA_character_,
    source = source
  )
}

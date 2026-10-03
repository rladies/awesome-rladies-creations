library(here)
library(jsonlite)

source(here::here("scripts", "discover_helpers.R"))
source(here::here("scripts", "scrape_helpers.R"))

content_dir <- here::here("data/content")
directory_dir <- here::here("..", "directory", "data", "json")

env_or_arg <- function(env_name, arg_index = NA) {
  v <- Sys.getenv(env_name, unset = "")
  if (nzchar(v)) {
    return(v)
  }
  if (is.na(arg_index)) {
    return("")
  }
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) >= arg_index) args[arg_index] else ""
}

content_type <- trimws(env_or_arg("CONTENT_TYPE", 1))
content_url <- trimws(env_or_arg("CONTENT_URL", 2))
override_title <- trimws(env_or_arg("CONTENT_TITLE"))
language <- trimws(env_or_arg("CONTENT_LANGUAGE"))
override_photo <- trimws(env_or_arg("CONTENT_PHOTO_URL"))
override_rss <- trimws(env_or_arg("CONTENT_RSS_FEED"))
override_description <- trimws(env_or_arg("CONTENT_DESCRIPTION"))
author_name <- trimws(env_or_arg("AUTHOR_NAME"))
author_twitter <- trimws(env_or_arg("AUTHOR_TWITTER"))
author_mastodon <- trimws(env_or_arg("AUTHOR_MASTODON"))
author_bluesky <- trimws(env_or_arg("AUTHOR_BLUESKY"))
author_github <- trimws(env_or_arg("AUTHOR_GITHUB"))
author_linkedin <- trimws(env_or_arg("AUTHOR_LINKEDIN"))
author_orcid <- trimws(env_or_arg("AUTHOR_ORCID"))
directory_ids_text <- env_or_arg("DIRECTORY_IDS")

if (!nzchar(content_type)) content_type <- "blog"
if (!nzchar(content_url)) {
  stop("Content URL is required (env CONTENT_URL).")
}
if (!nzchar(language)) {
  stop("Language is required (env CONTENT_LANGUAGE).")
}
if (!nzchar(author_name)) {
  stop("Author Name is required (env AUTHOR_NAME).")
}

normalise_url <- function(u) {
  u <- trimws(u)
  if (!grepl("^https?://", u, ignore.case = TRUE)) {
    u <- paste0("https://", u)
  }
  sub("/+$", "", u)
}

content_url <- normalise_url(content_url)
cat("Processing", content_type, "URL:", content_url, "\n")

cat("Fetching", content_url, "...\n")
html <- fetch_html(content_url)
if (is.na(html)) {
  message("Could not fetch the URL — proceeding with form values only.")
  html <- ""
}

scraped_title <- scrape_title(html)
scraped_description <- scrape_description(html)
scraped_image <- scrape_image(html, content_url)
scraped_feed <- if (content_type == "youtube") {
  cid <- youtube_channel_id(content_url, html)
  if (!is.na(cid)) {
    sprintf("https://www.youtube.com/feeds/videos.xml?channel_id=%s", cid)
  } else {
    NA_character_
  }
} else {
  scrape_feed(html, content_url)
}

resolved <- list(
  title = if (nzchar(override_title)) override_title else scraped_title,
  description = if (nzchar(override_description)) override_description else scraped_description,
  photo_url = if (nzchar(override_photo)) override_photo else scraped_image,
  rss_feed = if (nzchar(override_rss)) override_rss else scraped_feed
)

cat("Resolved fields:\n")
for (k in names(resolved)) {
  cat("  ", k, ":", if (is.na(resolved[[k]])) "<none>" else resolved[[k]], "\n")
}

# --- Author + social media -------------------------------------------------

social <- list()
if (nzchar(author_twitter)) social$twitter <- author_twitter
if (nzchar(author_mastodon)) social$mastodon <- author_mastodon
if (nzchar(author_bluesky)) social$bluesky <- author_bluesky
if (nzchar(author_github)) social$github <- author_github
if (nzchar(author_linkedin)) social$linkedin <- author_linkedin
if (nzchar(author_orcid)) social$orcid <- author_orcid

author <- list(name = author_name)
if (length(social) > 0) {
  author$social_media <- list(social)
}

# Apply directory_id pairings to the (single) author from the form.
dir_lookup <- build_directory_lookup(directory_dir)
pairs <- parse_directory_id_pairs(directory_ids_text, dir_lookup)
if (length(pairs) > 0) {
  cat("Applying", length(pairs), "directory_id pairings\n")
  authors_after <- apply_directory_id_pairs(list(author), pairs)
  author <- authors_after[[1]]
}

# --- Assemble entry --------------------------------------------------------

entry <- list(
  title = if (is.na(resolved$title)) author_name else resolved$title,
  type = content_type,
  url = content_url,
  language = language,
  authors = list(author)
)
if (!is.na(resolved$description)) entry$description <- resolved$description
if (!is.na(resolved$photo_url)) entry$photo_url <- resolved$photo_url
if (!is.na(resolved$rss_feed)) entry$rss_feed <- resolved$rss_feed

# Filename = host (strip protocol and www.)
host <- sub("^https?://", "", content_url, ignore.case = TRUE)
host <- sub("^www\\.", "", host, ignore.case = TRUE)
host <- sub("/.*$", "", host)
filename <- paste0(host, ".json")
path <- file.path(content_dir, filename)

if (!dir.exists(content_dir)) {
  dir.create(content_dir, recursive = TRUE)
}

# Merge with any existing file so we don't overwrite manual edits.
if (file.exists(path)) {
  existing <- jsonlite::read_json(path)
  for (k in names(existing)) {
    if (k == "authors") next
    if (is_blank(entry[[k]]) && !is_blank(existing[[k]])) {
      entry[[k]] <- existing[[k]]
    }
  }
  if (!is_blank(existing$authors) && length(existing$authors) > 0) {
    entry$authors <- existing$authors
  }
}

jsonlite::write_json(
  entry,
  path,
  pretty = TRUE,
  auto_unbox = TRUE,
  na = "null"
)

cat("Wrote", path, "\n")

gha_out <- Sys.getenv("GITHUB_OUTPUT", unset = "")
if (nzchar(gha_out)) {
  rel_path <- sub(
    paste0("^", here::here(), "/?"),
    "",
    path,
    fixed = FALSE
  )
  writeLines(
    c(
      sprintf("file_path=%s", rel_path),
      sprintf("filename=%s", host),
      sprintf("content_type=%s", content_type)
    ),
    gha_out
  )
}

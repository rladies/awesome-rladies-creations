source(here::here("scripts", "discover_helpers.R"))

decode_html_entities <- function(s) {
  if (is_blank(s)) {
    return(s)
  }
  named <- c(
    "amp" = "&",
    "lt" = "<",
    "gt" = ">",
    "quot" = "\"",
    "apos" = "'",
    "nbsp" = " ",
    "rsquo" = "’",
    "lsquo" = "‘",
    "rdquo" = "”",
    "ldquo" = "“",
    "ndash" = "–",
    "mdash" = "—",
    "hellip" = "…"
  )
  for (n in names(named)) {
    s <- gsub(paste0("&", n, ";"), named[[n]], s, fixed = TRUE)
  }
  hex_matches <- regmatches(s, gregexpr("&#x([0-9a-fA-F]+);", s, perl = TRUE))[[1]]
  for (m in hex_matches) {
    code <- strtoi(sub("&#x([0-9a-fA-F]+);", "\\1", m, perl = TRUE), 16L)
    s <- sub(m, intToUtf8(code), s, fixed = TRUE)
  }
  dec_matches <- regmatches(s, gregexpr("&#(\\d+);", s, perl = TRUE))[[1]]
  for (m in dec_matches) {
    code <- as.integer(sub("&#(\\d+);", "\\1", m, perl = TRUE))
    s <- sub(m, intToUtf8(code), s, fixed = TRUE)
  }
  s
}

fetch_html <- function(url) {
  h <- curl::new_handle()
  curl::handle_setopt(
    h,
    followlocation = TRUE,
    timeout = 15,
    useragent = "rladies-content-bot/1.0"
  )
  resp <- tryCatch(
    curl::curl_fetch_memory(url, handle = h),
    error = function(e) NULL
  )
  if (is.null(resp) || resp$status_code >= 400) {
    return(NA_character_)
  }
  rawToChar(resp$content)
}

meta_value <- function(html, predicate_attr, predicate_value, value_attr = "content") {
  pat <- sprintf(
    "<meta\\b[^>]*\\b%s\\s*=\\s*[\"']%s[\"'][^>]*>",
    predicate_attr,
    predicate_value
  )
  m <- regmatches(html, regexpr(pat, html, ignore.case = TRUE, perl = TRUE))
  if (length(m) == 0) {
    return(NA_character_)
  }
  val_pat <- sprintf("\\b%s\\s*=\\s*[\"']([^\"']+)[\"']", value_attr)
  vm <- regmatches(m, regexpr(val_pat, m, ignore.case = TRUE, perl = TRUE))
  if (length(vm) == 0) {
    return(NA_character_)
  }
  sub(val_pat, "\\1", vm, ignore.case = TRUE, perl = TRUE)
}

scrape_title <- function(html) {
  og <- meta_value(html, "property", "og:title")
  if (!is_blank(og)) {
    return(decode_html_entities(trimws(og)))
  }
  m <- regmatches(html, regexpr("<title[^>]*>([\\s\\S]*?)</title>", html, ignore.case = TRUE, perl = TRUE))
  if (length(m) == 0) {
    return(NA_character_)
  }
  inner <- sub("<title[^>]*>([\\s\\S]*?)</title>", "\\1", m, ignore.case = TRUE, perl = TRUE)
  decode_html_entities(trimws(gsub("\\s+", " ", inner)))
}

scrape_description <- function(html) {
  og <- meta_value(html, "property", "og:description")
  if (!is_blank(og)) {
    return(decode_html_entities(trimws(og)))
  }
  md <- meta_value(html, "name", "description")
  if (!is_blank(md)) {
    return(decode_html_entities(trimws(md)))
  }
  NA_character_
}

scrape_image <- function(html, base_url) {
  og <- meta_value(html, "property", "og:image")
  if (is_blank(og)) {
    return(NA_character_)
  }
  if (grepl("^https?://", og, ignore.case = TRUE)) {
    return(og)
  }
  if (startsWith(og, "//")) {
    return(paste0("https:", og))
  }
  if (startsWith(og, "/")) {
    base_root <- sub("(https?://[^/]+).*", "\\1", base_url)
    return(paste0(base_root, og))
  }
  paste0(sub("/+$", "", base_url), "/", og)
}

scrape_feed <- function(html, base_url) {
  pat <- "<link\\b[^>]*\\brel\\s*=\\s*[\"']alternate[\"'][^>]*>"
  candidates <- regmatches(
    html,
    gregexpr(pat, html, ignore.case = TRUE, perl = TRUE)
  )[[1]]
  for (tag in candidates) {
    if (!grepl("application/(rss|atom)\\+xml", tag, ignore.case = TRUE)) {
      next
    }
    href_m <- regmatches(
      tag,
      regexpr("\\bhref\\s*=\\s*[\"']([^\"']+)[\"']", tag, perl = TRUE)
    )
    if (length(href_m) == 0) {
      next
    }
    href <- sub(".*href\\s*=\\s*[\"']([^\"']+)[\"'].*", "\\1", href_m, perl = TRUE)
    if (grepl("^https?://", href, ignore.case = TRUE)) {
      return(href)
    }
    if (startsWith(href, "//")) {
      return(paste0("https:", href))
    }
    if (startsWith(href, "/")) {
      base_root <- sub("(https?://[^/]+).*", "\\1", base_url)
      return(paste0(base_root, href))
    }
    return(paste0(sub("/+$", "", base_url), "/", href))
  }
  NA_character_
}

# YouTube channel feeds are at a stable URL keyed by the channel id, but
# vanity URLs (/c/foo, /@handle) need a page fetch to discover the id.
youtube_channel_id <- function(url, html) {
  m <- regmatches(url, regexpr("/channel/([A-Za-z0-9_-]+)", url))
  if (length(m) > 0) {
    return(sub(".*/channel/", "", m))
  }
  if (is_blank(html)) {
    return(NA_character_)
  }
  m2 <- regmatches(
    html,
    regexpr("\"channelId\"\\s*:\\s*\"(UC[A-Za-z0-9_-]+)\"", html, perl = TRUE)
  )
  if (length(m2) > 0) {
    return(sub(".*\"channelId\"\\s*:\\s*\"", "", sub("\".*", "", m2)))
  }
  m3 <- regmatches(
    html,
    regexpr("https://www\\.youtube\\.com/feeds/videos\\.xml\\?channel_id=([A-Za-z0-9_-]+)", html)
  )
  if (length(m3) > 0) {
    return(sub(".*channel_id=", "", m3))
  }
  NA_character_
}

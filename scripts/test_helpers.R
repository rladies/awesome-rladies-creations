#!/usr/bin/env Rscript
# Assertions for the matching helpers in discover_helpers.R.
#
# Deliberately base R: the project has no testthat in renv.lock and these
# helpers decide whose work gets attributed to whom, so they are worth a cheap
# regression net rather than no net at all. Run with:
#   Rscript scripts/test_helpers.R

library(here)
source(here::here("scripts", "discover_helpers.R"))

failures <- character(0)
ok <- function(label, expr) {
  res <- tryCatch(isTRUE(expr), error = function(e) {
    paste("error:", conditionMessage(e))
  })
  if (isTRUE(res)) {
    cat("  ok   ", label, "\n", sep = "")
  } else {
    cat("  FAIL ", label, "\n", sep = "")
    failures <<- c(failures, label)
  }
}

# DESCRIPTION Author fields are hard-wrapped by CRAN, so a name can arrive with
# a newline inside it. moosecounter really does ship "Steffi\nLaZerte [aut]".
wrapped <- paste0(
  "Subhash Lele [aut], Sophie Czetwertynski [aut], Peter Solymos\n",
  "[aut, cre] (<https://orcid.org/0000-0001-7337-1740>), Steffi\n",
  "LaZerte [aut], Government of Yukon [fnd]"
)

cat("norm_ws\n")
ok("collapses newlines", norm_ws("Steffi\nLaZerte") == "Steffi LaZerte")
ok("collapses runs", norm_ws("a   b\t\nc") == "a b c")
ok("trims", norm_ws("  x  ") == "x")

cat("name_in\n")
ok("matches a line-wrapped name", name_in("Steffi LaZerte", wrapped))
ok("matches an unwrapped name", name_in("Subhash Lele", wrapped))
ok("rejects an absent name", !name_in("Ada Lovelace", wrapped))
ok("blank needle is FALSE", !name_in("", wrapped))
ok("blank haystack is FALSE", !name_in("Steffi LaZerte", ""))

cat("roles_for\n")
ok(
  "reads roles across a line break",
  identical(roles_for("Steffi LaZerte", wrapped), "aut")
)
ok(
  "reads multiple roles",
  identical(roles_for("Peter Solymos", wrapped), c("aut", "cre"))
)
ok(
  "unknown when there are no roles at all",
  identical(roles_for("Someone", "Someone"), "unknown")
)

cat("is_authorship\n")
ok(
  "aut counts, even line-wrapped",
  is_authorship("Steffi LaZerte", wrapped, "Peter Solymos <p@example.com>")
)
# The motus case: a ctb on someone else's package must not be claimed, or
# opt-out syncing would sweep in packages the registrant did not write.
ctb_only <- paste0(
  "Birds Canada [aut, cre],\nJohn Brzustowski [aut],\n",
  "Steffi LaZerte [ctb],\nJoey Bernard [ctb]"
)
ok(
  "ctb alone does not count",
  !is_authorship("Steffi LaZerte", ctb_only, "Birds Canada <m@example.com>")
)
ok(
  "being the maintainer counts regardless of roles",
  is_authorship("Steffi LaZerte", ctb_only, "Steffi LaZerte <s@example.com>")
)
ok(
  "role-less DESCRIPTION is given the benefit of the doubt",
  is_authorship("Jane Doe", "Jane Doe", "Jane Doe <j@example.com>")
)

cat("pkg_opted_out\n")
ok("explicit false opts out", pkg_opted_out(list(rladies = FALSE)))
ok("absent key stays in", !pkg_opted_out(list(package = "x")))
ok("true stays in", !pkg_opted_out(list(rladies = TRUE)))
ok("NULL stays in", !pkg_opted_out(list(rladies = NULL)))
ok("NA stays in", !pkg_opted_out(list(rladies = NA)))
# packages.json is hand-written. Missing an opt-out means publishing someone's
# package against their stated wish, so accept the spellings people type.
ok('string "false" opts out', pkg_opted_out(list(rladies = "false")))
ok('string "FALSE" opts out', pkg_opted_out(list(rladies = "FALSE")))
ok('string " No " opts out', pkg_opted_out(list(rladies = " No ")))
ok('string "off" opts out', pkg_opted_out(list(rladies = "off")))
ok("numeric 0 opts out", pkg_opted_out(list(rladies = 0)))
ok('string "true" stays in', !pkg_opted_out(list(rladies = "true")))
ok('unrecognised value stays in', !pkg_opted_out(list(rladies = "maybe")))
ok("non-list entry stays in", !pkg_opted_out("junk"))

cat("valid_pkg_name\n")
ok("accepts a normal name", valid_pkg_name("tourr"))
ok("accepts periods", valid_pkg_name("ggseg.formats"))
ok("accepts digits", valid_pkg_name("r2d3"))
ok("accepts mixed case", valid_pkg_name("RobMixReg"))
# These reach file.path(dir, paste0(name, ".json")) on a job that pushes to main.
ok("rejects parent traversal", !valid_pkg_name("../../.github/workflows/x"))
ok("rejects a slash", !valid_pkg_name("a/b"))
ok("rejects a leading dot", !valid_pkg_name(".hidden"))
ok("rejects a trailing dot", !valid_pkg_name("trailing."))
ok("rejects a leading digit", !valid_pkg_name("2fast"))
ok("rejects whitespace", !valid_pkg_name("has space"))
ok("rejects empty", !valid_pkg_name(""))
ok("rejects NA", !valid_pkg_name(NA_character_))
ok("rejects NULL", !valid_pkg_name(NULL))

cat("as_pkg_entries\n")
ok("array of entries passes through", length(as_pkg_entries(list(
  list(package = "a"),
  list(package = "b")
))) == 2)
ok(
  "a single JSON object is wrapped, not iterated field-wise",
  identical(as_pkg_entries(list(package = "a", url = "u")), list(list(
    package = "a",
    url = "u"
  )))
)
ok("NULL becomes empty", length(as_pkg_entries(NULL)) == 0)
ok(
  "stray scalars are dropped",
  length(as_pkg_entries(list(list(package = "a"), "junk"))) == 1
)

cat("\n")
if (length(failures) > 0) {
  cat(length(failures), "failure(s):\n")
  cat(paste0("  - ", failures, collapse = "\n"), "\n")
  quit(status = 1)
}
cat("All assertions passed.\n")

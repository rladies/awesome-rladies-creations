# About

This repository collects R-Ladies community resources: online content (one JSON
per blog, website or YouTube channel) and R packages (one JSON per package).
Contributions are welcome from anyone who identifies with the R-Ladies community.

# How to contribute

The easiest way to add an entry is to **open an issue** using one of the two
issue forms — a bot will fetch the metadata, generate the JSON file, push it
to a new branch, and open a draft pull request linked to your issue. You'll
be tagged on the PR so you can review the file and request adjustments before
it is merged.

If you'd rather edit JSON directly, you can also fork the repo, add the file
under `data/content/` or `data/packages/`, and open a PR — see
[Editing JSON directly](#editing-json-directly) below.

If you maintain an R-Universe and would like us to keep your packages here in
sync automatically, see
[Opt in to R-Universe sync](#opt-in-to-r-universe-sync) below — you flag
which packages you want listed inside your own `packages.json`, and a
scheduled job picks them up.

## Recommended: open an issue

Pick the form that matches what you're submitting:

- **[New Online Content](.github/ISSUE_TEMPLATE/new-content.yaml)** — for
  blogs, personal websites and YouTube channels. The bot fetches the URL and
  fills in title / description / image / RSS feed by scraping the page (you
  can override any of those in the form).
- **[New Package](.github/ISSUE_TEMPLATE/new-package.yaml)** — for an R
  package authored by someone in the R-Ladies community. The bot looks the
  package up on r-universe (if you give an owner) and falls back to CRAN.

Both forms accept an optional **Directory IDs** field. If you (or co-authors)
have an entry in the [R-Ladies directory](https://github.com/rladies/directory),
list one slug per line and the bot will link the entry to your profile(s).
Each line is either:

```
athanasia-mo-mowinckel
alejandra-tapia = Alejandra Tapia González
```

The bare-slug form looks up the directory entry's name and tries to match a
package author / content author by name. Use the `slug = Author Name` form
when the directory name doesn't match what's on CRAN / on the page.

### What the bot does

When you submit the form (or apply the `content-submission` /
`package-submission` label to an existing issue):

1. It parses the form, validates required fields, and runs the matching R
   script (`scripts/issue_to_content.R` or `scripts/issue_to_package.R`).
2. It writes the generated JSON to `data/content/<host>.json` or
   `data/packages/<pkg>.json`.
3. It pushes a branch named `auto/new-content-...` or `auto/new-package-...`
   and opens a **draft PR** that closes your issue.
4. It comments on the issue with a link to the PR so you can review the
   generated file and request changes.

If the bot can't find the package or fetch the URL, it leaves a comment
explaining what went wrong. Edit the issue and remove + re-apply the
`content-submission` / `package-submission` label to retry.

## Editing JSON directly

All content metadata files live in `data/content/` and package metadata files
live in `data/packages/`. Each entry is a single JSON file used to render
pages and to generate the aggregated JSONs in `data/website/`.

### File name conventions

- Online content (`data/content/`): the site host, with no protocol or `www.`
  prefix (e.g. `your-blog.com.json`).
- Packages (`data/packages/`): the package or repository name
  (e.g. `meetupr.json`).

### Schemas

- Content: `scripts/json_schema/content.json`. Required fields: `title`,
  `url`, `type` (`blog`, `website` or `youtube`), `authors`, `language`.
- Packages: `scripts/json_schema/packages.json`. Required fields: `name`,
  `description`, `authors`. Recommended: `repo_url`, `pkdown_url`,
  `bug_reports_url`, `logo_url`.

### Authors and social media

The `authors` array accepts objects with `name` and an optional
`social_media` array; only the first three social media items are rendered
in the site UI. Include handles for the services you want shown (twitter,
github, mastodon, bluesky, etc.).

For packages, authors may also have an `email`, `roles` (`aut`, `cre`, …),
`orcid` and `directory_id`.

### Validation and aggregation

- Validate locally with `Rscript scripts/validate_jsons.R`.
- Aggregated outputs (`data/website/awesome_blogs.json` and
  `data/website/awesome_packages.json`) are produced by
  `scripts/generate_website_jsons.R` on push to `main`.

## Opt in to R-Universe sync

If you already curate your packages in an R-Universe (the
`<handle>/<handle>.r-universe.dev` repo on GitHub), you can let this
repository follow it automatically instead of opening an issue per package.

**One-time setup** — open a PR adding `data/runiverse/<your-handle>.json`:

```json
{
  "handle": "drmowinckels",
  "directory_id": "athanasia-mo-mowinckel"
}
```

- `handle` is the sub-domain of your R-Universe (`drmowinckels` for
  `drmowinckels.r-universe.dev`). It's also the GitHub user or org that owns
  the `<handle>.r-universe.dev` config repo.
- `directory_id` is optional — your slug in the
  [R-Ladies directory](https://github.com/rladies/directory).

**Per package** — in your R-Universe's `packages.json`, set `"rladies":
true` on each entry you want listed here:

```json
[
  {
    "package": "ggseg",
    "url": "https://github.com/ggsegverse/ggseg",
    "rladies": true
  },
  { "package": "some-other-pkg", "url": "https://github.com/you/other" }
]
```

A scheduled job runs once a week:

- Packages newly flagged `"rladies": true` are added or updated under
  `data/packages/` and committed straight to `main` for you.
- Packages that previously had the flag but no longer do are proposed for
  removal in a draft pull request — a maintainer reviews before merging,
  since some packages have several authors.

Stop syncing entirely by removing your `data/runiverse/<handle>.json` (or
clearing every `"rladies": true` flag in your `packages.json`).

## After your PR is opened

Whether the PR was opened by the bot or by you directly, please @rladies/website
in the PR comments so a maintainer can review. After checks pass and the entry
is reviewed it will be merged into `main`.

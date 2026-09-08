# HW5 autograder — checks for evidence of the apaquarto install/render and
# the final-project repo folders, all at the REPO ROOT (not inside hw5/,
# since these are shared, repo-wide setup steps, not hw5-specific files).
# Presence-only, base R, no dependencies needed.
# Run from the repo root: Rscript hw5/check_hw5.R

fail <- function(msg) { cat("FAIL:", msg, "\n"); quit(status = 1) }
pass <- function(msg) { cat("PASS:", msg, "\n") }

for (folder in c("task", "data", "analysis")) {
  if (!dir.exists(folder)) fail(paste0("'", folder, "/' does not exist at the repo root"))
  pass(paste0("'", folder, "/' exists"))
}

ext_path <- file.path("analysis", "_extensions", "wjschne", "apaquarto")
if (!dir.exists(ext_path)) {
  fail("analysis/_extensions/wjschne/apaquarto/ not found — did you run 'quarto add wjschne/apaquarto' inside analysis/?")
}
pass("apaquarto extension is installed under analysis/")

# The draft itself lives in analysis/ (see hw5/README.md) — confirm some
# .qmd there carries the required section headers. Fixed-string grep,
# deliberately shallow: structure, not quality.
qmds <- list.files("analysis", pattern = "\\.qmd$", full.names = TRUE)
if (length(qmds) == 0) {
  fail("no .qmd found in analysis/ — copy hw5/report_draft_template.qmd there and fill it in")
}
has_headers <- function(f) {
  txt <- readLines(f, warn = FALSE)
  any(grepl("## Method", txt, fixed = TRUE)) && any(grepl("## Results", txt, fixed = TRUE))
}
if (!any(vapply(qmds, has_headers, logical(1)))) {
  fail("no .qmd in analysis/ contains both '## Method' and '## Results' headers")
}
pass("a draft in analysis/ has Method and Results headers")

rendered <- list.files("analysis", pattern = "\\.(pdf|html)$", recursive = TRUE, ignore.case = TRUE)
if (length(rendered) == 0) {
  fail("no rendered .pdf or .html file found anywhere under analysis/ — render your draft and commit the output")
}
pass(paste0("found rendered output: ", rendered[1]))

cat("\nAll HW5 structural checks passed.\n")

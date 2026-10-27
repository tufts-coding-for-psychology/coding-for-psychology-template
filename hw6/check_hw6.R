# HW6 autograder — checks the STRUCTURE of summary_table (same pattern as
# HW3/HW7) plus confirms a simulated-data CSV landed in hw6/data/. The data
# is simulated, not real, so there's no privacy concern and no synthetic
# stand-in needed -- the student's own script and its own output are
# checked directly.
#
# Revised 2026-10-26 so a red X only ever means something is definitely
# missing or wrong. The check first installs any package the student's
# code loads beyond tidyverse and knitr. If the code still can't run here
# (say it reads a file that's only on the student's laptop), the check
# looks at the rendered hw6.html instead: if summary_table is printed there
# with the required columns, the check passes with a warning that explains
# why, rather than failing.
#
# Run from inside hw6/: Rscript check_hw6.R

if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

on_github <- identical(Sys.getenv("GITHUB_ACTIONS"), "true")
fail <- function(msg) { cat("FAIL:", msg, "\n"); quit(status = 1) }
pass <- function(msg) { cat("PASS:", msg, "\n") }
# A warning shows on the run's summary page on GitHub but keeps the check
# green. GitHub reads it from a "::warning::" line, which must be one line.
warn <- function(msg) {
  cat("NOTE:", msg, "\n")
  if (on_github) cat("::warning title=HW6 check::",
                     gsub("%", "%25", gsub("\\s+", " ", msg), fixed = TRUE), "\n", sep = "")
}

qmd_path <- "hw6.qmd"
html_path <- "hw6.html"
if (!file.exists(qmd_path)) fail(paste(qmd_path, "not found"))

extracted <- tempfile(fileext = ".R")
knitr::purl(qmd_path, output = extracted, quiet = TRUE)

# --- Install any package the student's code loads that isn't here yet ---
code <- readLines(extracted, warn = FALSE)
code <- code[!grepl("^\\s*#", code)]  # skips comments and eval: false chunks
lib_calls <- unlist(regmatches(code, gregexpr(
  "(library|require|requireNamespace)\\(\\s*['\"]?[A-Za-z][A-Za-z0-9.]*", code)))
ns_calls <- unlist(regmatches(code, gregexpr("[A-Za-z][A-Za-z0-9.]*:::?", code)))
pkgs <- unique(c(sub(".*\\(\\s*['\"]?", "", lib_calls), sub(":::?$", "", ns_calls)))
pkgs <- setdiff(pkgs, rownames(installed.packages()))
if (length(pkgs) > 0) {
  if (is.null(getOption("repos")) || identical(unname(getOption("repos")["CRAN"]), "@CRAN@")) {
    options(repos = c(CRAN = "https://cloud.r-project.org"))
  }
  for (p in pkgs) {
    cat("Installing", p, "(your code loads it)\n")
    suppressWarnings(try(install.packages(p, quiet = TRUE), silent = TRUE))
  }
}

env <- new.env()
run_error <- tryCatch({
  source(extracted, local = env)
  NULL
}, error = function(e) conditionMessage(e))

# --- Fallback: the code didn't run here, so check hw6.html ---
# Only code output is searched (Quarto puts it in "cell-output" blocks),
# because the document's instructions also name these columns.
html_headers <- function(path) {
  html <- paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  blocks <- regmatches(html, gregexpr('(?s)<div class="cell-output[^"]*">.*?</div>',
                                      html, perl = TRUE))[[1]]
  # An HTML table (e.g., from kable) puts each header cell on its own line,
  # so join its lines first; then each table row becomes one line, like the
  # header line of a printed tibble.
  in_table <- grepl("<table", blocks, fixed = TRUE)
  blocks[in_table] <- gsub("\n", " ", blocks[in_table], fixed = TRUE)
  txt <- paste(blocks, collapse = "\n")
  txt <- gsub("</t[hd]>", " ", txt)
  txt <- gsub("</tr>", "\n", txt)
  txt <- gsub("<[^>]+>", " ", txt)
  lapply(strsplit(txt, "\n")[[1]], function(line) strsplit(trimws(line), "\\s+")[[1]])
}

if (!is.null(run_error)) {
  run_error <- gsub("\\s+", " ", run_error)
  if (!file.exists(html_path)) {
    fail(paste0("hw6.qmd's R code did not run here (", run_error, "), and there's ",
                "no rendered hw6.html to check instead. Render hw6.qmd in RStudio ",
                "(the Render button) and commit hw6.html alongside your .qmd."))
  }
  lines <- html_headers(html_path)
  has_table <- any(vapply(lines, function(t) all(c("condition", "n") %in% t) &&
                                               any(grepl("^mean_", t)), logical(1)))
  if (!has_table) {
    fail(paste0("hw6.qmd's R code did not run here (", run_error, "), and hw6.html ",
                "doesn't show summary_table with columns condition, n, and a mean_ ",
                "column. Finish that step, print the table, render, and commit both files."))
  }
  pass("hw6.html shows summary_table with the required columns")
  if (length(list.files("data", pattern = "\\.csv$")) == 0) {
    fail("no .csv file found in hw6/data/ — your code saves your simulated data there; commit that file")
  }
  pass("found a simulated-data file in hw6/data/")
  warn(paste0("Your code didn't run on GitHub: ", run_error, " This usually means it ",
              "reads a file that's only on your laptop, or loads a package that ",
              "couldn't be installed here. It isn't counted against you: your hw6.html ",
              "shows summary_table, so this check passes."))
  cat("\nAll HW6 checkpoint checks passed (from hw6.html).\n")
  quit(status = 0)
}
pass("hw6.qmd's R code ran without error")

st <- env$summary_table
if (is.null(st)) fail("no object named 'summary_table' was found")
if (!is.data.frame(st)) fail("'summary_table' exists but is not a data frame")
pass("'summary_table' exists and is a data frame")

required_cols <- c("condition", "n")
missing_cols <- setdiff(required_cols, names(st))
if (length(missing_cols) > 0) {
  fail(paste("summary_table is missing column(s):", paste(missing_cols, collapse = ", ")))
}
mean_cols <- grep("^mean_", names(st), value = TRUE)
if (length(mean_cols) == 0) {
  fail("summary_table has no mean-DV column — name it starting with 'mean_' (e.g. mean_rt)")
}
required_cols <- c(required_cols, mean_cols)
pass("summary_table has all required columns")

if (!nrow(st) %in% c(2, 3)) {
  fail(paste("summary_table has", nrow(st), "row(s); expected 2 (one per condition; 3 is allowed for a 0210 three-level HW1 task)"))
}
pass("summary_table has one row per condition")

if (any(is.na(st[required_cols]))) {
  fail("summary_table has missing (NA) values in a required column")
}
pass("no missing values in required columns")

# Confirm the simulated-data CSV was saved inside hw6/data/, as instructed.
data_files <- list.files("data", pattern = "\\.csv$", full.names = FALSE)
if (length(data_files) == 0) {
  fail("no .csv file found in hw6/data/ — save your simulated data there")
}
pass(paste0("found simulated-data file(s) in hw6/data/: ", paste(data_files, collapse = ", ")))

# Confirm the rendered output was committed alongside the .qmd. Presence
# only — the check never renders anything itself, and it can't tell a stale
# render from a fresh one; hand-grading covers that.
if (!file.exists(html_path)) {
  fail("no rendered hw6.html found — render hw6.qmd in RStudio (the Render button) and commit the .html alongside your .qmd")
}
pass("rendered hw6.html is present")

cat("\nAll HW6 checkpoint checks passed.\n")

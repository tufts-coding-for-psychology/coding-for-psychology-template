# HW7 autograder — checks the STRUCTURE of summary_table (same pattern as
# HW3) plus confirms a simulated-data CSV landed in the repo-root data/
# folder. Unlike HW3, this data is simulated, not real, so there's no
# privacy concern and no synthetic stand-in needed -- the student's own
# script and its own output are checked directly.
# Run from inside hw7/: Rscript check_hw7.R

if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

fail <- function(msg) { cat("FAIL:", msg, "\n"); quit(status = 1) }
pass <- function(msg) { cat("PASS:", msg, "\n") }

qmd_path <- "hw7.qmd"
if (!file.exists(qmd_path)) fail(paste(qmd_path, "not found"))

extracted <- tempfile(fileext = ".R")
knitr::purl(qmd_path, output = extracted, quiet = TRUE)

env <- new.env()
ok <- tryCatch({
  source(extracted, local = env)
  TRUE
}, error = function(e) {
  cat("FAIL: hw7.qmd's R code did not run without error:\n", conditionMessage(e), "\n")
  FALSE
})
if (!ok) quit(status = 1)
pass("hw7.qmd's R code ran without error")

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
  fail("summary_table has no mean-DV column — name it starting with 'mean_' (e.g. mean_rt, mean_acc)")
}
required_cols <- c(required_cols, mean_cols)
pass("summary_table has all required columns")

if (nrow(st) != 2) {
  fail(paste("summary_table has", nrow(st), "row(s); expected exactly 2 (one per condition)"))
}
pass("summary_table has exactly 2 rows")

if (any(is.na(st[required_cols]))) {
  fail("summary_table has missing (NA) values in a required column")
}
pass("no missing values in required columns")

# Confirm a simulated-data CSV was actually saved to the repo-root data/
# folder, as the assignment instructs.
data_files <- list.files("../data", pattern = "\\.csv$", full.names = FALSE)
if (length(data_files) == 0) {
  fail("no .csv file found in the repo-root data/ folder — save your simulated data there")
}
pass(paste0("found simulated-data file(s) in data/: ", paste(data_files, collapse = ", ")))

# Confirm the rendered output was committed alongside the .qmd. Presence
# only — the check never renders anything itself, and it can't tell a stale
# render from a fresh one; hand-grading covers that.
if (!file.exists("hw7.html")) {
  fail("no rendered hw7.html found — render hw7.qmd in RStudio (the Render button) and commit the .html alongside your .qmd")
}
pass("rendered hw7.html is present")

cat("\nAll HW7 checkpoint checks passed.\n")

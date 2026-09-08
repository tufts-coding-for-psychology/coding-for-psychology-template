# HW3 autograder — checks the STRUCTURE of summary_table, never exact values,
# since every student is wrangling their own real pilot data.
#
# Real pilot data (data/pilot.csv) is never committed to this repo — see the
# HW3 README for why. So before running the student's code, this script
# drops in its own synthetic stand-in file at that exact path, matching the
# column names the qmd expects (condition, rt, correct), then removes it
# again afterward. The student's script doesn't need to know or care that
# this happened — it just needs to read data/pilot.csv and produce a
# correctly-shaped summary_table.
#
# Run from inside hw3/: Rscript check_hw3.R

if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

fail <- function(msg) { cat("FAIL:", msg, "\n"); quit(status = 1) }
pass <- function(msg) { cat("PASS:", msg, "\n") }

qmd_path <- "hw3.qmd"
if (!file.exists(qmd_path)) fail(paste(qmd_path, "not found"))

# --- Set up a synthetic stand-in for the student's real (never-committed) data ---
data_dir <- "data"
synthetic_path <- file.path(data_dir, "pilot.csv")
already_present <- file.exists(synthetic_path)

if (!already_present) {
  if (!dir.exists(data_dir)) dir.create(data_dir)
  set.seed(2026)
  synthetic <- data.frame(
    condition = rep(c("congruent", "incongruent"), each = 18),
    rt = c(rnorm(18, 600, 80), rnorm(18, 650, 90)),
    correct = sample(c(TRUE, FALSE), 36, replace = TRUE, prob = c(0.95, 0.05))
  )
  write.csv(synthetic, synthetic_path, row.names = FALSE)
}
# If a real data/pilot.csv is somehow already present (e.g., a student testing
# locally with their own real file), leave it alone rather than overwriting it.

cleanup <- function() {
  if (!already_present && file.exists(synthetic_path)) file.remove(synthetic_path)
}
# quit() bypasses top-level on.exit handlers entirely (verified empirically),
# so cleanup() is called explicitly at every exit point below instead.
# This redefinition of fail() shadows the earlier one from here on.
fail <- function(msg) { cat("FAIL:", msg, "\n"); cleanup(); quit(status = 1) }

# Extract just the R code from the qmd and run it directly, rather than a full
# Quarto render — lighter weight on GitHub's check runner (no pandoc/TinyTeX needed) and all we
# actually need is the resulting R objects.
extracted <- tempfile(fileext = ".R")
knitr::purl(qmd_path, output = extracted, quiet = TRUE)

env <- new.env()
ok <- tryCatch({
  source(extracted, local = env)
  TRUE
}, error = function(e) {
  cat("FAIL: hw3.qmd's R code did not run without error:\n", conditionMessage(e), "\n")
  FALSE
})
if (!ok) { cleanup(); quit(status = 1) }
pass("hw3.qmd's R code ran without error")

st <- env$summary_table
if (is.null(st)) fail("no object named 'summary_table' was found")
if (!is.data.frame(st)) fail("'summary_table' exists but is not a data frame")
pass("'summary_table' exists and is a data frame")

required_cols <- c("condition", "mean_rt", "accuracy", "n")
missing_cols <- setdiff(required_cols, names(st))
if (length(missing_cols) > 0) {
  fail(paste("summary_table is missing column(s):", paste(missing_cols, collapse = ", ")))
}
pass("summary_table has all required columns")

if (!nrow(st) %in% c(2, 3)) {
  fail(paste("summary_table has", nrow(st), "row(s); expected 2 (one per condition; 3 is allowed for a 0210 three-level HW1 task)"))
}
pass("summary_table has one row per condition")

if (any(is.na(st[required_cols]))) {
  fail("summary_table has missing (NA) values in a required column")
}
pass("no missing values in required columns")

# Confirm the rendered output was committed alongside the .qmd. Presence
# only — the check never renders anything itself (no pandoc on the runner),
# and it can't tell a stale render from a fresh one; hand-grading covers that.
if (!file.exists("hw3.html")) {
  fail("no rendered hw3.html found — render hw3.qmd in RStudio (the Render button) and commit the .html alongside your .qmd")
}
pass("rendered hw3.html is present")

invisible(cleanup())
cat("\nAll HW3 structural checks passed.\n")

# HW3 autograder — checks the STRUCTURE of accuracy_table, rt_table, and
# by_participant, never exact values, since every student is wrangling their
# own real pilot data. (accuracy = all real trials; mean RT = correct only.)
#
# Real pilot data (data/*.csv) is never committed to this repo — see the HW3
# README for why. So before running the student's code, this script drops in
# its own synthetic stand-in files, then removes them afterward.
#
# Rewritten 2026-10-17 for the multi-file for-loop pattern. The three
# stand-in files deliberately vary the way real run-to-run exports do:
# one has an extra junk column, one has "None" in frameRate (a per-run
# measurement that can fail), and one has a leading-zero participant code
# (which readr reads as text). Code that follows the template — col_select
# of needed columns, participant converted to character — sails through;
# code that reads files whole or skips the conversion fails here the same
# way it would on real data. The stand-ins carry the original task's raw
# column names (participant, congruent, resp.rt, resp.corr, trials.thisN,
# date) plus `size` (a known added factor), and two non-trial rows per file
# so the template's filter(!is.na(trials.thisN)) has real work to do.
#
# Run from inside hw3/: Rscript check_hw3.R

if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

fail <- function(msg) { cat("FAIL:", msg, "\n"); quit(status = 1) }
pass <- function(msg) { cat("PASS:", msg, "\n") }

qmd_path <- "hw3.qmd"
if (!file.exists(qmd_path)) fail(paste(qmd_path, "not found"))

# --- Synthetic stand-ins for the student's real (never-committed) data ---
data_dir <- "data"
if (!dir.exists(data_dir)) dir.create(data_dir)
existing_csvs <- list.files(data_dir, pattern = "[.]csv$")
wrote <- character(0)

if (length(existing_csvs) == 0) {
  set.seed(2026)
  make_file <- function(pid, date_str) {
    n <- 36
    trials <- data.frame(
      participant  = pid,
      congruent    = rep(c(1, 0), each = n / 2),
      resp.rt      = round(c(rnorm(n / 2, 0.60, 0.08),
                             rnorm(n / 2, 0.66, 0.09)), 4),
      resp.corr    = sample(c(1, 0), n, replace = TRUE, prob = c(0.92, 0.08)),
      trials.thisN = 0:(n - 1),
      size         = rep(c(10, 20), n / 2),
      date         = date_str,
      stringsAsFactors = FALSE
    )
    nontrial <- trials[1, ]
    nontrial[1, c("congruent", "resp.rt", "resp.corr",
                  "trials.thisN", "size")] <- NA
    rbind(nontrial, trials, nontrial)  # instruct row, trials, thanks row
  }

  f1 <- make_file(4821,   "2026-10-06_17h00.00.000")
  f1$frameRate <- 60.1
  f1$extraJunk <- "x"                      # extra column: counts differ by file
  f2 <- make_file(7302,   "2026-10-06_17h12.00.000")
  f2$frameRate <- "None"                   # per-run measurement failure
  f3 <- make_file("0123", "2026-10-06_17h24.00.000")
  f3$frameRate <- 59.94                    # leading-zero participant code

  paths <- file.path(data_dir,
                     c("pilot_4821.csv", "pilot_7302.csv", "pilot_0123.csv"))
  write.csv(f1, paths[1], row.names = FALSE)
  write.csv(f2, paths[2], row.names = FALSE)
  write.csv(f3, paths[3], row.names = FALSE)
  wrote <- paths
}
# If real data/*.csv files are somehow present (e.g., a student testing
# locally with their own real files), leave them alone and use them.

cleanup <- function() {
  for (p in wrote) if (file.exists(p)) file.remove(p)
}
# quit() bypasses top-level on.exit handlers entirely (verified empirically),
# so cleanup() is called explicitly at every exit point below instead.
# This redefinition of fail() shadows the earlier one from here on.
fail <- function(msg) { cat("FAIL:", msg, "\n"); cleanup(); quit(status = 1) }

# Extract just the R code from the qmd and run it directly, rather than a full
# Quarto render — lighter weight on GitHub's check runner (no pandoc/TinyTeX
# needed) and all we actually need is the resulting R objects.
extracted <- tempfile(fileext = ".R")
knitr::purl(qmd_path, output = extracted, quiet = TRUE)

env <- new.env()
ok <- tryCatch({
  source(extracted, local = env)
  TRUE
}, error = function(e) {
  cat("FAIL: hw3.qmd's R code did not run without error:\n",
      conditionMessage(e), "\n")
  FALSE
})
if (!ok) { cleanup(); quit(status = 1) }
pass("hw3.qmd's R code ran without error")

# --- accuracy_table: one row per condition, all real trials ---
at <- env$accuracy_table
if (is.null(at)) fail("no object named 'accuracy_table' was found")
if (!is.data.frame(at)) fail("'accuracy_table' exists but is not a data frame")
pass("'accuracy_table' exists and is a data frame")

at_cols <- c("condition", "accuracy", "n")
missing_at <- setdiff(at_cols, names(at))
if (length(missing_at) > 0) {
  fail(paste("accuracy_table is missing column(s):",
             paste(missing_at, collapse = ", ")))
}
pass("accuracy_table has all required columns")

if (!nrow(at) %in% c(2, 3)) {
  fail(paste("accuracy_table has", nrow(at), "row(s); expected 2 (one per",
             "condition; 3 is allowed for a 0210 three-level HW1 task).",
             "An extra NA row usually means the practice/instruction-row",
             "filter step was removed."))
}
pass("accuracy_table has one row per condition")

if (any(is.na(at[at_cols]))) {
  fail("accuracy_table has missing (NA) values in a required column")
}
pass("no missing values in accuracy_table's required columns")

# --- rt_table: one row per condition, correct trials only ---
rt <- env$rt_table
if (is.null(rt)) fail("no object named 'rt_table' was found")
if (!is.data.frame(rt)) fail("'rt_table' exists but is not a data frame")
pass("'rt_table' exists and is a data frame")

rt_cols <- c("condition", "mean_rt", "n")
missing_rt <- setdiff(rt_cols, names(rt))
if (length(missing_rt) > 0) {
  fail(paste("rt_table is missing column(s):",
             paste(missing_rt, collapse = ", ")))
}
pass("rt_table has all required columns")

if (!nrow(rt) %in% c(2, 3)) {
  fail(paste("rt_table has", nrow(rt), "row(s); expected 2 (one per",
             "condition; 3 is allowed for a 0210 three-level HW1 task)."))
}
pass("rt_table has one row per condition")

if (any(is.na(rt[rt_cols]))) {
  fail("rt_table has missing (NA) values in a required column")
}
pass("no missing values in rt_table's required columns")

# The correct-trials filter should make rt_table's n smaller than
# accuracy_table's whenever the data contain at least one error. The
# stand-ins are built to guarantee errors, so enforce this only when they
# are the data being used (a student's own local files could in principle
# be error-free, and that shouldn't fail them).
if (length(wrote) > 0) {
  if (sum(rt$n) >= sum(at$n)) {
    fail(paste("rt_table should be built from correct trials only, but its",
               "trial counts are not smaller than accuracy_table's —",
               "was the filter(correct == 1) step skipped?"))
  }
  pass("rt_table uses fewer trials than accuracy_table (correct-only filter)")
}

# --- by_participant: one row per participant x condition, correct only ---
bp <- env$by_participant
if (is.null(bp)) fail("no object named 'by_participant' was found")
if (!is.data.frame(bp)) fail("'by_participant' exists but is not a data frame")
pass("'by_participant' exists and is a data frame")

bp_cols <- c("participant", "condition", "mean_rt", "n")
missing_bp <- setdiff(bp_cols, names(bp))
if (length(missing_bp) > 0) {
  fail(paste("by_participant is missing column(s):",
             paste(missing_bp, collapse = ", ")))
}
pass("by_participant has all required columns")

if (length(unique(bp$participant)) < 2) {
  fail("by_participant has fewer than 2 distinct participants — it should
have one row per participant per condition")
}
pass("by_participant covers multiple participants")

if (any(is.na(bp[bp_cols]))) {
  fail("by_participant has missing (NA) values in a required column")
}
pass("no missing values in by_participant's required columns")

# Confirm the rendered output was committed alongside the .qmd. Presence
# only — the check never renders anything itself (no pandoc on the runner),
# and it can't tell a stale render from a fresh one; hand-grading covers that.
if (!file.exists("hw3.html")) {
  fail("no rendered hw3.html found — render hw3.qmd in RStudio (the Render button) and commit the .html alongside your .qmd")
}
pass("rendered hw3.html is present")

invisible(cleanup())
cat("\nAll HW3 structural checks passed.\n")

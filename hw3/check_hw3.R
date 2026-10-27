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
# Revised 2026-10-26 so a red X only ever means something is definitely
# missing or wrong. A student whose task uses other column names can't run
# on the stand-ins, and that used to fail them even when their code was
# right. Now, when the code doesn't run on the stand-ins, the check looks
# at the student's rendered hw3.html instead (made from their real data):
# if all three tables are printed there with the right columns, the check
# passes with a warning that explains why. It also installs any package
# the student's code loads beyond tidyverse and knitr, so an extra
# library() call can't cause a red X either.
#
# Run from inside hw3/: Rscript check_hw3.R

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
  if (on_github) cat("::warning title=HW3 check::",
                     gsub("%", "%25", gsub("\\s+", " ", msg), fixed = TRUE), "\n", sep = "")
}

qmd_path <- "hw3.qmd"
html_path <- "hw3.html"
if (!file.exists(qmd_path)) fail(paste(qmd_path, "not found"))

# Extract just the R code from the qmd and run it directly, rather than a full
# Quarto render — lighter weight on GitHub's check runner (no pandoc/TinyTeX
# needed) and all we actually need is the resulting R objects.
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

env <- new.env()
run_error <- tryCatch({
  source(extracted, local = env)
  NULL
}, error = function(e) conditionMessage(e))
cleanup()

# --- Fallback: the code didn't run on the stand-ins, so check hw3.html ---
# The usual reason is a task with its own column names, which the stand-ins
# don't have. The rendered hw3.html was made from the student's real data,
# so if it shows all three tables with the right columns, the work is there.
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
    fail(paste0("hw3.qmd's R code did not run on the check's stand-in files (",
                run_error, "), and there's no rendered hw3.html to check instead. ",
                "Render hw3.qmd in RStudio (the Render button) and commit hw3.html ",
                "alongside your .qmd."))
  }
  lines <- html_headers(html_path)
  found <- c(
    accuracy_table = any(vapply(lines, function(t) all(c("condition", "accuracy", "n") %in% t), logical(1))),
    rt_table       = any(vapply(lines, function(t) all(c("condition", "mean_rt", "n") %in% t) &&
                                                     !"participant" %in% t, logical(1))),
    by_participant = any(vapply(lines, function(t) all(c("participant", "condition", "mean_rt", "n") %in% t), logical(1)))
  )
  if (!all(found)) {
    fail(paste0("hw3.qmd's R code did not run on the check's stand-in files (",
                run_error, "), and hw3.html doesn't show ",
                paste(names(found)[!found], collapse = " or "),
                " with the required columns. Finish those steps, print each table, ",
                "render, and commit both files."))
  }
  pass("hw3.html shows accuracy_table, rt_table, and by_participant with the required columns")
  # Name the column the stand-ins lack, rather than quoting R's error, which
  # reads as if the student's own data were missing it. R's full message
  # stays in the log for anyone who wants it.
  cat("R's message on the stand-in files:", run_error, "\n")
  standin_cols <- paste0("participant, congruent, resp.rt, resp.corr, trials.thisN, ",
                         "size, and date")
  # "Column `x` doesn't exist." (the quote marks can come out curly on Linux)
  missing_col <- regmatches(run_error, regexec("Column .([^ ]+). doesn", run_error))[[1]]
  why <- if (length(missing_col) == 2) {
    paste0("Your code asked for a column named `", missing_col[2], "`, which the ",
           "check's stand-in files don't have. Those files only have the original ",
           "Stroop task's columns: ", standin_cols, ".")
  } else {
    paste0("Your code didn't run on the check's stand-in files, which only have the ",
           "original Stroop task's columns: ", standin_cols, ".")
  }
  warn(paste(why, "That's expected if your task uses its own column names, and it",
             "isn't a problem. The check looked at your hw3.html instead, which shows",
             "all three tables, so this check passes."))
  cat("\nAll HW3 structural checks passed (from hw3.html).\n")
  quit(status = 0)
}
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
if (!file.exists(html_path)) {
  fail("no rendered hw3.html found — render hw3.qmd in RStudio (the Render button) and commit the .html alongside your .qmd")
}
pass("rendered hw3.html is present")

cat("\nAll HW3 structural checks passed.\n")

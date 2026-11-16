# HW6 autograder — checks the STRUCTURE of summary_table (same pattern as
# HW3/HW7) plus confirms the simulated-data CSV landed in hw6/data/. The data
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
# Revised 2026-11-15 to match hw6.qmd's checklist, where exact names count:
# summary_table needs at least the columns condition, mean_rt, sd_rt and n
# (extra columns are fine), and the simulated data must be saved as exactly
# hw6/data/pilot_sim.csv. Every failure says what was found and how to fix
# it, and on GitHub it also appears as an error on the run's summary page.
#
# Run from inside hw6/: Rscript check_hw6.R

if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

on_github <- identical(Sys.getenv("GITHUB_ACTIONS"), "true")
# GitHub reads "::error::" and "::warning::" from a single line, and shows
# them on the run's summary page, so the reason for a red X is visible there.
one_line <- function(msg) gsub("%", "%25", gsub("\\s+", " ", msg), fixed = TRUE)
fail <- function(msg) {
  cat("FAIL:", msg, "\n")
  if (on_github) cat("::error title=HW6 check::", one_line(msg), "\n", sep = "")
  quit(status = 1)
}
pass <- function(msg) { cat("PASS:", msg, "\n") }
# A warning shows on the run's summary page on GitHub but keeps the check green.
warn <- function(msg) {
  cat("NOTE:", msg, "\n")
  if (on_github) cat("::warning title=HW6 check::", one_line(msg), "\n", sep = "")
}

qmd_path <- "hw6.qmd"
html_path <- "hw6.html"
csv_name <- "pilot_sim.csv"
required_cols <- c("condition", "mean_rt", "sd_rt", "n")
if (!file.exists(qmd_path)) {
  fail("hw6.qmd not found in the hw6/ folder. The file must be named exactly hw6.qmd.")
}

# --- What's missing from summary_table, and how to fix each one ---
fix_hint <- function(col, found) {
  others <- setdiff(found, required_cols)
  if (col == "mean_rt") {
    alt <- grep("^mean", others, value = TRUE)
    if (length(alt) > 0) {
      return(paste0("found ", paste(alt, collapse = ", "), ", but Step 5 asks for exactly mean_rt: ",
                    "rename it in summarize(), as mean_rt = mean(mean_rt)"))
    }
    return("add mean_rt = mean(mean_rt) to your summarize()")
  }
  if (col == "sd_rt") {
    alt <- grep("^sd", others, value = TRUE)
    if (length(alt) > 0) {
      return(paste0("found ", paste(alt, collapse = ", "), ", but Step 5 asks for exactly sd_rt: ",
                    "rename it in summarize(), as sd_rt = sd(mean_rt)"))
    }
    return("add sd_rt = sd(mean_rt) to your summarize(), before mean_rt, as in Class 8")
  }
  if (col == "n") return("add n = n() to your summarize()")
  "use group_by(condition) before summarize(), so each row is one condition"
}
missing_message <- function(found) {
  missing <- setdiff(required_cols, found)
  paste0("summary_table is missing ", paste(missing, collapse = ", "),
         ". Step 5 asks for at least the columns condition, mean_rt, sd_rt and n. To fix it: ",
         paste(vapply(missing, fix_hint, character(1), found = found), collapse = "; "), ".")
}

# --- The simulated-data CSV: exactly hw6/data/pilot_sim.csv ---
check_csv <- function() {
  if (file.exists(file.path("data", csv_name))) {
    pass(paste0("found hw6/data/", csv_name))
    return(invisible(TRUE))
  }
  others <- list.files("data", pattern = "\\.csv$", ignore.case = TRUE)
  where <- if (file.exists(csv_name)) {
    paste0(csv_name, " is in hw6/, not in hw6/data/. ")
  } else if (length(others) > 0) {
    paste0("hw6/data/ has ", paste(others, collapse = ", "), ", but not ", csv_name, ". ")
  } else {
    paste0("There's no ", csv_name, " in hw6/data/. ")
  }
  fail(paste0(where, "Step 4 saves your simulated data as exactly hw6/data/", csv_name,
              ": run write_csv(sim_data, \"data/", csv_name, "\") in hw6.qmd, then commit ",
              "and push that file (and delete any misnamed copy)."))
}

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
# because the document's instructions also name these columns. And only the
# output of code cells that mention summary_table, so another table with the
# same columns (e.g., the 0210 200-person summary) can't stand in for it. If
# no shown code mentions summary_table (code hidden with echo: false), every
# cell's output is searched instead.
html_headers <- function(path, mention = "summary_table") {
  html <- paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  out_re <- '(?s)<div class="cell-output[^"]*">.*?</div>'
  cells <- strsplit(html, '<div class="cell( [^"]*)?"', perl = TRUE)[[1]][-1]
  code_text <- gsub("<[^>]+>", "", gsub(out_re, "", cells, perl = TRUE))
  keep <- grepl(mention, code_text, fixed = TRUE)
  if (any(keep)) html <- paste(cells[keep], collapse = "\n")
  blocks <- regmatches(html, gregexpr(out_re, html, perl = TRUE))[[1]]
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
                "(the Render button) and commit hw6.html, named exactly that, ",
                "alongside your .qmd."))
  }
  # summary_table's printed header: a line with condition and no participant
  # column (by_participant and sim_data have one), scored by how many of the
  # required columns it has.
  # A line with no mean or SD column at all (like count(condition)'s output)
  # isn't summary_table.
  lines <- html_headers(html_path)
  candidates <- Filter(function(t) "condition" %in% t && !("participant" %in% t) &&
                         any(grepl("^(mean|sd)", t)), lines)
  if (length(candidates) == 0) {
    fail(paste0("hw6.html doesn't show summary_table with the columns Step 5 asks for ",
                "(condition, mean_rt, sd_rt and n). Print it on the last line of Step 5's ",
                "chunk (a line that just says summary_table), render, and commit both ",
                "hw6.qmd and hw6.html. (Your code didn't run here because it reads files ",
                "that are only on your laptop, so this check reads hw6.html instead.)"))
  }
  score <- vapply(candidates, function(t) sum(required_cols %in% t), numeric(1))
  best <- candidates[[which.max(score)]]
  if (!all(required_cols %in% best)) {
    fail(paste0(missing_message(best), " Then render and commit both hw6.qmd and hw6.html. ",
                "(Your code didn't run here because it reads files that are only on your ",
                "laptop, so this check read summary_table from hw6.html.)"))
  }
  pass("hw6.html shows summary_table with condition, mean_rt, sd_rt and n")
  check_csv()
  warn(paste0("Your code didn't run on GitHub: ", run_error, " This usually means it ",
              "reads a file that's only on your laptop, or loads a package that ",
              "couldn't be installed here. It isn't counted against you: your hw6.html ",
              "shows summary_table, so this check passes."))
  cat("\nAll HW6 checkpoint checks passed (from hw6.html).\n")
  quit(status = 0)
}
pass("hw6.qmd's R code ran without error")

st <- env$summary_table
if (is.null(st)) {
  fail(paste0("no object named exactly summary_table was found. Step 5 builds it from sim_data: ",
              "summary_table <- sim_data |> group_by(condition) |> summarize(...)."))
}
if (!is.data.frame(st)) fail("summary_table exists but is not a data frame (Step 5 builds it with group_by() and summarize())")
pass("summary_table exists and is a data frame")

if (!all(required_cols %in% names(st))) fail(missing_message(names(st)))
pass("summary_table has condition, mean_rt, sd_rt and n")

if (!nrow(st) %in% c(2, 3)) {
  fail(paste("summary_table has", nrow(st), "row(s); expected 2 (one per condition; 3 is allowed for a 0210 three-level HW1 task).",
             "Group by condition only, not by participant."))
}
pass("summary_table has one row per condition")

if (any(is.na(st[required_cols]))) {
  fail("summary_table has missing (NA) values in condition, mean_rt, sd_rt or n. Check that sim_data has no NA values in mean_rt.")
}
pass("no missing values in required columns")

check_csv()

# Confirm the rendered output was committed alongside the .qmd. Presence
# only — the check never renders anything itself, and it can't tell a stale
# render from a fresh one; hand-grading covers that.
if (!file.exists(html_path)) {
  fail("no rendered hw6.html found. Render hw6.qmd in RStudio (the Render button) and commit hw6.html, named exactly that, alongside your .qmd.")
}
pass("rendered hw6.html is present")

cat("\nAll HW6 checkpoint checks passed.\n")

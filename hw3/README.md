# HW3 — Data wrangling with dplyr

**Due:** Mon Oct 26, 11:59 PM (the night before Class 08)
**From:** Class 07 (Data Wrangling with dplyr)

Using your own class05 pilot CSV, write a dplyr script that produces a clean, condition-level summary table — the same shape you built together in class, applied to your own data.

**Standardize your column names first.** Your raw PsychoPy export uses names like `key_resp.rt` or `key_resp.corr`; the very first step of your pipeline should `rename()` your three working columns to exactly **`condition`, `rt`, and `correct`**. This is required, for two reasons: it's what lets the automated check run your code (its stand-in file uses those names — see below), and it's what lets the instructor later pool the whole class's results for Class 10's between-subject variability computation. The template's code shows exactly where the `rename()` goes.

## Where your data goes — and where it doesn't

Save your class05 pilot CSV as `data/pilot.csv` in this folder.

**Do not commit that file.** Your work here may end up in a public copy you publish after the semester, and `data/pilot.csv` is real data from a real classmate — it must never be committed to any version of this repo, private or otherwise. A `.gitignore` in this repo already excludes `hw3/data/*.csv` for you, so a normal `git add`/commit from RStudio's Git pane won't pick it up — just don't force-add it.

If you're not sure your file is being ignored, check RStudio's Git pane before you commit: `pilot.csv` should not show up in the list of changes to stage.

## What to submit

Fill in `hw3.qmd` in this folder, pointed at `data/pilot.csv`. Your script must produce an R object called exactly `summary_table` — a data frame with:

- one row per condition (2 rows total — or 3, if you're a 0210 student whose HW1 task has a third level)
- columns named `condition`, `mean_rt`, `accuracy`, `n` (add more if you want, but these four must exist)
- no missing values in those four columns

When it's done, **render it** (the Render button in RStudio — the output format is already set to HTML) and commit `hw3.html` alongside your `.qmd`. The rendered file is part of the submission: a document that renders top-to-bottom on a fresh run is the reproducibility bar this course keeps returning to. Rendered HTML is your own code and writing, not private data — fine to commit (your report reads `data/pilot.csv` but the *file* stays uncommitted as always).

## PSY 0210 only

Compute mean RT **two ways** — once from all trials, once from correct trials only (one extra `filter()`) — and put both in your summary table: keep the required `mean_rt` column as whichever version you'd report, and add the other as a second column (e.g., `mean_rt_all` or `mean_rt_correct`). Then, in the reflection, add two sentences: why do the two numbers differ, and which belongs in a report of this task? There's a defensible case either way — the reasoning is what's graded. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

## The automated check

The check (see the Actions tab after you push) runs your `hw3.qmd`'s R code and checks the *shape* of `summary_table` — not your actual numbers, since your data is your own. Because your real pilot data is never committed, the check supplies its own synthetic stand-in file at `data/pilot.csv` — already carrying the standardized names `condition`, `rt`, `correct` — before running your code, then deletes it afterward. One consequence worth knowing: if your `rename()` refers to your raw columns by name (e.g., `rename(rt = key_resp.rt)`), it would error on the stand-in file, so use the template's `any_of()` pattern (shown in `hw3.qmd`), which renames your raw columns when they're present and quietly does nothing when they're already standardized. Written that way, the same script passes on your real data locally and on the stand-in in the automated check on GitHub. The check also confirms a rendered `hw3.html` is present in this folder (it doesn't render anything itself — that's your job, and the name must be exactly `hw3.html`).

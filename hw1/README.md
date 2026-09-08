# HW1 — Extend the Stroop Builder skeleton

**Due:** Mon Sep 21, 11:59 PM (the night before Class 03)
**From:** Class 02 (Builder Basics)

Take your own saved copy of the original Stroop task from class and extend it with **one** of the following:

- **(a) A new routine.** Add a new instructions/practice element to the Flow — e.g., a second instructions screen, or a short practice-trial routine that runs once before the main `trials` loop.
- **(b) A new condition.** Add a new row (or rows) to a copy of `conditions.xlsx` — e.g., a new color/word pair — and confirm in a test run that Builder picks it up correctly: right word, right color, right correct-answer key, and the loop's trial count updates to match.

Either path is fine. The goal is comfort adding *something* to the Flow or the conditions spreadsheet, not a specific design.

## PSY 0210 only

In addition to the shared assignment above — choose path (a) or (b) like everyone — **also add a third level of the manipulated factor**. The classic choice is a *neutral* condition (a non-color word, or a row of colored X's), which is what lets researchers separate interference from facilitation in Stroop-type tasks. (If you're deciding between paths, (a) pairs especially well with this extension: a Flow change plus a design change gives you two genuinely different kinds of practice.) Two requirements for the new level:

1. Add **enough rows that your new level meets the course's ≥18-observations rule** once the loop's repetitions apply — with the original file's 6 repetitions, that's 3 rows, matching the other two levels.
2. Give the `congruent` column a **third value** for the new rows (e.g., `2` alongside the original `1`/`0`), so every row still says which level it belongs to.

Confirm in a test run that trials from all three levels actually appear. (Your HW2 script will later read this same file and check the ≥18 rule per level — your own tool, checking your own design.) 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

## What to submit

- Your working `.psyexp` file (and, if you took path (b), your edited `conditions.xlsx`) go in `task/` in this folder.
- Fill in `hw1.qmd` with a short reflection: what you added, whether it worked on the first test run, and what (if anything) you had to fix.

## Submitting

Everything happens on GitHub.com — your repo doesn't live on your own computer until the git setup before Class 7, and nothing here needs it to.

1. **Upload your task files:** on your repo's page, open the `hw1/task/` folder, click **Add file → Upload files**, drag in your `.psyexp` (and your edited `conditions.xlsx`, if you took path (b)), and commit.
2. **Fill in `hw1.qmd`:** open the file in your repo, click the **pencil icon** (Edit), type your answers, and commit — a `.qmd` is just a text file; no special editor needed.

Heads-up: the automated check runs on every commit, so if you commit the `.qmd` before your `.psyexp` is uploaded, you'll see a red X until both pieces are in — expected, not a problem; it turns green once the task file lands.

## The automated check

Commit, then check the **Actions** tab (or the ✅/❌ next to your commit). The check only confirms a `.psyexp` file exists under `task/` and that it's well-formed — GitHub's automated checker has no display, so it can't tell whether your Builder edits actually "work," and a green check is not a substitute for test-running your task yourself before you submit.

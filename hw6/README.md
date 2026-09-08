# HW6 — Simulate Your Pilot Design

**Due:** Mon Nov 23, 11:59 PM (the night before Class 11)
**From:** Class 10 (Simulating Data)

Simulate **one** hypothetical sample of participants for your own pilot design, wrangle it into a condition-level summary table, and plot it. Every step is a rep of something you did in class10 — and a direct rehearsal for HW7, which runs this exact pipeline on your final-project design.

## What to do

1. **Simulate** condition means for N hypothetical participants with `rnorm()`, using **your own HW3 condition means as the centers** and the **class pooled between-subject SD** (given in class10) as the spread — same mechanics as class10's guided build, with your own numbers.
2. **Wrangle** the simulated data into a condition-level summary table with `group_by()` + `summarize()` — one row per condition, same shape as HW3's table.
3. **Visualize** it with your class08 figure code, adapted to the simulated table.
4. Save your simulated dataset as `data/pilot_sim.csv` **inside this `hw6/` folder** (the template's code does this for you). Simulated data is never real participant data — completely fine to commit.

## What to submit

Fill in `hw6.qmd` in this folder. Your script must produce an R object called exactly `summary_table` — one row per condition, columns `condition`, a mean-DV column whose name starts with `mean_` (e.g., `mean_rt`), and `n`, no missing values — and must write the simulated CSV to `hw6/data/`. Then **render it** and commit `hw6.html` alongside your `.qmd` — same as HW3 and HW4, the rendered file is part of the submission.

## The automated check

The check (see the Actions tab after you push) runs your `hw6.qmd`'s R code and confirms `summary_table` exists with the right shape, that a `.csv` landed in `hw6/data/`, and that a rendered `hw6.html` is present (exactly that name — the check doesn't render anything itself). It does **not** judge whether your simulation parameters are realistic — that's instructor review's job.

## PSY 0210 only

Run the simulation at **two sample sizes** (e.g., N = 20 and N = 200), plot both with the same figure code, and add 1–2 sentences: what changed between the two plots, and why? (This is class10 segment 5's spread-narrowing move, done with your own numbers.) 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

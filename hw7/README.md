# HW7 — Final-project analysis

**Due:** Mon Dec 7, 11:59 PM (the night before Class 13)
**From:** Class 12 (Final Project: Build & Debug Pilot)

Every step below repeats something you've already done once this semester, applied to your own novel task's design instead of the shared one — and there's no piloting attached. Class 12's debugging pilot was the only real-person contact your project needs; this is entirely simulation, wrangling, and visualization, on your own laptop.

## What to do

1. **Simulate** data for your own 1-factor/2-level design — the same `rnorm()` mechanics from class10, rehearsed once already in HW6, applied to your own design instead of your pilot task. Since you don't have real participant data to match parameters to, choose plausible values for your task (a reasonable guess at mean/SD per condition is fine — there's no "real" number to be wrong about).
2. **Wrangle** your simulated data into a condition-level summary table — the same dplyr pattern from class07/HW3, just applied to data you generated instead of data you collected.
3. **Visualize** the result — the same ggplot2 pattern from class08.
4. Save your simulated dataset as a `.csv` in this repo's root-level `data/` folder (set up back in HW5) — this is simulated data, not real pilot data, so unlike HW3's file, it's completely fine to commit — and fine to include in a public copy of your work, if you choose to publish one.

Class 13 is where this becomes a finished report and gets presented — today's job is just getting the pipeline running, not writing it up.

## What to submit

Fill in `hw7.qmd` in this folder. Your script must produce an R object called exactly `summary_table` — same shape as HW3: a data frame with one row per condition, columns `condition`, a mean-DV column whose name starts with `mean_` (`mean_rt`, `mean_acc` — whatever your DV actually is), and `n`, no missing values. Also save your simulated data to `../data/` as described above. Then **render it** and commit `hw7.html` alongside your `.qmd` — the rendered file is part of the submission, same as every homework since HW3.

## The automated check

The check (see the Actions tab after you push) runs your `hw7.qmd`'s R code and confirms `summary_table` exists with the right shape, that a `.csv` file has landed in the repo-root `data/` folder, and that a rendered `hw7.html` is present (exactly that name — the check doesn't render anything itself). It does **not** grade your report's quality or your simulation's realism — this is a light-touch checkpoint, not a graded-for-quality final deliverable. Quality feedback comes from the instructor in Class 13.

## PSY 0210 only

Simulate **twice**: your planned effect (the shared assignment above), and a **null version** of your own design — same code, but with the two condition means set equal. Save the null dataset as a second `.csv` in the repo-root `data/` folder (e.g., `final_project_null.csv`), plot both datasets with the same ggplot2 code, and add 1–2 sentences in `hw7.qmd`: what does the null version look like, and could you have told the two apart by eye? This is class10's sampling-variability lesson applied to your own design — a null effect still produces *some* difference in any one sample. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

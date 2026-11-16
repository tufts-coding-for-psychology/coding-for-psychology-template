# HW6 — Simulate Your Pilot Design

**Due:** Mon Nov 23, 11:59 PM (the night before Class 11)
**From:** Class 10 (Simulating Data)

In Class 10 you computed the flanker data's between-person numbers and simulated a 50-person flanker study. HW6 asks you to do the same with your own pilot data: compute your own numbers, simulate one 50-person study of your own pilot design, wrangle it into a summary table, and graph it next to your real data. You write the code yourself. It's also a direct rehearsal for HW7, where you'll simulate data for your final-project design: you won't collect data for your final project, you'll simulate it.

## Which data?

Use your own pilot data, the files in `hw3/data/`. **If you piloted only one or two people, use the Class 7 flanker data in `class07/data/` instead**: one or two people can't tell you how much people differ from one another.

## What to do

`hw6.qmd` walks you through five steps. Each step says what to build and what to name it, and leaves the code to you. Two files are good references: your HW5 draft, `analysis/pilot_report.qmd`, and your class file, `class10/class10.qmd`.

1. **Your pilot data, one row per person per condition.** Build `by_participant` (columns `participant`, `condition`, `mean_rt`): main trials only, correct trials only, mean RT in milliseconds. Your HW5 draft already does most of this. Watch for the usual trouble spots, which `hw6.qmd` explains: the data path from `hw6/` (`"../hw3/data"`), practice rows, RTs in seconds instead of milliseconds, and condition labels that show as `0` and `1`. A check chunk, already written, tells you whether it worked.
2. **Your four numbers.** With Class 10's steps (`pivot_wider()` with `id_cols = participant`, then each person's effect), create `mean_congruent`, `sd_congruent`, `mean_effect` and `sd_effect`, in milliseconds.
3. **Simulate 50 people**, the paired way from Class 10: the same simulated people do both conditions. Draw each person's congruent mean and each person's own effect with `rnorm()`; each person's incongruent mean is their congruent mean plus their own effect. Combine them into `sim_data`, with columns `participant`, `condition` and `mean_rt`.
4. **Save** `sim_data` as `data/pilot_sim.csv` **inside this `hw6/` folder**, with `write_csv()`. Simulated data is never real participant data — completely fine to commit.
5. **Wrangle** `sim_data` into `summary_table`, one row per condition, with columns `condition`, `mean_rt`, `sd_rt` and `n`.

Then:

- Run the **"Check your simulation"** chunk (already written) and answer its question: why isn't your simulated effect exactly the same as `mean_effect`?
- **Visualize**: draw `by_participant` and `sim_data` with your Class 8 figure code, then compare them: what looks the same, what looks different, and why?
- **Check every box** in the checklist at the top of `hw6.qmd`. Every item counts toward the Complete criterion I apply when evaluating homework, including using exact names.

If your HW1 task has a third level (PSY 0210), you can add it the same way: draw each person's neutral mean as their congruent mean plus a draw from `rnorm()` with your own neutral-minus-congruent mean and SD.

## What to submit

Fill in `hw6.qmd` in this folder, then **render it** and commit and push **both** `hw6.qmd` and `hw6.html` — the rendered file is part of the submission, same as every homework since HW3. Your script must produce `by_participant`, `sim_data`, and an R object called exactly `summary_table` — one row per condition, with at least the columns `condition`, `mean_rt`, `sd_rt` and `n`, and no missing values — and must write the simulated CSV to `hw6/data/`. Every box in the checklist at the top of `hw6.qmd` must be checked.

## The automated check

The check (see the Actions tab after you push) confirms that `summary_table` has the right shape, that a `.csv` landed in `hw6/data/`, and that a rendered `hw6.html` is present (exactly that name — the check doesn't render anything itself). Your pilot data isn't on GitHub, so your code can't run there; the check reads `summary_table` from your committed `hw6.html` instead and passes with a note explaining why. That's expected, and it's why pushing `hw6.html` matters. The check does **not** judge whether your simulation parameters are realistic — that's instructor review's job.

## PSY 0210 only

Run the simulation at **two sample sizes**: 50 people (the shared assignment) and 200 people, keeping your four numbers the same. Plot both with the same figure code, and add 1–2 sentences: what changed between the two plots, and why? (This is Class 10 segment 5's sample-size move, done with your own numbers.) Optional stretch: write a function that takes the number of people and returns a data frame like `sim_data`, and use it for both sizes. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

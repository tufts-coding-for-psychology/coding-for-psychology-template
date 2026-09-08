# HW4 — Analyze Your Assigned Pilot Dataset

**Due:** Mon Nov 2, 11:59 PM (the night before Class 09)
**From:** skills built through Class 08 (RStudio, reading data, `dplyr` — including class07's mixed text/numeric parsing)

You've each been assigned your own individual dataset to analyze — not the same file as your classmates. Your dataset is `data/sleep_steps_pilot.csv`, with two columns:

- `sleep_hrs` — average nightly sleep, in hours
- `steps` — average daily step count

As with your other pilot-data assignments this semester, analyze and interpret your own dataset independently.

## What to do

Working on your own:

1. **Clean your data.** Your assigned file is deliberately messy — expect missing values, implausible/extreme values, and at least one column with mixed text-and-number entries that need parsing before it's usable numerically. This is the same category of cleaning class07 practiced, just applied to a new dataset. Decide what to do with each issue you find and note briefly what you did and why.
2. **Compute the correlation** between `sleep_hrs` and `steps`. This hasn't been covered in class yet — finding out how is part of the assignment. Your course texts and R's own built-in help (e.g. typing `?` followed by a function name) are good places to start.
3. **Write a short (roughly one paragraph) interpretation** of what that correlation suggests about the relationship between sleep and physical activity in this sample.

As with any real analysis, don't stop at the first number you compute — apply the full toolkit you've built this semester before you're satisfied you understand your dataset.

## PSY 0210 only

Add a **data-cleaning memo** to your `hw4.qmd`: a bulleted log (roughly 5–10 bullets) of every cleaning decision you made — what you found, what you did about it, and why. You're making these decisions anyway as part of step 1; the graduate extension is documenting them the way a reproducible analysis requires, so that someone else (including future-you) could retrace and defend each choice. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

## What to submit

Fill in `hw4.qmd` in this folder and render it. Your document should include your cleaning code, your correlation code, and your written interpretation. Push both the `.qmd` and its rendered output.

## Grading

This is graded by hand, not by an automated check — there's no single "correct" correlation here, since every student's dataset is different, and the cleaning decisions are genuinely judgment calls. Credit is based on:

- Reasonable, well-explained handling of the messy values in your file.
- Correct, working code that reads your (cleaned) data and computes the correlation.
- A correct, well-reasoned interpretation of *your own* result — a strong, weak, or null correlation are all valid, gradeable findings if you interpret them correctly.
- Anything else about your dataset you noticed and think is worth mentioning.

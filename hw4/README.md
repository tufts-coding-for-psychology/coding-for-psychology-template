# HW4 — Analyze Your Assigned Pilot Dataset

**Due:** Mon Nov 2, 11:59 PM (the night before Class 09)
**From:** skills built through Class 08 (RStudio, reading data, `dplyr`, `ggplot2`, and Class 8's `cor()`)

You've each been assigned your own individual dataset to analyze; no two students have the same file. Your dataset is `data/sleep_steps_pilot.csv`, with two columns:

- `sleep_hrs` — average nightly sleep, in hours
- `steps` — average daily step count

As with your other pilot-data assignments this semester, analyze and interpret your own dataset independently.

## What to do

Working on your own:

1. **Clean your data.** Your assigned file is deliberately messy. You'll see missing values, implausible/extreme values, and at least one column with mixed text-and-number entries that need parsing before it's usable numerically. Parsing entries like these is new in this assignment; your course texts and R's own built-in help (e.g. typing `?` followed by a function name) are good places to look. Decide what to do with each issue you find and implement the decisions in code.
2. **Look at your data.** Make at least one figure that helps you check your data, and say in a sentence or two what it showed you.
3. **Compute the correlation** between `sleep_hrs` and `steps` with `cor()`, which we used in Class 8. If it returns `NA`, `?cor` explains your options.
4. **What do you conclude?** In roughly a paragraph: what do you conclude from your dataset? Draw on everything you found, not just the correlation.

As with any real analysis, look at your data before you trust any number you compute from it, and apply the full toolkit you've built this semester before you're satisfied you understand your dataset.

## PSY 0210 only

Add a **data-cleaning memo** to your `hw4.qmd`: a bulleted log (roughly 5–10 bullets) of every cleaning decision you made: what you found, how many observations it affected, what you did about it, and why. You're making these decisions anyway as part of step 1; the graduate extension is documenting them the way a reproducible analysis requires, so that someone else (including future-you) could retrace and evaluate each choice. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

## What to submit

Fill in `hw4.qmd` in this folder and render it. Your document should include your cleaning code, your figure(s), your correlation code, and your written conclusion. Push both the `.qmd` and its rendered output.

## Grading

This is graded by hand, not by an automated check. There's no single "correct" correlation here, since every student's dataset is different, and the cleaning decisions are genuinely judgment calls. Credit is based on:

- Reasonable handling of the messy values in your file.
- At least one figure you used to check your data, with a sentence or two on what it showed you.
- Correct, working code that reads your (cleaned) data and computes the correlation.
- A well-reasoned conclusion about *your own* dataset, consistent with what your figure(s) and your correlation show. A strong, weak, or null correlation are all valid, gradeable findings if you interpret them correctly.
- Anything else about your dataset you noticed and think is worth mentioning.

# HW3 — Data wrangling with dplyr

**Due:** Mon Oct 26, 11:59 PM (the night before Class 08)
**From:** Class 07 (Data Wrangling with dplyr)

Using **all of your complete class05 pilot files**, write a script that stacks them into one table and produces three clean summary tables — the same moves we built together in Class 7 on the shared flanker data, applied to your own data.

## Where your data goes — and where it doesn't

Copy your CSVs — the same files you collected from peers in Class 5 and uploaded to Canvas; however many you have, one is fine — into `data/` in this folder.

**Do not commit those files.** Your work here may end up in a public copy you publish after the semester, and they are real data from real classmates; they must never be committed to any version of this repo, private or otherwise. A `.gitignore` in this repo already excludes `hw3/data/*.csv` for you, so a normal `git add`/commit from RStudio's Git pane won't pick them up — just don't force-add them.

If you're not sure the files are being ignored, check RStudio's Git pane before you commit: nothing from `data/` should show up in the list of changes to stage.

## Reading your files: the loop, and why it reads defensively

`hw3.qmd` gives you the structure and the requirements; **the code is yours to write.** You built a working version of this exact pipeline in class, and it's saved in your `class07.qmd`. Rebuild the Class 7 read-in loop for your own task: for each file, `read_csv()` with `col_select` keeping **only the columns you need**, `participant` converted to text, and `bind_rows()` stacking the result onto the pile.

The defensiveness is not decoration. Your files came from about ten different people running your task, and **not all sessions produced identical files, even on the same laptop.** For example, maybe the frame-rate measurement failed in one session and wrote text instead of a number. Or, maybe the last event never got recorded because a participant had to hit Esc to end the task; columns only appear for events that occur. Or maybe a participant code starts with a 0 (which R reads as text to protect the leading zero in that one file whereas other files would read it in as numeric). Reading whole files and stacking them breaks on all of these; reading just your columns, with participant as text, breaks on none of them.

**Edit the `col_select` list to match YOUR task.** The rule is *who, your design, your measurements*: `participant`; your condition column(s), **including any factor column you added in HW1** (e.g., `size`); your keyboard's `.rt` and `.corr` columns; your main trials loop's `.thisN` counter (`trials.thisN` unless you renamed the loop — `glimpse()` one file to check); and `date`, which is what tells your files apart. If a name in your list doesn't exist in a file, the read stops with an error naming it; that's your cue to check `glimpse()` against your list.

## What to submit

Fill in `hw3.qmd`. Your script must produce **three** objects, built the way we built them in Class 7: accuracy from all real trials, mean RT from **correct trials only** (a wrong answer's speed doesn't measure what you think it does):

- **`accuracy_table`** — one row per condition (2 rows — or 3, if your task has a third level), columns exactly `condition`, `accuracy`, `n`. Built from all real trials.
- **`rt_table`** — same rows, columns exactly `condition`, `mean_rt`, `n`. Built from correct trials only, so its `n` runs smaller than `accuracy_table`'s; the gap is your error trials.
- **`by_participant`** — one row per **participant per condition**, columns exactly `participant`, `condition`, `mean_rt`, `n` (correct trials only). This is the table Class 8's figure is drawn from.

There should be no missing values in those required columns; an `NA` sneaking in usually means the Step 1 filter (which drops practice trials and instruction rows via your main loop's `.thisN`) was skipped or lost.

When it's done, **render it** (the Render button in RStudio) and commit `hw3.html` alongside your `.qmd`. The rendered file is part of the submission: a document that renders top-to-bottom on a fresh run is the reproducibility bar this course keeps returning to. 

## PSY 0210 only

Your required `rt_table` already uses correct trials only. Also compute the **all-trials** version — one more `group_by()` + `summarize()` on the unfiltered real-trials table — as a separate table (e.g., `rt_table_all`). Then, in the designated section, add two sentences: why do the two numbers differ, and which belongs in a report of this task? There's a defensible case either way. 0110 students may attempt this for practice, but it isn't required or graded for that cohort.

## The automated check

The check (see the Actions tab after you push) runs your `hw3.qmd`'s R code and checks the *shape* of `accuracy_table`, `rt_table`, and `by_participant`, not your numbers, since your data is your own. Because your real data is never committed, the check supplies three synthetic stand-in files in `data/` before running your code, then deletes them. The stand-ins carry the original task's raw column names (`participant`, `congruent`, `resp.rt`, `resp.corr`, `trials.thisN`, `date`, plus `size`) and deliberately differ from each other the way real runs do, so the same defensive loop that works on your files works on them.

One consequence worth knowing: **if your task uses column names of your own invention** (a renamed keyboard, a custom factor column other than `size`), the stand-ins won't have them, your `col_select` will error there, and the check will show a red X even though your code may be perfectly right on your real data. If that's you, say so in your reflection and don't worry about it; the check is a convenience, not the grade.

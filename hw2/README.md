# HW2 — Accuracy scoring and dynamic feedback

**Due:** Mon Oct 5, 11:59 PM (the night before Class 05)
**From:** Class 04 (Custom Code Components)

Take your own extended task from HW1 and add accuracy-scoring and dynamic feedback logic to it, using the Code Component pattern built together in class — a dictionary-based correct-answer lookup and feedback text shown to the participant.

Concretely, apply the full version of what class04 built on the original Stroop task to your *own* HW1 file:

- A dictionary keyed by the relevant condition column (e.g., `letterColor`) mapping to the correct response.
- Logic in the code component's **End Routine** tab (not Each Frame — that's the most common bug at this stage) that looks up the expected answer and sets a feedback-text variable.
- A Text component that displays that feedback after each trial.

## What to submit

- Your updated `.psyexp` file goes in `task/` in this folder (replacing/updating your HW1 copy — bring the whole working file forward, not just a diff).
- Fill in `hw2.qmd` with a reflection on the feedback logic you added.

**PSY 0210 students:** see the extra section in `hw2.qmd` — you also submit a standalone conditions-validation `.py` script, starting from the template at `hw2/check_conditions_template.py`. This is required for 0210, optional (ungraded) practice for 0110.

## Submitting

Same as HW1 — everything on GitHub.com: upload your updated `.psyexp` (and, for 0210, your `.py` script) into `hw2/task/` via **Add file → Upload files**, and fill in `hw2.qmd` with the pencil-icon web editor. Your repo still doesn't need to live on your own computer.

## The automated check

The check confirms a `.psyexp` file exists under `task/` and is well-formed XML — same as HW1. If you're in PSY 0210 and have placed a `check_conditions.py` script at `hw2/task/check_conditions.py`, the workflow also runs it against a small synthetic conditions file to confirm it executes without crashing and prints something. It does **not** grade whether your script's pass/fail logic is correct on your own real data — that's still your job to get right; the automated check is just confirming the script runs.

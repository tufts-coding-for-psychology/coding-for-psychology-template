# HW2 — Accuracy scoring and dynamic feedback

**Due:** Mon Oct 5, 11:59 PM (the night before Class 05)
**From:** Class 04 (Custom Code Components)

Take your own extended task from HW1 and add accuracy-scoring and dynamic feedback logic to it, using the Code Component pattern built together in class — a dictionary-based correct-answer lookup and feedback text shown to the participant.

Concretely, apply the full version of what class04 built on the original Stroop task to your *own* HW1 file:

- A dictionary keyed by the relevant condition column (e.g., `letterColor`) mapping to the correct response.
- Logic in the code component's **End Routine** tab (not Each Frame — that's the most common bug at this stage) that looks up the expected answer and sets a feedback-text variable.
- A Text component that displays that feedback after each trial.

*Optional:* also save each condition's proportion correct to your data file, the way class04's worked example did.

## Make sure your task works on any computer

In Class 5, you'll download your task from GitHub onto a lab computer and run it with a partner, so it has to work on a computer that isn't yours. Before you submit:

1. **Set Builder to Run mode**, not Pilot mode (the Pilot/Run switch in Builder's toolbar), and save.
2. **Keep your conditions file in the same folder as your `.psyexp`.** Open each loop and check its Conditions field: it should show just the file's name (e.g., `conditions.xlsx`), not a long path starting with `C:/` or `/Users/`. If you see a long path, save your `.psyexp` into the folder that holds your conditions file, then choose the file again with the folder icon — Builder then stores just the name.
3. **Run it once all the way through without errors.**
4. **Upload every file your task needs** into `hw2/task/`: your `.psyexp`, your conditions file(s), and any images or sounds it uses. Don't upload your `data/` folder.
5. **Test it:** first rename the folder you built your task in (for example, add `_old` to the end of its name), so the test can't quietly use files from it. Then download your `hw2/task/` files from GitHub into a new, empty folder, open the `.psyexp` from there, and run it. If it runs, and step 2's Conditions fields show just a file name, it's ready for another computer. (You can rename your original folder back afterward.)

## What to submit

- Everything your task needs to run, in `task/` in this folder (see the list above). Bring the whole working task forward from your HW1 copy, not just the parts you changed.
- Fill in `hw2.qmd` with a reflection on the feedback logic you added.

**PSY 0210 students:** see the extra section in `hw2.qmd` — you also submit a standalone conditions-validation `.py` script, starting from the template at `hw2/check_conditions_template.py`. This is required for 0210, optional (ungraded) practice for 0110.

## Submitting

Same as HW1 — everything on GitHub.com: upload your task files (and, for 0210, your `.py` script) into `hw2/task/` via **Add file → Upload files**, and fill in `hw2.qmd` with the pencil-icon web editor. Your repo still doesn't need to live on your own computer.

## The automated check

The check confirms a `.psyexp` file exists under `task/` and is well-formed XML — same as HW1. It does **not** check Run mode, your conditions file, or whether the task runs on another computer, so a green check doesn't mean those are right; the five steps above are how you check them. If you're in PSY 0210 and have placed a `check_conditions.py` script at `hw2/task/check_conditions.py`, the workflow also runs it against a small synthetic conditions file to confirm it executes without crashing and prints something. It does **not** grade whether your script's pass/fail logic is correct on your own real data — that's still your job to get right; the automated check is just confirming the script runs.

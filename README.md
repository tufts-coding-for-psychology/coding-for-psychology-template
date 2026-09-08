# Coding for Psychology — your semester repo

Welcome! This one repo is where every homework for the semester lives — not a separate repo per assignment. You'll keep committing to it from HW1 in September through the final project in December, so it's worth getting comfortable with.

## Getting your own copy

If you're reading this on the *template* repo (`coding-for-psychology-template`), stop — don't commit here. Get your own copy first:

1. Accept the invite to the `tufts-coding-for-psychology` GitHub organization (link from your instructor).
2. Open `coding-for-psychology-template` and click the green **"Use this template" → "Create a new repository"** button near the top of the page.
3. Set the owner to `tufts-coding-for-psychology` (not your personal account — this is what gives your instructor automatic access without you having to separately invite them), name it something like `coding-for-psych-<your-github-username>`, and keep it **private**.
4. Do all your actual work in *that* new repo, not this template.

## How this works

- Each `hwN/` folder is one homework, with its own `README.md` (what's due) and `hwN.qmd` (your written work, and for HW3 onward, your actual R code). The one exception is HW5: its real work lives in the repo-root `analysis/` folder — the `hw5/` folder holds the README plus a report template you copy there.
- You don't need to ask permission to submit; just commit and push to this repo before the deadline. Every homework is due at **11:59 PM on the Monday night before the class it's listed under** (each `hwN/README.md` gives the exact date). Whatever's present when the deadline passes is what gets graded.
- Most homework folders have an automated check attached (look for a green check ✅ or red X ❌ next to your commit, or under this repo's **Actions** tab). A red X means something's structurally wrong — a missing file, a script that errors, a renamed object it expected to find — and it comes with a message telling you what so you can fix it.

## Pushing to this repo, by homework

- **HW1–HW2**: Submit via GitHub.com in your browser. Upload your PsychoPy files into the matching `hwN/` folder with **Add file → Upload files**, and fill in the homework's `hwN.qmd` write-up right on GitHub using the pencil (**Edit this file**) button. Each upload or edit saves as a commit — GitHub asks you for a short commit message each time, and that's the whole submission.
- **HW3 onward**: Submit via RStudio. **Render before you submit** (the Render button), and commit the rendered `.html` along with your `.qmd` — from HW3 on, the rendered file is part of the submission. Then use RStudio's **Git** tab (top-right pane, taught in Class 06) — stage your changed files, write a commit message, click **Commit**, then **Push**. No terminal commands needed. Remember: a commit only happens on your own machine — it isn't shared with anyone until you also push.
- Your PsychoPy `.psyexp` files and any conditions spreadsheets go in a homework's `task/` subfolder where relevant; HW3's real pilot CSV goes in `hw3/data/` and is **never committed** — see that folder's README for why.

## Your final project (Classes 11–13)

Class 9 creates the top-level `analysis/` folder, and HW5 has you add the other two — `task/` and `data/` — separate from any `hwN/` folder. This is where your novel final-project task, its (simulated) data, and your final report will all live. Your instructor will walk you through the final-project design in Class 11; HW5's own README has the folder setup steps.

Unlike the original Stroop task's real pilot data, your final project's analysis data is **simulated**, not collected from real participants — so there's nothing sensitive in `task/`, `data/`, or `analysis/` to worry about keeping private.

This repo stays **private** for good, and your grade in this class never depends on making your work public. At the very end of the semester, your goal is to make your repo *publication-ready*: a complete, tidy project with its own README. If you'd like an actually-public copy for your portfolio, the course website's Resources page has a how-to you can follow.

## Questions

If a check is red and you can't figure out why, feel free to post questions on Piazza, see me during drop-in hours, or schedule an appointment.

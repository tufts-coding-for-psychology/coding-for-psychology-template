# HW5 — Finish your Method/Results draft

**Due:** Mon Nov 9, 11:59 PM (the no-class week — this lands here on purpose, so it's never due the same day as a quiz)
**From:** Class 09 (Reproducible Reporting)

**Your work for this homework lives in the repo-root `analysis/` folder, not here.** In class09 you created `analysis/`, installed the `apaquarto` extension into it, copied this folder's `report_draft_template.qmd` in, and started your Method/Results draft. This homework is finishing and polishing that draft — not a fresh build. The draft matters beyond this grade: it's the first working version of your final project's report, which will live in this same `analysis/` folder.

## What to do

1. **Finish the draft** in `analysis/`: a brief Method paragraph (participants, conditions, procedure — a few sentences referencing your HW3 wrangling), and a Results section with your class08 plot as an APA-captioned figure plus a sentence of inline-code M/SD prose. Descriptive reporting only — no test statistic.
2. **Fill in the author note** in the YAML header (the `gratitude:` field the template already carries): a sentence or two acknowledging what sources you turned to for help — other people, internet posts, software documentation, AI tools, or none at all. This is every homework's Sources section in its APA-native home; honest acknowledgments never lower your grade.
3. **Render to PDF** (`format: apaquarto-pdf`) once TinyTeX cooperates — PDF is the standard APA expectation. If PDF genuinely won't work on your machine after the troubleshooting below, render to HTML and flag it to the instructor.
4. **Commit the rendered output** (the `.pdf`, or `.html` per step 3) into `analysis/` along with your `.qmd` and the `_extensions/` folder. These are software artifacts and your own writing, not private data — fine to commit. (Your report's *numbers* come from your HW3 summary table, not from the raw pilot CSV, which stays uncommitted as always.)
5. **Create the other two final-project folders** at the repo root: `task/` and `data/`. Empty folders with a `.gitkeep` file are fine — class11 assumes all three exist.

## If your class09 install broke (or you missed class)

The complete self-serve path, terminal steps included:

1. Open your repo's `.Rproj` in RStudio, then open a terminal: **Tools → Terminal → New Terminal**. It opens at your repo's root — the prompt shows the folder you're in.
2. If `analysis/` doesn't exist yet, create it (Files pane → New Folder).
3. In the terminal, type `cd analysis` and press Enter — the prompt should now end in `analysis`.
4. Run `quarto add wjschne/apaquarto`. Confirm `analysis/_extensions/wjschne/apaquarto/` appears.
5. Run `quarto install tinytex` (needed for PDF; takes several minutes the first time — it is not stuck).
6. Copy `hw5/report_draft_template.qmd` into `analysis/` and pick up at "What to do" above. Stuck? Post on Piazza — don't wait until the night it's due.

## PSY 0210 only

Two connected pieces of scholarly plumbing on the same draft:

1. **A brief Discussion paragraph** — interpret your result and name at least one limitation of your design (small sample, single manipulated factor, pilot-only data). A short paragraph, not a full Discussion section. (The template has a marked spot for it.)
2. **Cite PsychoPy properly:** create `analysis/references.bib` containing the entry below, add `bibliography: references.bib` to your draft's YAML header, cite it in your Method with `@peirce2019`, and confirm the render produces an APA-formatted reference.

```bibtex
@article{peirce2019,
  title   = {PsychoPy2: Experiments in behavior made easy},
  author  = {Peirce, Jonathan and Gray, Jeremy R. and Simpson, Sol and
             MacAskill, Michael and H{\"o}chenberger, Richard and Sogo,
             Hiroyuki and Kastman, Erik and Lindel{\o}v, Jonas Kristoffer},
  journal = {Behavior Research Methods},
  volume  = {51},
  pages   = {195--203},
  year    = {2019},
  doi     = {10.3758/s13428-018-01193-y}
}
```

The automated check does not look for this — it's reviewed by hand. 0110 students may attempt it for practice, but it isn't required or graded for that cohort.

## The automated check

The check (see the Actions tab after you push) confirms, from the root of your repo: `task/`, `data/`, and `analysis/` all exist; `analysis/_extensions/wjschne/apaquarto/` exists; a `.qmd` in `analysis/` contains `## Method` and `## Results` headers; and at least one rendered file (`.pdf` or `.html`) is present in `analysis/`. It does **not** re-render anything itself or grade your writing — that's instructor review's job.

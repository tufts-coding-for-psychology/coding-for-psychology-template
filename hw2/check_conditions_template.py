"""
check_conditions.py -- PSY 0210 starter template

This file already handles the parts of the assignment that aren't the
actual point of the exercise: reading a spreadsheet from disk, and
letting the automated GitHub check run this script against a different
file than the one you use to test it yourself. You don't need to
understand every line above the TODO section -- just trust that it
works and focus on the part that's actually yours to write.

YOUR JOB is the part marked TODO below: counting how many trials each
condition produces, and checking that against this course's minimum-
observations rule. You already built this exact logic once, in
class04's Colab warm-up -- a dictionary that counts occurrences
of a value in a list. This is the same idea, just counting rows in a
spreadsheet instead of items in a list.

Two ways to run this file:
  1. Click PsychoPy Coder's green Run button -- no changes needed, it
     checks DEFAULT_PATH below.
  2. From a terminal: python check_conditions.py some_file.csv
     (this second way is how the automated GitHub check runs it)

Steps to use this template:
  1. Copy this file to hw2/task/check_conditions.py.
  2. Change DEFAULT_PATH and CONDITION_COLUMN below to match your own
     conditions file.
  3. Fill in the TODO section in main() with your own counting logic.
  4. Test it by clicking Run in Coder -- it should check your own
     conditions file and print one pass/fail line per condition.
"""

import sys
from pathlib import Path

import pandas as pd

# --- Change these two to match your own conditions file ---
DEFAULT_PATH = "conditions.xlsx"     # your own file, for local testing
# The column that names each row's CONDITION -- the factor your task
# manipulates. In the original Stroop conditions file that's `congruent`
# (1 = congruent, 0 = incongruent), NOT a stimulus property like
# `letterColor`: the >=18 rule is about observations per level of the
# manipulated factor, and counting per letter color would test the
# wrong thing.
CONDITION_COLUMN = "congruent"

# Every condition needs at least this many trials once repetitions are
# applied -- this course's minimum-observations rule.
MIN_TRIALS = 18

# How many times your PsychoPy loop repeats each row (your loop's nReps).
# Change this to match your own conditions file too.
N_REPS = 6


# ---------------------------------------------------------------------
# Already written for you. Reads the conditions file and hands back a
# plain Python list of condition labels, one per row -- e.g., for the
# original Stroop file's `congruent` column:
#   [1, 0, 1, 0, 1, 0]
# You don't need to touch this function.
# ---------------------------------------------------------------------
def load_condition_labels(path):
    if not Path(path).exists():
        print(f"Could not find conditions file: {path}")
        sys.exit(1)
    if path.endswith(".csv"):
        df = pd.read_csv(path)
    else:
        df = pd.read_excel(path)
    return df[CONDITION_COLUMN].tolist()


def main():
    # sys.argv[0] is always this script's own name; a real argument
    # (like the sample file the automated check passes in) shows up
    # starting at index 1. This line is why the SAME script works both
    # from Coder's Run button (no argument -> DEFAULT_PATH) and from
    # a terminal with a filename (used by the automated check).
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_PATH
    labels = load_condition_labels(path)

    print(f"Checking {path}...\n")

    # -------------------------------------------------------------
    # TODO -- this is your part.
    #
    # `labels` is a plain list, one entry per row -- for the original
    # Stroop file's `congruent` column that's:
    #   [1, 0, 1, 0, 1, 0]
    #
    # Using the same dictionary-counting pattern from class04's
    # Colab warm-up: build a dictionary that counts how many times each
    # condition appears in `labels`, then multiply each count by N_REPS
    # to get total trials per condition.
    #
    # Finally, print one line per condition, labeled with the column's
    # own values, e.g. (1 = congruent, 0 = incongruent):
    #   1: 18 trials -- OK
    #   0: 12 trials -- FAILS minimum of 18
    #
    # PRINT the pass/fail lines -- do NOT call sys.exit() with a
    # non-zero code when a condition fails. The automated check on
    # GitHub deliberately feeds this script a sample file containing a
    # failing condition, and it treats any non-zero exit as a crash.
    #
    # Hint: start with an empty dictionary. Loop over `labels`, and for
    # each one, add 1 to that condition's running count -- this is the
    # exact pattern you used in class04's warm-up, just looping
    # over conditions-file rows here instead of a plain list.
    # -------------------------------------------------------------

    condition_counts = {}
    # your counting loop goes here

    for condition, n_rows in condition_counts.items():
        n_trials = n_rows * N_REPS
        # your pass/fail print statement goes here, using n_trials
        # and MIN_TRIALS
        pass


if __name__ == "__main__":
    main()

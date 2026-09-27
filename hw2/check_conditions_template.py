"""
check_conditions.py -- PSY 0210 starter template

This script checks your conditions file against this course's
minimum-observations rule: every condition needs at least 18 trials
once your loop's repetitions are applied (rows x nReps).

Steps:
  1. Download this file and save it as check_conditions.py in the SAME
     folder as your task's .psyexp and conditions file.
  2. Change the four SETTINGS below to match your own task.
  3. Fill in YOUR PART 1 and YOUR PART 2.
  4. Open the file in PsychoPy Coder and click Run. It should print one
     pass/fail line per condition.
  5. Upload it to hw2/task/ along with the rest of your task.

The part marked ALREADY WRITTEN FOR YOU picks which file to check and
reads it. You don't need to change it.
"""

import sys
import pandas as pd

# ---------------------------------------------------------------------
# SETTINGS -- change these four to match your own task.
# ---------------------------------------------------------------------

# Your conditions file's name. Keep this script in the same folder as
# that file.
DEFAULT_PATH = "conditions.xlsx"

# The column that names each row's CONDITION -- the factor your task
# manipulates. In the original Stroop task's conditions file that's
# `congruent` (1 = congruent, 0 = incongruent), NOT a stimulus property
# like `letterColor`: the rule is about observations per level of the
# factor you manipulate, so counting letter colors would test the wrong
# thing.
CONDITION_COLUMN = "congruent"

# How many times your PsychoPy loop repeats each row (the loop's nReps).
N_REPS = 6

# This course's minimum-observations rule.
MIN_TRIALS = 18


# ---------------------------------------------------------------------
# ALREADY WRITTEN FOR YOU -- you don't need to change anything here.
# ---------------------------------------------------------------------

# Pick which file to check. When you click Run in Coder, this uses
# DEFAULT_PATH. The automated check on GitHub runs this same script
# against a small sample file instead, by typing that file's name after
# the script's name -- Python makes that name available as sys.argv[1].
if len(sys.argv) > 1:
    file_name = sys.argv[1]
else:
    file_name = DEFAULT_PATH

# Read the spreadsheet (.csv or .xlsx) with pandas, then keep just the
# condition column as a plain list, one entry per row. For the original
# Stroop task's conditions file, that list is:
#   [1, 0, 1, 0, 1, 0]
if file_name.endswith(".csv"):
    table = pd.read_csv(file_name)
else:
    table = pd.read_excel(file_name)
labels = list(table[CONDITION_COLUMN])

print("Checking", file_name)


# ---------------------------------------------------------------------
# YOUR PART 1 -- count how many rows each condition has.
#
# Build a dictionary where each key is a condition and each value is
# how many times that condition appears in `labels`. For the original
# Stroop task you should end up with {1: 3, 0: 3}.
#
# This is the counting pattern from Think Python ch. 10 ("A collection
# of counters") and from the class04 Colab warm-up: start with an empty
# dictionary, loop over the list, and for each item either add it as a
# new key with a count of 1, or add 1 to the count it already has.
# ---------------------------------------------------------------------

condition_counts = {}

# your counting loop goes here


# ---------------------------------------------------------------------
# YOUR PART 2 -- print one pass/fail line per condition.
#
# The loop below is already started for you. It visits each key in
# condition_counts (the `for key in dictionary` pattern from Think
# Python ch. 10's "Looping and dictionaries"), looks up that
# condition's row count, and multiplies by N_REPS to get its number of
# trials.
#
# Inside the loop, add an if/else: if n_trials is at least MIN_TRIALS,
# print a line saying the condition is OK; otherwise, print a line
# saying it fails. For example, this print() call:
#   print("Condition", condition, "has", n_trials, "trials - OK")
# prints:
#   Condition 1 has 18 trials - OK
# Write the "fails" line yourself, and include MIN_TRIALS in it.
#
# Print the result -- don't stop the script with an error when a
# condition fails. The automated check on GitHub feeds this script a
# sample file that includes a failing condition on purpose, and it
# treats an error as a crash.
# ---------------------------------------------------------------------

for condition in condition_counts:
    n_rows = condition_counts[condition]
    n_trials = n_rows * N_REPS
    # your if/else and print() lines go here

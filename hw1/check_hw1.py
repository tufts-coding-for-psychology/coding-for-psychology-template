"""HW1 autograder — checks STRUCTURE only, never whether the experiment
"works," since there's no meaningful way to run a GUI-built PsychoPy task
from GitHub's automated check runner, which has no display. Run from inside hw1/: python check_hw1.py

Checks:
  1. At least one .psyexp file exists somewhere under hw1/task/.
  2. That file is well-formed XML (a .psyexp file is just XML under the
     hood, so a parse error is a good proxy for "this file is corrupted
     or isn't a real psyexp export").
"""
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

TASK_DIR = Path("task")


def fail(msg):
    print(f"FAIL: {msg}")
    sys.exit(1)


def ok(msg):
    print(f"PASS: {msg}")


def main():
    if not TASK_DIR.is_dir():
        fail(f"'{TASK_DIR}/' directory not found")

    psyexp_files = sorted(TASK_DIR.rglob("*.psyexp"))
    if not psyexp_files:
        fail(f"no .psyexp file found anywhere under '{TASK_DIR}/'")
    ok(f"found {len(psyexp_files)} .psyexp file(s) under '{TASK_DIR}/': "
       f"{', '.join(str(p) for p in psyexp_files)}")

    # Only the first one needs to parse cleanly to satisfy the check, but
    # report on all of them so a student sees exactly which file is broken.
    any_valid = False
    for p in psyexp_files:
        try:
            ET.parse(p)
        except ET.ParseError as e:
            print(f"  - {p}: NOT well-formed XML ({e})")
            continue
        ok(f"'{p}' is well-formed XML")
        any_valid = True

    if not any_valid:
        fail("no .psyexp file under 'task/' parsed as well-formed XML")

    print("\nAll HW1 structural checks passed.")


if __name__ == "__main__":
    main()

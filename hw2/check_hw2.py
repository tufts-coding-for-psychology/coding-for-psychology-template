"""HW2 autograder — checks STRUCTURE only. Run from inside hw2/:
    python check_hw2.py path/to/sample_conditions.csv

The sample conditions CSV path is passed in by the GitHub Actions workflow
(a tiny synthetic file, not any student's real data). It's only used for
the optional PSY 0210 portion of this check.

Checks:
  1. At least one .psyexp file exists somewhere under hw2/task/, and it's
     well-formed XML — same base check as HW1.
  2. (PSY 0210 only, and only if present) hw2/task/check_conditions.py
     exists: run it against the sample conditions file and confirm it
     exits without a Python exception and prints *something*. This does
     NOT validate the script's pass/fail logic against real data — that's
     the script's own job, not this check's job to duplicate. If the file
     isn't present, this portion is simply skipped (it's optional for
     PSY 0110 students; see hw2.qmd's "PSY 0210 extension" section).
"""
import subprocess
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

TASK_DIR = Path("task")
CONDITIONS_SCRIPT = TASK_DIR / "check_conditions.py"


def fail(msg):
    print(f"FAIL: {msg}")
    sys.exit(1)


def ok(msg):
    print(f"PASS: {msg}")


def check_psyexp():
    if not TASK_DIR.is_dir():
        fail(f"'{TASK_DIR}/' directory not found")

    psyexp_files = sorted(TASK_DIR.rglob("*.psyexp"))
    if not psyexp_files:
        fail(f"no .psyexp file found anywhere under '{TASK_DIR}/'")
    ok(f"found {len(psyexp_files)} .psyexp file(s) under '{TASK_DIR}/': "
       f"{', '.join(str(p) for p in psyexp_files)}")

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


def check_conditions_script(sample_csv):
    if not CONDITIONS_SCRIPT.exists():
        print(f"INFO: '{CONDITIONS_SCRIPT}' not found — skipping the PSY 0210 "
              f"conditions-validation check (this file is optional for PSY 0110).")
        return

    if sample_csv is None or not Path(sample_csv).exists():
        fail("hw2/task/check_conditions.py exists, but no sample conditions "
             "file was provided to test it against (expected as this script's "
             "first argument)")

    ok(f"found '{CONDITIONS_SCRIPT}' — running it against the sample "
       f"conditions file ({sample_csv})")

    try:
        result = subprocess.run(
            [sys.executable, str(CONDITIONS_SCRIPT), str(sample_csv)],
            capture_output=True,
            text=True,
            timeout=60,
        )
    except subprocess.TimeoutExpired:
        fail(f"'{CONDITIONS_SCRIPT}' did not finish within 60 seconds")

    if result.returncode != 0:
        fail(
            f"'{CONDITIONS_SCRIPT}' exited with a non-zero status "
            f"({result.returncode}) — it should run without raising an "
            f"exception on a well-formed conditions file.\n"
            f"--- stdout ---\n{result.stdout}\n--- stderr ---\n{result.stderr}"
        )
    ok(f"'{CONDITIONS_SCRIPT}' ran without a Python exception")

    output = (result.stdout + result.stderr).strip()
    if not output:
        fail(f"'{CONDITIONS_SCRIPT}' ran but printed no output at all")
    ok(f"'{CONDITIONS_SCRIPT}' printed output:\n{output}")


def main():
    sample_csv = sys.argv[1] if len(sys.argv) > 1 else None

    check_psyexp()
    check_conditions_script(sample_csv)

    print("\nAll HW2 structural checks passed.")


if __name__ == "__main__":
    main()

## Task

Work through the playbook in `references/debug-playbook.md`. Do not skip to a fix before completing the diagnosis steps — root cause first, then fix.

If the user request contains an error message or stack trace, start there. If it names a failing test, run it first to capture the current output.

## Output format

### Hypothesis

One sentence: what you believe the root cause is, stated as a falsifiable claim. ("The issue is X because Y.")

### Evidence

What in the code, logs, or diff supports the hypothesis. Cite specific files and lines.

### Reproduction path

The minimal sequence of steps or inputs that triggers the bug. Must be self-contained — if external state or manual setup is required, document the prerequisites explicitly. If a reproduction path cannot be constructed, say so and explain what information is missing.

### Root cause

The specific code location and mechanism causing the failure. Distinguish the root cause from any symptoms.

### Fix

The change required. Show the diff or exact edit. Prefer the minimal correct fix — do not refactor surrounding code unless it is directly causing the problem.

### Verification

How to confirm the fix is correct: specific test to run, assertion to check, or behavior to observe.

### Residual risk

Anything the fix does not address, or related areas that may have the same problem.

## Quality bar

- Root cause must be identified, not just the symptom
- Hypothesis must be falsifiable — state it as "the issue is X because Y", not "it might be related to Z"
- Fix must be minimal — do not refactor surrounding code unless it is directly causing the problem
- Verification step must be concrete and runnable, not "test it locally"
- If the root cause cannot be determined, say so and list what information is missing

## Additional resources

- **`references/debug-playbook.md`** — Systematic investigation steps, common failure patterns, and techniques for isolating root cause.

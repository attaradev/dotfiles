---
name: "debug"
description: "Diagnose failing code, tests, or crashes when the user pastes an error, stack trace, or failing test name and wants the root cause found and fixed."
---

# Debug

Use this skill to trace a failure to its root cause before changing code.

## Workflow

1. Identify the language and framework from project files (go.mod, package.json, pyproject.toml, Cargo.toml, etc.) — this determines the right debugging tools and patterns.
2. Reproduce the failure or inspect the error path first.
3. Read the relevant code, logs, and recent changes.
4. Form a falsifiable hypothesis, then gather evidence for it.
5. Fix the minimal root cause and verify the behavior change.

## Output expectations

- State the hypothesis first.
- Show the evidence and reproduction path.
- Separate root cause from symptoms.
- Describe the fix and how to verify it.
- Call out residual risk if the issue may recur elsewhere.

## Resource map

- `references/debug-playbook.md` -> systematic debugging steps and common failure patterns

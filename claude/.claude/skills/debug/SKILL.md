---
name: debug
description: This skill should be used when the user asks to "debug this", "why is this failing", "figure out this error", "this test is failing", "investigate this crash", "what's causing this", "help me debug", or pastes a stack trace or error message. Systematically diagnoses root cause from an error, stack trace, or failing test — reproduce, isolate, identify, fix.
argument-hint: "[error message, stack trace, or failing test name]"
---

# Debug

Problem: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Language/framework: !`ls go.mod package.json pyproject.toml Cargo.toml pom.xml build.gradle requirements.txt Gemfile 2>/dev/null | head -3 || true`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short 2>/dev/null || true`
- Recent changes (may have introduced the bug): !`git log --oneline -10 2>/dev/null || true`
- Recent diff: !`git diff HEAD~1..HEAD --stat 2>/dev/null || true`

## Task

Work through the playbook in `references/debug-playbook.md`. Do not skip to a fix before completing the diagnosis steps — root cause first, then fix.

If `$ARGUMENTS` contains an error message or stack trace, start there. If it names a failing test, run it first to capture the current output.

## Output format

### Hypothesis

One sentence: what you believe the root cause is, stated as a falsifiable claim. ("The issue is X because Y.")

### Evidence

What in the code, logs, or diff supports the hypothesis. Cite specific files and lines.

### Reproduction path

The minimal sequence of steps or inputs that triggers the bug. If you cannot construct one, say so and explain what is missing.

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

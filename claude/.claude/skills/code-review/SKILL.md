---
name: code-review
description: Perform senior and staff-level code review with findings ranked by severity and concrete remediation steps. Use when reviewing local changes, pull requests, or risky refactors before merge.
disable-model-invocation: true
argument-hint: "[scope-or-pr]"
---

# Code Review

Review scope: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch and status: !`git status --short --branch 2>/dev/null || true`
- Changed files: !`git diff --name-only 2>/dev/null || true`
- Diff summary: !`git diff --stat 2>/dev/null || true`
- Recent commits: !`git log --oneline -n 12 2>/dev/null || true`

## Task

1. Review for correctness, regressions, security, performance, operability, and test coverage gaps.
2. Report findings first and order by severity (`high`, `medium`, `low`).
3. For each finding, cite evidence using file paths and exact line numbers when available.
4. If no findings exist, state that explicitly and list residual risks or missing validation.

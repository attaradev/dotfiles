---
name: execution-plan
description: Build a staff-quality execution plan from an objective, including trade-offs, milestones, and verification strategy. Use when turning ambiguous asks into a concrete implementation plan.
disable-model-invocation: true
argument-hint: "[goal]"
---

# Execution Plan

Goal: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch and status: !`git status --short --branch 2>/dev/null || true`
- Repository map: !`find . -maxdepth 2 -type d 2>/dev/null | sort | head -n 200`
- Recent commits: !`git log --oneline -n 15 2>/dev/null || true`

## Task

1. Define the problem, constraints, and success criteria.
2. Present 2 or 3 viable approaches with key trade-offs.
3. Recommend one approach and provide a phased execution plan.
4. Specify validation gates, rollback strategy, and key risks.
5. End with assumptions and open questions that need decisions.

---
name: stakeholder-update
description: Draft engineering updates for stakeholders that separate facts, risks, and next milestones. Use when preparing weekly updates, leadership summaries, or cross-team status reports.
disable-model-invocation: true
argument-hint: "[audience-and-timeframe]"
---

# Stakeholder Update

Audience and timeframe: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch and status: !`git status --short --branch 2>/dev/null || true`
- Recent commits (last 7 days): !`git log --since='7 days ago' --oneline --decorate 2>/dev/null || true`
- Changed files: !`git diff --name-only 2>/dev/null || true`
- Top-level files: !`ls -1 2>/dev/null | head -n 100`

## Task

1. Write two versions: executive (non-technical) and engineering (technical detail).
2. Cover delivered outcomes, business or user impact, risks or blockers, and next milestones.
3. Separate confirmed facts from inferences.
4. Keep each version concise and action-oriented.

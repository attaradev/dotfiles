---
name: "review-pr"
description: "Perform a deep GitHub pull request review when the user provides a PR number or URL and wants severity-ranked findings, test gaps, and an approval recommendation."
---

# GitHub PR Review

Use this skill to review a remote PR with GitHub CLI context.

## Workflow

1. Parse the PR number and optional repository slug.
2. Run `scripts/collect-pr-context.sh` to gather the PR summary, changed files, linked issues, existing reviews, and full diff.
3. Read the full diff before forming findings.
4. Work through the review checklist and separate blockers, concerns, test gaps, and positive observations.

## Output expectations

- Lead with severity-ranked findings grounded in the diff.
- Include ready-to-post review comments when useful.
- State uncertainty explicitly when context is missing.
- End with an approval recommendation and rationale.

## Resource map

- `scripts/collect-pr-context.sh` -> PR summary and full diff collection via `gh`
- `references/review-checklist.md` -> review categories and signals to check

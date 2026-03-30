---
name: "review-pr"
description: "Perform a deep, file-by-file GitHub pull request review. Produces a per-file breakdown, severity-ranked findings, exhaustive inline comments, and an approval recommendation. Use when the user provides a PR number or URL and wants a thorough review."
---

# GitHub PR Review

Use this skill to review a remote PR with GitHub CLI context.

## Workflow

1. Parse the PR number and optional repository slug from the user prompt.
2. Run `scripts/collect-pr-context.sh` to gather the PR summary, changed files, linked issues, existing reviews, and full diff.
3. **Understand intent** — read the PR description and linked issues before reading any code. What problem is being solved? What is out of scope?
4. **Scan the file list** — note which files changed and whether the set is consistent with the stated intent. Flag any file that looks unrelated or accidental.
5. **Read every changed file completely**, in diff order. For each file:
   - Understand what the file does in the broader system.
   - Annotate every line or block that could be wrong, risky, or improvable.
   - If a hunk references shared abstractions or callers not in the diff, read those for context.
   - Hold findings until all files are read; cross-file patterns matter.
6. **Apply every category in `references/review-checklist.md`** across the full diff.
7. **Check for missing files**: test files for new code, docs for user-facing changes, migrations for schema changes.
8. Produce the review output.

## Output expectations

- **Per-file summary table**: one row per changed file with a change summary and risk level (High / Medium / Low / None).
- **Severity-ranked findings** (Blockers -> Major concerns -> Minor concerns) grounded in the diff.
- **Inline review comments for every finding worth raising** — do not cap at a handful. Each comment must reference the exact file and line number.
- **Test coverage gaps**: identify untested behaviors and what assertions would cover them.
- **Positive observations**: call out well-executed decisions. Balanced reviews build trust.
- **Approval recommendation** with a one-sentence rationale (Approve / Approve with comments / Request changes / Cannot fully assess).
- State uncertainty explicitly when context is missing.
- After presenting the review, offer to post it to GitHub via `gh pr review`.

## Quality bar

- All findings must be backed by evidence in the diff; do not invent issues.
- Inline comments must be specific and actionable; do not cap their number.
- Do not comment on formatting or naming unless it impairs correctness.
- Approval recommendation must be explicit; choose one of the four options and do not hedge.

## Resource map

- `scripts/collect-pr-context.sh` -> PR summary, changed files, linked issues, existing reviews, and full diff via `gh`
- `references/review-checklist.md` -> eight review categories and specific signals to check

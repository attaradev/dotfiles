---
name: review-pr
description: This skill should be used when the user asks to "review PR", "review pull request", "review this PR", "look at PR #N", "gh pr review", or provides a GitHub PR number or URL. Performs a deep, structured pull request review via the GitHub CLI — producing a severity-ranked review with blockers, concerns, test gaps, and an approval recommendation.
disable-model-invocation: true
argument-hint: "[PR-number or owner/repo#PR]"
---

# GitHub PR Review

Review target: $ARGUMENTS

## Gather context

Parse the argument: extract the PR number and optional `owner/repo` slug, then run `scripts/collect-pr-context.sh`.

- PR number: !`echo "$ARGUMENTS" | grep -oE '[0-9]+' | tail -1`
- Repo slug (if given): !`echo "$ARGUMENTS" | grep -oE '^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+' | head -1`

Run the context collector, passing the raw argument so it can parse the PR number and optional `owner/repo` slug itself:

!`bash "$HOME/.claude/skills/review-pr/scripts/collect-pr-context.sh" "$ARGUMENTS" 2>&1`

## Task

Read the full diff before forming any opinion. Work through every category in `references/review-checklist.md`. Only surface findings that are traceable to the diff or strongly implied by surrounding-system context.

Guardrails:
- Do not invent findings without evidence.
- Do not comment on formatting or naming unless it impairs readability or correctness.
- Cite uncertainty explicitly ("I cannot verify this without seeing the callers").
- Be skeptical but fair — engage with tradeoffs, not just surface observations.

## Output format

### Overall assessment

One paragraph: scope and intent of the PR, confidence level (note limits from diff size or missing context), and dominant risks.

### Blockers

Must be resolved before merge — correctness bugs, data loss, security holes, broken contracts.

**[LABEL]** — `path/file.ext` (line N)
> What is wrong, why it matters, what to do instead. Be concrete.

### Major concerns

Significant but non-blocking: performance, missing observability, backward-compat risks, important test gaps. Same format as Blockers.

### Minor concerns

Low-severity only — unclear names, missing error context, cosmetic drift. Include a tight set or omit entirely.

### Test coverage gaps

For each untested behavior: what is untested, why it is risky, what a useful test would assert. Omit if coverage is adequate.

### Positive observations

Well-executed decisions worth calling out. Balanced reviews build trust. Omit if nothing stands out.

### Suggested review comments

Top 2–5 findings as ready-to-post GitHub comments:

> **`path/to/file.ext` line N**
>
> [Comment — specific, actionable, no filler]

### Approval recommendation

Choose one with a one-sentence rationale:
- **Approve** — no blockers, concerns minor or addressed
- **Approve with comments** — no blockers, non-trivial concerns to address
- **Request changes** — blockers present (list by label)
- **Cannot fully assess** — missing context; explain the gap

## Additional resources

- **`references/review-checklist.md`** — Eight review categories with specific signals to look for. Read before forming findings.
- **`scripts/collect-pr-context.sh`** — Collects PR summary, file list, linked issues, existing reviews, and full diff via `gh`.

---
name: "achievements"
description: "Collect commits, merged PRs, reviews, and closed issues for a time period, then synthesize them into a structured achievement summary. Use when the user asks to pull achievements, summarize shipped work, write a brag doc, prepare performance review input, or list contributions over a period."
---

# Achievements

Use this skill to turn repository and GitHub activity into a concise, evidence-based summary of impact.

## Workflow

1. Resolve the requested period from the user prompt. Default to the last 3 months when no period is given.
2. When the period is expressed relatively and the boundaries matter, translate it into exact dates and state the assumption clearly.
3. Run `scripts/collect-achievements.sh [since] [until]` with the resolved window. The script scans all local git repos found under `~/code`, `~/projects`, `~/src`, `~/dev`, and `~/work` (up to 3 levels deep) plus the current repo, and fetches PRs/issues cross-org via `gh search`. Set `GIT_SEARCH_ROOTS` (colon-separated) to override the search paths.
4. Read the collector output completely before drafting the summary.
5. Filter the raw evidence to the requested period and group related work into business-impact themes: revenue or growth (features, faster delivery), cost or efficiency (automation, toil removed), risk reduction (reliability, security, compliance), and customer or user outcomes.
6. For each theme, connect technical work to a business outcome — what changed, who benefited, and what was prevented or improved. Quantify whenever possible; estimate with explicit uncertainty when metrics aren’t available.

## Output expectations

- Use the user’s requested format when one is specified.
- Otherwise read `references/output-formats.md` and default to the Brag Doc format.
- Lead with business outcomes, not technical activity: "reduced checkout drop-off" beats "refactored PaymentForm."
- Ground every claim in the collected evidence. Do not invent metrics or inflate impact.
- If `gh` data is unavailable, say so and build the summary from the git evidence you do have.
- If the period is sparse, say that directly instead of padding.

## Resource map

- `scripts/collect-achievements.sh` -> collect commits, merged PRs, reviews, and closed issues for a period
- `references/output-formats.md` -> templates for brag docs, performance review input, weekly highlights, and resume bullets

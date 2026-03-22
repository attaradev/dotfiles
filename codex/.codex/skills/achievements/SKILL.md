---
name: "achievements"
description: "Collect commits, merged PRs, reviews, and closed issues for a time period, then synthesize them into a structured achievement summary. Use when the user asks to pull achievements, summarize shipped work, write a brag doc, prepare performance review input, or list contributions over a period."
---

# Achievements

Use this skill to turn repository and GitHub activity into a concise, evidence-based summary of impact.

## Workflow

1. Resolve the requested period from the user prompt. Default to the last 3 months when no period is given.
2. When the period is expressed relatively and the boundaries matter, translate it into exact dates and state the assumption clearly.
3. Run `scripts/collect-achievements.sh [since] [until]` with the resolved window.
4. Read the collector output completely before drafting the summary.
5. Filter the raw evidence to the requested period and group related work into themes instead of listing commits one by one.
6. Emphasize outcomes, beneficiaries, and risk reduced. Treat reviews and issue work as real achievements.

## Output expectations

- Use the user’s requested format when one is specified.
- Otherwise read `references/output-formats.md` and default to the Brag Doc format.
- Ground every claim in the collected evidence. Do not invent metrics or inflate impact.
- If `gh` data is unavailable, say so and build the summary from the git evidence you do have.
- If the period is sparse, say that directly instead of padding.

## Resource map

- `scripts/collect-achievements.sh` -> collect commits, merged PRs, reviews, and closed issues for a period
- `references/output-formats.md` -> templates for brag docs, performance review input, weekly highlights, and resume bullets

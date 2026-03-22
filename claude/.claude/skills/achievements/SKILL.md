---
name: achievements
description: This skill should be used when the user asks to "pull my achievements", "what did I ship", "summarize my work", "write my brag doc", "what have I done this quarter", "prepare my performance review input", "what did I accomplish", "list my contributions", or "what did I build this month". Collects commits, merged PRs, reviews, and closed issues for a period, then synthesizes them into a structured achievement summary.
disable-model-invocation: true
argument-hint: "[period — e.g. 'last month', 'Q1 2026', 'past 6 weeks', 'since January']"
---

# Achievements

Period: $ARGUMENTS

## Gather context

Interpret `$ARGUMENTS` as a time period and translate it to a `since` date that git understands (e.g. "last month" → "1 month ago", "Q1 2026" → "2026-01-01" with until "2026-03-31", "past 6 weeks" → "6 weeks ago"). When no period is given, default to "3 months ago".

Run the collector script with the resolved since date (and optional until date):

```
!`bash "$(dirname "$0")/scripts/collect-achievements.sh" "3 months ago" 2>&1`
```

> Note: The live context above uses the default period. Use the resolved date from `$ARGUMENTS` when calling the script interactively or via Bash.

## Task

1. Read the raw output from the collector — commits, PRs, reviews, and issues.
2. Filter to the requested period based on the dates visible in the output.
3. Group work into meaningful themes (feature delivery, reliability, refactoring, collaboration, etc.) rather than listing commits one-by-one.
4. Synthesize impact: what changed, who benefited, what was prevented or improved.
5. Produce output in the format specified by the user, or default to the Brag Doc format in `references/output-formats.md`.

## Quality bar

- Derive achievements from evidence in the data — do not invent or inflate.
- Prefer outcomes over activity: "shipped checkout redesign that reduced drop-off" beats "made 12 commits to checkout."
- Cluster related commits and PRs into a single achievement rather than listing them atomically.
- Flag gaps honestly: if the data is sparse for the period, say so rather than padding.
- PR reviews and issue work are real achievements — include them.

## Additional resources

- **`references/output-formats.md`** — Templates for Brag Doc, Performance Review Input, Weekly Highlights, and Resume Bullets, plus framing guidance.
- **`scripts/collect-achievements.sh`** — Collects commits, merged PRs, PR reviews, and closed issues. Usage: `collect-achievements.sh [since] [until]`

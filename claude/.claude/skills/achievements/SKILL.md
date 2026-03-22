---
name: achievements
description: This skill should be used when the user asks to "pull my achievements", "what did I ship", "summarize my work", "write my brag doc", "what have I done this quarter", "prepare my performance review input", "what did I accomplish", "list my contributions", or "what did I build this month". Collects commits, merged PRs, reviews, and closed issues for a period, then synthesizes them into a structured achievement summary.
disable-model-invocation: true
argument-hint: "[period] [for technical|non-technical|exec|both — optional audience]"
---

# Achievements

Period: $ARGUMENTS

## Gather context

Interpret `$ARGUMENTS` as a time period and translate it to a `since` date that git understands (e.g. "last month" → "1 month ago", "Q1 2026" → "2026-01-01" with until "2026-03-31", "past 6 weeks" → "6 weeks ago"). When no period is given, default to "3 months ago".

Run the collector script with the resolved since date (and optional until date):

```
!`bash "$HOME/.claude/skills/achievements/scripts/collect-achievements.sh" "3 months ago" 2>&1`
```

> Note: The live context above uses the default period. Use the resolved date from `$ARGUMENTS` when calling the script interactively or via Bash.
>
> The script scans all git repos found under `~/code`, `~/projects`, `~/src`, `~/dev`, and `~/work` (up to 3 levels deep), plus the current repo. Set `GIT_SEARCH_ROOTS` (colon-separated paths) to override. PRs and issues are fetched cross-org via `gh search`.

## Task

1. Read the raw output from the collector — commits, PRs, reviews, and issues.
2. Filter to the requested period based on the dates visible in the output.
3. Group work into business-impact themes: revenue or growth (new features, faster delivery), cost or efficiency (automation, toil removed, infra savings), risk reduction (reliability, security, compliance), and customer or user outcomes (experience improvements, churn prevention).
4. For each theme, connect the technical work to a business outcome: what changed, who benefited (users, customers, the team, the business), and what was prevented or improved.
5. Detect the audience from `$ARGUMENTS` (keywords: `technical`, `non-technical`, `exec`, `executive`, `both`). If not specified, default to the Brag Doc format. If `both`, produce the Technical section followed by the Non-Technical/Executive section. See `references/output-formats.md` for all templates.

## Quality bar

- Derive achievements from evidence in the data — do not invent or inflate.
- Lead with business outcomes, not technical activity: "reduced checkout drop-off by removing friction in the payment flow" beats "refactored PaymentForm component."
- Quantify whenever possible — latency numbers, error rates, time saved, users affected. Estimate with explicit uncertainty when exact metrics aren't available.
- Cluster related commits and PRs into a single achievement rather than listing them atomically.
- Flag gaps honestly: if the data is sparse for the period, say so rather than padding.
- PR reviews and issue work are real achievements — include them, especially when they prevented a bug or unblocked a team.

## Additional resources

- **`references/output-formats.md`** — Templates for Brag Doc, Performance Review Input, Weekly Highlights, and Resume Bullets, plus framing guidance.
- **`scripts/collect-achievements.sh`** — Scans all local repos for commits; uses `gh search` for cross-org PRs and issues. Usage: `collect-achievements.sh [since] [until]`. Set `GIT_SEARCH_ROOTS` (colon-separated) to control which directories are searched.

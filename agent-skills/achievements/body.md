## Gather context

Read `references/output-formats.md` before writing any output — the chosen format template must be used verbatim.

Interpret the user request as a time period and translate it to a `since` date that git understands (e.g. "last month" → "1 month ago", "Q1 2026" → "2026-01-01" with until "2026-03-31", "past 6 weeks" → "6 weeks ago"). When no period is given, default to "3 months ago".

Run the collector script with the resolved since date (and optional until date) with Bash before proceeding:

```
bash "scripts/collect-achievements.sh" "<since>" "<until>" 2>&1
```

The script scans all git repos found under `~/code`, `~/projects`, `~/src`, `~/dev`, and `~/work` (up to 3 levels deep), plus the current repo. Set `GIT_SEARCH_ROOTS` (colon-separated paths) to override. PRs and issues are fetched cross-org via `gh search`.

## Task

1. Read the raw output from the collector — commits, PRs, reviews, and issues.
2. Filter to the requested period based on the dates visible in the output.
3. Group work into business-impact themes: revenue or growth (new features, faster delivery), cost or efficiency (automation, toil removed, infra savings), risk reduction (reliability, security, compliance), and customer or user outcomes (experience improvements, churn prevention).
4. For each theme, connect the technical work to a business outcome: what changed, who benefited (users, customers, the team, the business), and what was prevented or improved.
5. Detect the audience from the user request (keywords: `technical`, `non-technical`, `exec`, `executive`, `both`). If not specified, default to the Brag Doc format. If `both`, produce the Technical section followed by the Non-Technical/Executive section. See `references/output-formats.md` for all templates.

## Quality bar

- Derive achievements from evidence in the data — do not invent or inflate.
- Lead with business outcomes, not technical activity: "reduced checkout drop-off by removing friction in the payment flow" beats "refactored PaymentForm component."
- Quantify whenever possible — latency numbers, error rates, time saved, users affected. Estimate with explicit uncertainty when exact metrics aren't available.
- Cluster related commits and PRs into a single achievement rather than listing them atomically.
- Flag gaps explicitly: if fewer than 5 commits/PRs appear for the period, open with "Note: limited data found for [period] — results may be incomplete." Do not pad with inferred or invented work.
- PR reviews and issue work are real achievements — include them, especially when they prevented a bug or unblocked a team.

## Anti-patterns

- **Atomic commit listing** — "Fixed bug in UserService", "Fixed bug in UserService (again)", "Fixed typo" as three separate bullets. Cluster into one achievement with context.
- **Invented metrics** — "Improved performance by ~40%" when no benchmark appears in the data. If no number exists, say "measurable improvement, exact delta not captured" or omit the claim.
- **Activity inflation** — listing every reviewed PR as a separate achievement. Group reviews into a single bullet: "Reviewed 12 PRs across checkout and auth; caught a race condition in #341 before it reached prod."
- **Jargon leaking into executive output** — "Migrated to event-sourced CQRS pattern" in a non-technical section. Translate: "Redesigned how order history is stored so it can now be audited reliably."
- **Missing period scope** — outputting achievements without stating the date range. Every output must include the resolved `[Period]` header so the reader knows what timeframe it covers.

## Additional resources

- **`references/output-formats.md`** — Templates for Brag Doc, Performance Review Input, Weekly Highlights, and Resume Bullets, plus framing guidance.
- **`scripts/collect-achievements.sh`** — Scans all local repos for commits; uses `gh search` for cross-org PRs and issues. Usage: `collect-achievements.sh [since] [until]`. Set `GIT_SEARCH_ROOTS` (colon-separated) to control which directories are searched.

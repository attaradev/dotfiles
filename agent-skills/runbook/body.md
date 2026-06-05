## Task

Gather repository context to understand the service before writing the runbook. Read relevant source files (entry points, config loading, health check handlers) to accurately describe what the service does and how it behaves under failure.

Determine the audience level: junior on-call or experienced ops. If junior, include 2–3 sentence explanations for every non-standard tool or concept referenced.

Match the format and location of any existing runbooks found in the live context. If none exist, use the template in `references/runbook-template.md` and save to `docs/runbooks/`.

Populate sections from code and config where possible. Leave explicit `[TODO: ...]` placeholders for operational details (alert thresholds, dashboard URLs, escalation contacts) that require input from the team — do not invent them.

## Quality bar

- Every troubleshooting step must be actionable without prior knowledge of the system
- Commands must be copy-pasteable — include actual flags, not placeholders where values are known
- Escalation paths must name roles or teams, not just say "escalate if needed"
- Runbooks go stale fast — flag assumptions that require periodic review

## Anti-patterns

- **Invented values** — Do not fabricate alert thresholds, dashboard URLs, SLO targets, or escalation contacts. Use `[TODO: ...]` placeholders and flag them clearly.
- **Generic steps** — "Check the logs" or "restart the service" without specifying the command, expected output, or decision branch is not a troubleshooting step.
- **Missing decision branches** — Each diagnostic step must tell the engineer what to do based on what they find (e.g. "if you see X, do Y; otherwise do Z"), not just what to look at.
- **Undated runbook** — Always populate `Last reviewed` with today's date and set a concrete `Review cadence`. A runbook with no review date will silently go stale.

## Additional resources

- **`references/runbook-template.md`** — Full runbook template with section guidance.

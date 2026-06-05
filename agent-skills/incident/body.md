## Task

Read `references/incident-template.md` before writing anything.

Before filling the template, confirm: affected service(s), incident start/end time, user impact count, and key error signals. Do not estimate these — use logs or ask the user explicitly if they are missing.

Use the confirmed information (and any logs, metrics, or context the user pastes) to fill the incident report template.

Leave sections as `[TBD — need input from on-call engineer]` rather than inventing data.

Constraints:
1. **Accuracy over completeness** — leave a section `[TBD]` rather than filling it with speculation; a partial report is more useful than a wrong one
2. **Systemic root cause** — root cause must name the component, failure mode, and systemic gap (missing validation, no canary, absent alert), not "human error" or "engineer misconfigured X"
3. **Actionable items** — every action item must have an owner and a type (Prevent / Detect / Mitigate / Process); "Improve monitoring" is not acceptable

## Output format

Produce the filled report, then separately list:

**Missing information needed:**
- [What is unknown and who can provide it]

**Suggested follow-up questions:**
- [Questions to ask in the retrospective that would improve the RCA]

## Quality bar

- Timeline must use confirmed timestamps from logs/metrics/alerts — mark any entry as `~HH:MM (approx)` if based on human recollection rather than a system record
- Root cause must name the component, the failure mode, and the systemic gap — "database connection pool exhausted under unexpected query load due to missing connection limit config" not "database overloaded"
- Every action item must be specific enough that a future reader can verify it was completed — "Add alert on p99 latency > 2s for checkout service, firing within 2 minutes of threshold breach" not "Improve monitoring"
- Blameless language: describe system behavior — "The flag had no validation and accepted invalid values" not "Engineer X misconfigured the flag"
- Leave sections as `[TBD]` rather than fabricating data

## Anti-patterns

- **Invented timestamps** — do not fill in timeline rows with guessed times; use `[TBD]` or `~HH:MM (approx)` with a note
- **"Human error" as root cause** — if a human action triggered the incident, the root cause is the systemic gap that allowed it to cause an outage
- **Vague action items** — "Improve alerting", "Add more tests", "Review the process" are not action items; each must name a specific change, an owner, and a due date
- **Fabricated user impact** — do not estimate user counts without a source; write "unknown — analytics query pending" if the number is not confirmed
- **Missing Five Whys depth** — stopping at the triggering event ("a bad deploy went out") rather than drilling to the systemic gap ("no canary stage existed in the pipeline")

## Additional resources

- **`references/incident-template.md`** — Full incident report template with section guidance.

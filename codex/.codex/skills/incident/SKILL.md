---
name: "incident"
description: "Draft a blameless incident report or postmortem from symptoms, logs, and context. Use when the user asks to write an incident report, RCA, or post-incident review."
---

# Incident Report

Use this skill to turn incident evidence into a clear, blameless report with impact, timeline, root cause, and action items.

## Workflow

1. Gather the symptom description, logs, metrics, and any repository context that explains the failure.
2. Separate confirmed facts from uncertainty.
3. Fill the incident template with a precise timeline, root cause analysis, and remediation steps.
4. Include action items with owners and types so the follow-up work is actionable.

## Quality bar

- Timelines must use real timestamps when the data is available.
- Root cause analysis must identify the systemic failure, not just the triggering event.
- Every action item must have an owner and a type (`prevent recurrence`, `improve detection`, or `reduce impact`).
- Use blameless language; describe system behavior, not individual mistakes.
- Leave sections as `[TBD]` rather than fabricating data.

## Resource map

- `references/incident-template.md` contains the canonical incident report structure.

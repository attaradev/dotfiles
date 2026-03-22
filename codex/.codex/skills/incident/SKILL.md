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

## Quality rules

- Focus on systemic causes, not individual mistakes.
- Prefer partial accuracy over complete speculation.
- Make action items specific enough to verify later.
- Ask for missing information when a section cannot be filled credibly.

## Resources

- `references/incident-template.md` contains the canonical incident report structure.

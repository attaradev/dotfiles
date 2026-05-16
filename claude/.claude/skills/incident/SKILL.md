---
name: "incident"
description: "This skill should be used when the user asks to \"write an incident report\", \"draft a postmortem\", \"write a post-incident review\", \"document this incident\", \"create an RCA\", \"write up what happened\", or \"help me do the postmortem\". Produces a structured incident report with timeline, impact, root cause analysis, and action items from a description of symptoms and logs."
argument-hint: "[incident description, symptoms, or service affected]"
---

# Incident Report

Incident: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Recent commits that may have triggered the incident: !`git log --oneline --since='7 days ago' 2>/dev/null | head -20 || true`
- Recent deployments (tags): !`git tag --sort=-creatordate 2>/dev/null | head -10 || true`

## Task

Before writing, confirm: affected service(s), incident start/end time, user impact count, and key error signals. Do not estimate these — use logs or ask the user explicitly if they are missing.

Use the confirmed information (and any logs, metrics, or context the user pastes) to fill the incident report template from `references/incident-template.md`.

Leave sections as `[TBD — need input from on-call engineer]` rather than inventing data.

Focus on:
1. **Accuracy over completeness** — a partially filled but accurate report is more useful than a complete but speculative one
2. **Blameless tone** — identify systemic causes, not individual mistakes
3. **Actionable items** — every action item must have an owner and a type (prevent recurrence / improve detection / reduce impact)

## Output format

Produce the filled report, then separately list:

**Missing information needed:**
- [What is unknown and who can provide it]

**Suggested follow-up questions:**
- [Questions to ask in the retrospective that would improve the RCA]

## Quality bar

- Timeline must use confirmed timestamps from logs/metrics/alerts — mark any entry as 'approximately' if based on human recollection rather than a system record
- Root cause must identify the systemic failure, not just the triggering event
- Every action item must have an owner and a type (prevent recurrence / improve detection / reduce impact)
- Use blameless language — describe system behavior, not individual mistakes
- Leave sections as `[TBD]` rather than fabricating data

## Additional resources

- **`references/incident-template.md`** — Full incident report template with section guidance.

---
name: postmortem
description: This skill should be used when the user asks to "write a postmortem", "5-whys this incident", "post-incident review", "incident retrospective", "blameless postmortem", "RCA for this", or "root cause analysis". Produces a structured blameless post-incident postmortem with timeline, root cause analysis, contributing factors, and action items.
argument-hint: "[incident description, or reference to an existing incident doc or Jira ticket]"
---

# Post-Incident Postmortem

Incident: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing incident docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(incident|outage|postmortem|p0|p1|sev)" 2>/dev/null | head -8 || true`
- Recent git log around incident time: !`git log --oneline --since="7 days ago" 2>/dev/null | head -20 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the incident description. Write a blameless postmortem following the template in `references/postmortem-template.md`.

Work through:
1. **Incident summary** — what happened, who was affected, for how long
2. **Timeline** — ordered sequence of events from first signal to resolution
3. **Root cause** — the 5-whys chain that reaches the systemic cause
4. **Contributing factors** — conditions that made the incident possible or worse
5. **What went well** — what the team did right under pressure
6. **What went wrong** — where the system or process failed
7. **Action items** — specific, owned, time-bounded improvements

The goal is to learn, not to blame. Systems fail; the question is how to make them more resilient.

Think like a systems engineer: the root cause is never "human error" — it is the system condition that made human error possible or inevitable.

## Quality bar

- Timeline must be in chronological order with UTC timestamps
- Root cause must pass the 5-whys test — ask "why" until you reach a systemic cause, not a person
- "Human error" is never a root cause — it is a symptom; keep asking why
- Every action item must have: owner, description, and due date
- Action items must be preventive or detective — not punitive
- "We'll be more careful" is not an action item

## Additional resources

- **`references/postmortem-template.md`** — Document structure, 5-whys methodology, contributing factor taxonomy, action item classification, and blameless culture principles.

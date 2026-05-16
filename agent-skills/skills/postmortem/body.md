## Task

Read the incident description. Write a blameless postmortem following the template in `references/postmortem-template.md`.

Work through:
1. **Incident summary** — what happened, who was affected, for how long
2. **Timeline** — ordered sequence of events from first signal to resolution, using confirmed timestamps from logs/metrics/alerts — mark any entry as 'approximately' if based on human recollection
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

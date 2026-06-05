## Task

Read `references/gtm-template.md` before writing anything. Then read the launch topic carefully.

Produce a structured GTM brief by filling in every section of `references/gtm-template.md`. Every placeholder must be replaced with real content — leave no `[bracketed]` fields unfilled.

Cover:
- Who is the target audience for this launch (primary and secondary)
- What is the positioning — why should they care, in one sentence
- What is the launch sequencing (dogfood → beta → GA)
- What channels will reach them
- What the success criteria are for each phase
- What can go wrong and how to respond

Suggest saving the output to `docs/gtm-<slug>.md`.

## Anti-patterns

- **Generic audience**: "All users" or "enterprise customers" is not a segment. Name the role, plan tier, usage signal, or behaviour that identifies them.
- **Unmeasured exit criteria**: "Phase is done when it feels stable" — every phase exit must have a number (bug count, usage count, error rate, NPS threshold).
- **Channel without action**: "Use Slack" or "email customers" — name the specific channel, audience filter, and timing.
- **Success criteria set post-launch**: Write the targets before you see the data. If you are filling this in after launch, flag that explicitly.
- **Rollback plan omitted**: Every launch must state who has the authority to roll back, what the trigger condition is, and what the user-facing message will be.

## Quality bar

- Positioning must be one sentence that a non-technical user would understand
- Each launch phase must have entry and exit criteria — not just a description
- Channels must name the specific action: "post to #announcements on launch day" not "use Slack" — "email to users in the billing admin role who have >100 seats" not "email campaign"
- Success criteria must be pre-committed and measurable before the launch, not after
- Flag any launch risks that require action before launch: feature flag for rollback, data migration, customer-facing comms, performance at scale. Each risk must have a named mitigation owner and a deadline.

## Additional resources

- **`references/gtm-template.md`** — GTM brief template, positioning framework, channel selection, and launch phase structure.

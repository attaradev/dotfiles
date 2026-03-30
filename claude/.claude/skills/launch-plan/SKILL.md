---
name: launch-plan
description: This skill should be used when the user asks to "go-to-market plan", "launch strategy", "how do we roll this out", "GTM for this feature", "launch plan", "launch this feature", or "release strategy". Produces a structured go-to-market brief covering audience, positioning, launch phases, channels, and success criteria.
argument-hint: "[feature, product, or release to plan a launch for]"
---

# Go-to-Market Plan

Launch: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing launch or GTM docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(launch|gtm|go.to.market|rollout|release plan)" 2>/dev/null | head -8 || true`

## Task

Read the launch topic carefully. Think like a PM who has shipped features to production — your job is to make the launch land with the right audience, at the right time, with the right message.

Produce a structured GTM brief following the template in `references/gtm-template.md`.

Cover:
- Who is the target audience for this launch (primary and secondary)
- What is the positioning — why should they care, in one sentence
- What is the launch sequencing (dogfood → beta → GA)
- What channels will reach them
- What the success criteria are for each phase
- What can go wrong and how to respond

Suggest saving the output to `docs/gtm-<slug>.md`.

## Quality bar

- Positioning must be one sentence that a non-technical user would understand
- Each launch phase must have entry and exit criteria — not just a description
- Channels must be specific: "email to users in the billing admin role who have >100 seats" not "email campaign"
- Success criteria must be pre-committed and measurable before the launch, not after
- Flag any launch risks (feature flag needed? rollback plan? customer comms?)

## Additional resources

- **`references/gtm-template.md`** — GTM brief template, positioning framework, channel selection, and launch phase structure.

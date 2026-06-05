## Task

Read `references/onboarding-guide.md` before writing anything. Then gather the product context (product description, ICP, pricing/trial model, existing funnel data if provided). Design a complete onboarding system following the guide.

Produce:
1. **Activation milestone** — the single action that proves the user has experienced core value (the "aha moment")
2. **Onboarding funnel** — signup → activation → habit formation steps with drop-off points identified
3. **In-product flow** — welcome screen, empty states, tooltips, and progress indicators
4. **Email sequence** — subject lines, timing, and goal for each email from day 0 to day 14
5. **Segment-aware paths** — different flows for key user segments (role, company size, use case)
6. **Success metrics** — time-to-activation, activation rate, trial-to-paid conversion, day-7 retention

## Quality bar

- The activation milestone must be specific and measurable — not "user finds value" but "user publishes first report"
- The onboarding flow must minimise steps to the activation milestone — count them; every step that doesn't directly advance the user toward it must be cut or deferred
- Emails must be triggered by behaviour, not just time — "you haven't connected your account yet" beats "Day 3 reminder"
- Empty states are the most important onboarding surface — never show a blank screen without guidance
- Segment-aware paths are required if you serve more than one distinct user role

## Anti-patterns

Avoid these common failures (from `references/onboarding-guide.md` — Common onboarding failures):
- Activation milestone that doesn't predict retention — if activation rate is high but Day-7 retention is low, the milestone is wrong
- More than 5 steps between signup and activation milestone — count them; cut any that don't deliver value
- Time-only email triggers — every email must suppress if the user has already completed the target action
- Blank empty states — every first-visit screen with no data must have a CTA and brief explanation
- One path for all users when the product serves multiple distinct roles

## Additional resources

- **`references/onboarding-guide.md`** — Activation milestone framework, onboarding funnel stages, email sequence structure, empty state patterns, time-to-value optimization, success metric benchmarks, and common onboarding failures.

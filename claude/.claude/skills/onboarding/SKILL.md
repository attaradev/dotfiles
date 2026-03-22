---
name: onboarding
description: This skill should be used when the user asks to "design customer onboarding", "improve our onboarding flow", "reduce time to value", "onboarding email sequence", "activation milestone", "new user experience", "first run experience", or "why aren't trial users converting". Designs a complete customer onboarding system covering in-product flows, email sequences, and activation milestones.
disable-model-invocation: true
argument-hint: "[your product, the activation milestone, and where onboarding currently breaks down]"
---

# Customer Onboarding Design

Product / context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing onboarding docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(onboard|activation|aha.moment|time.to.value|trial|welcome)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the product and activation context carefully. Design a complete onboarding system following `references/onboarding-guide.md`.

Produce:
1. **Activation milestone** — the single action that proves the user has experienced core value (the "aha moment")
2. **Onboarding funnel** — signup → activation → habit formation steps with drop-off points identified
3. **In-product flow** — welcome screen, empty states, tooltips, and progress indicators
4. **Email sequence** — subject lines, timing, and goal for each email from day 0 to day 14
5. **Segment-aware paths** — different flows for key user segments (role, company size, use case)
6. **Success metrics** — time-to-activation, activation rate, trial-to-paid conversion, day-7 retention

## Quality bar

- The activation milestone must be specific and measurable — not "user finds value" but "user publishes first report"
- The onboarding flow must reduce friction to the activation milestone — every step that is not on the critical path is a detour
- Emails must be triggered by behaviour, not just time — "you haven't connected your account yet" beats "Day 3 reminder"
- Empty states are the most important onboarding surface — never show a blank screen without guidance
- Segment-aware paths are required if you serve more than one distinct user role

## Additional resources

- **`references/onboarding-guide.md`** — Activation milestone framework, onboarding funnel stages, email sequence structure, empty state patterns, time-to-value optimization, and success metric definitions.

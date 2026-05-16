# Customer Onboarding Guide

## Activation milestone definition

The activation milestone is the single action that proves the user has experienced the core value of your product. It is the "aha moment" made measurable.

Rules:
- It must be a specific, observable user action (not "understands the product")
- It must correlate with long-term retention — users who hit it should retain at 2× the rate of those who don't
- There must be only one primary activation milestone — multiple milestones signal unclear value prop

Examples:

| Product | Activation milestone |
|---------|---------------------|
| Slack | Send first message in a team channel |
| Dropbox | Store first file and access from second device |
| Loom | Share first video recording (link clicked by someone else) |
| Intercom | Send first in-app message to a live user |
| Stripe | Receive first successful payment |

---

## Onboarding funnel stages

```
Signup
  ↓
Profile/setup completion     ← Drop-off #1: friction in initial setup
  ↓
First core action            ← Drop-off #2: user doesn't know what to do next
  ↓
Activation milestone         ← Drop-off #3: user left before experiencing value
  ↓
Repeat usage (Day 7 return)  ← Drop-off #4: one-and-done; no habit formed
  ↓
Team spread / collaboration  ← Drop-off #5: solo user, no viral loop
  ↓
Paid conversion
```

Measure the conversion rate at every stage. Fix the biggest drop-off first.

---

## In-product onboarding patterns

### Welcome screen
- One question: "What are you trying to do?" — use the answer to fork the onboarding path
- Do not list every feature — route to the activation milestone directly
- Skip button must exist — power users should not be forced through basics

### Empty states
Every empty state is an onboarding moment. Replace blank screens with:
1. A brief explanation of what goes here
2. A CTA to create the first item
3. An example or sample (optional but effective)

```
Bad:  [blank white area]

Good: Your reports will appear here.
      [+ Create your first report]
      Or import from CSV ↗
```

### Progress indicators
Useful only when the setup sequence is multi-step and linear. Show progress toward the activation milestone, not just account completeness:

```
Getting started
[✓] Connect your data source
[✓] Import your first 100 records
[ ] Run your first report  ← you are here
[ ] Share with your team
```

### Tooltips / product tours
- Trigger on the first visit to a feature, not on every visit
- Limit to 3–5 steps maximum
- Each step must point to an actionable element, not just explain a concept
- Always include a skip option

---

## Email sequence

Trigger emails on behaviour, not just time. If the user completes the step, suppress the nudge.

| Email | Timing | Goal | Subject line pattern |
|-------|--------|------|---------------------|
| Welcome | Immediately on signup | Set expectations; link to first action | "One thing to do in [Product] right now" |
| Activation nudge | Day 1 if not activated | Drive to activation milestone | "You're one step away from [outcome]" |
| Social proof | Day 2 | Reduce doubt with a customer story | "How [similar company] did X with [Product]" |
| Feature spotlight | Day 4 if activated | Expand usage beyond activation | "[Feature] saves [ICP role] 2 hours a week" |
| Trial expiry warning | Day 10 (for 14-day trial) | Convert; remove objections | "Your trial ends in 4 days — here's what you get" |
| Hard expiry | Day 14 | Final conversion push | "Your trial has ended — keep your [data/work]" |
| Win-back | Day 21 (no conversion) | Re-engage with new hook | "We added X since you tried [Product]" |

### Email writing rules
- Subject lines: specific outcome, not product announcement
- Body: one goal per email; do not combine activation nudge with feature education
- CTA: single button, action-oriented ("Connect your account" not "Learn more")
- Triggered by behaviour: suppress the Day 1 nudge if the user already activated

---

## Segment-aware paths

If your product serves multiple roles or use cases, fork the onboarding at signup:

```
"What describes you best?"
○ Founder / individual  → path A: solo setup, quick-start template
○ Team lead             → path B: team invite prompt first
○ Developer / API user  → path C: API key generation + docs link
```

Minimum viable segmentation: two paths. Maximum practical: four.

---

## Success metrics

| Metric | Definition | Benchmark |
|--------|-----------|-----------|
| **Time to activation** | Median minutes from signup to activation milestone | Aim for < 10 min for self-serve |
| **Activation rate** | % of signups who hit the activation milestone | > 40% for self-serve |
| **Day-7 retention** | % of activated users who return within 7 days | > 60% |
| **Trial-to-paid conversion** | % of trial users who upgrade | 15–25% (self-serve) |
| **Invite rate** | % of activated users who invite at least one teammate | Track for virality |

If activation rate < 20%, fix the activation milestone definition or the path to it before tuning emails.

---

## Common onboarding failures

| Failure | Symptom | Fix |
|---------|---------|-----|
| Wrong activation milestone | High activation rate, low Day-7 retention | Find the action that actually predicts retention |
| Too many steps before value | Drop-off before activation | Remove every step that isn't on the critical path |
| Generic welcome email | Low open rate, no click | Personalise to signup source or stated use case |
| No empty state guidance | High bounce on first core page | Add sample data or a "create your first X" prompt |
| Same path for all users | Power users frustrated, new users lost | Add a "what brings you here?" fork at signup |
| No follow-up after trial expires | One-and-done | Add a win-back sequence at Day 21 |

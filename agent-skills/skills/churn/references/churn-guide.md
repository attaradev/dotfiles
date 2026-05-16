# Churn Analysis and Reduction Guide

## Churn type taxonomy

### By customer count vs revenue

| Type | Formula | What it tells you |
|------|---------|------------------|
| **Logo churn** | Customers lost / Customers at start of period | Customer count health; market fit signal |
| **Revenue churn (gross)** | MRR lost from churn / MRR at start | Revenue impact before expansion |
| **Revenue churn (net)** | (MRR lost − MRR gained from expansion) / MRR at start | True revenue health; can be negative (good) |

A company can have 5% logo churn but −2% net revenue churn if expansions outweigh losses. Focus on net revenue churn.

### By cause

| Type | Cause | Primary intervention |
|------|-------|---------------------|
| **Voluntary — product fit** | Product doesn't solve their problem | Product improvement or ICP tightening |
| **Voluntary — adoption failure** | Never fully activated; onboarding failed | Onboarding redesign, CS intervention |
| **Voluntary — competitive displacement** | Better/cheaper alternative found | Positioning, pricing, feature parity |
| **Voluntary — business failure** | Customer's own company shrank or closed | Cannot prevent; filter from churn analysis |
| **Involuntary — payment failure** | Credit card declined, expired | Dunning sequence (highest ROI fix) |
| **Involuntary — billing error** | Charged wrong amount; dispute | Billing system audit |

---

## Root cause analysis

Ask these questions for every churn cohort:

1. When did they last log in? (adoption failure vs active dissatisfaction)
2. Did they reach the activation milestone? (onboarding failure vs product failure)
3. What did they say at cancellation? (exit survey or CS call notes)
4. Which features did they use heavily vs never touch?
5. What was their company size and segment? (ICP fit signal)
6. Did they contact support before cancelling? (pain signal)

---

## At-risk signals (predictive, not reactive)

These signals appear 30–60 days before cancellation:

| Signal | Threshold | Action |
|--------|-----------|--------|
| Login frequency drop | <2 logins in 14 days (was weekly) | Triggered email + CS flag |
| Core feature usage drop | >50% decline week-over-week | In-app re-engagement prompt |
| Support ticket spike | 3+ tickets in 7 days | CS proactive outreach |
| Billing page visits | 2+ visits in 30 days | Sales/CS call trigger |
| Data export activity | Any export of all data | High-urgency CS call |
| No team spread | Single-seat product with no invites sent | Onboarding nudge to invite teammates |

Instrument these in your analytics stack and route alerts to CS.

---

## Cancellation flow design

### Goals of the cancellation flow

1. Confirm the intent (prevent accidental cancellations)
2. Collect a reason (1-click exit survey — required)
3. Offer a targeted save (match the offer to the stated reason)
4. Execute the cancellation cleanly if they still want out

### Exit survey (single-choice, required before cancel)

```
Why are you cancelling?

○ Too expensive
○ Missing a feature I need: ___________
○ Not using it enough to justify the cost
○ Switching to a different tool: ___________
○ My company / project ended
○ Other: ___________
```

### Save offers by reason

| Stated reason | Save offer |
|--------------|------------|
| Too expensive | Offer annual plan (saves 20%) or pause option (1–3 months) |
| Missing a feature | Route to product team; offer workaround or roadmap timeline |
| Not using it enough | Offer a 30-day free extension with an onboarding call |
| Switching to competitor | Ask what the competitor has; offer a feature comparison |
| Company ended | Pause instead of cancel; offer to resume when ready |

Do not make cancellation hard to find or multi-step. That is a dark pattern that generates chargebacks and public complaints.

---

## Dunning sequence (involuntary churn)

Involuntary churn (failed payments) is typically 20–40% of total churn and has the highest recovery rate of any churn type.

### Sequence

| Timing | Action |
|--------|--------|
| Day 0: Payment fails | Retry immediately; send "payment failed" email with update link |
| Day 3: Still failed | Retry; send 2nd email — clear, not alarming |
| Day 7: Still failed | Retry; send 3rd email with urgency; escalate high-ARR to CS for personal outreach |
| Day 14: Still failed | Final retry; send "account pausing" notice |
| Day 21: Resolved or churned | Close ticket; attempt win-back after 30 days |

**Smart retry**: retry on payday (1st and 15th of month), not just on a fixed interval.

---

## Win-back sequence

Target: churned customers who were healthy before leaving (not adoption failures).

| Timing | Message |
|--------|---------|
| Day 30 post-churn | "We've shipped X since you left" — feature update, no hard sell |
| Day 60 | Address their stated cancellation reason directly |
| Day 90 | Offer: discounted reactivation or free trial of new features |

Win-back conversion rates: 15–25% for voluntarily-churned, engaged customers. Higher when you address the specific exit reason.

---

## Churn benchmarks by ARR stage

| ARR | Acceptable monthly logo churn | Healthy NRR |
|-----|------------------------------|------------|
| <$1M | <5% | >100% |
| $1M–$10M | <3% | >105% |
| $10M–$50M | <2% | >110% |
| $50M+ | <1.5% | >120% |

If you are above these thresholds, churn is your primary growth constraint — more acquisition will not fix it.

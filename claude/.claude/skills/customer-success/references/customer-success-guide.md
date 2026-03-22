# Customer Success Playbook Guide

## CS model selection

Segment customers by ARR to determine the right CS motion:

| Tier | ARR per account | CS motion | Ratio (CS:accounts) |
|------|----------------|-----------|---------------------|
| **Enterprise** | >$25K/year | High-touch: named CSM, QBR, custom success plan | 1:10–20 |
| **Mid-market** | $5K–$25K/year | Mid-touch: pooled CSM, health score alerts, group training | 1:50–100 |
| **SMB** | <$5K/year | Low-touch: automated emails, in-product guidance, community | 1:200–500 |
| **Self-serve** | <$1K/year | Tech-touch: fully automated; CS only for escalations | 1:500+ |

Rule: the ARR per account must justify the CS cost. High-touch CS for a $500/year account is never unit-economic.

---

## Health score design

### Signal selection

Choose 4–6 signals. Each must come from observable product data:

| Signal | Weight | Rationale |
|--------|--------|-----------|
| Core feature usage frequency | High | Primary value delivery indicator |
| Login frequency (last 30 days) | Medium | Adoption breadth |
| Number of active seats / users | Medium | Team spread; viral expansion signal |
| Integrations connected | Medium | Depth of integration = switching cost |
| Support ticket volume (high = risk) | Medium | Inverse — high tickets signal friction |
| Feature adoption breadth | Low | Using more features = stickier |
| NPS / CSAT response | Low | Self-reported; lags behavioural signals |

### Scoring

```
Health Score = Σ (signal_value × weight) / max_possible_score × 100

Green:  75–100
Yellow: 50–74
Red:    0–49
```

Recalculate weekly. Alert CS when score drops a band (Green → Yellow, Yellow → Red).

---

## Intervention playbook by health state

### Red (score 0–49)

Signals: hasn't logged in for 14+ days, core feature unused for 21+ days, or support spike.

| Action | Owner | Timing |
|--------|-------|--------|
| Personal outreach (email or call) | CSM | Within 24 hours of red trigger |
| Diagnose root cause | CSM | First call |
| Offer: free training session or implementation help | CSM | Based on root cause |
| Escalate to leadership if no response in 7 days | CS lead | Day 7 |
| Executive business review (enterprise only) | AE + CSM | If at-risk >30 days |

### Yellow (score 50–74)

Signals: usage declining, not spreading to team, missing key activation milestone.

| Action | Owner | Timing |
|--------|-------|--------|
| Automated email: feature spotlight or use case guide | Automated | Day 1 of yellow |
| In-app prompt: highlight unused high-value feature | Automated | Day 3 |
| CSM check-in (mid-market+) | CSM | Day 7 if no improvement |

### Green (score 75–100)

Focus on expansion, not retention.

| Action | Owner | Timing |
|--------|-------|--------|
| Monitor for expansion triggers (see below) | CSM | Ongoing |
| Quarterly business review | CSM | Quarterly |
| Reference / case study ask | CSM | At peak satisfaction |

---

## Expansion playbook

### Expansion triggers

Act on these signals — do not expand on a calendar cadence:

| Trigger | Signal | Expansion play |
|---------|--------|---------------|
| **Seat limit** | >80% of seat allowance used | Upsell to next tier |
| **Usage limit** | >80% of usage quota consumed | Usage upsell or tier upgrade |
| **New use case** | User starts using product for a purpose outside their original scope | Cross-sell second product or module |
| **New department** | Users from a new team appear in product | New seat block or department license |
| **Integration request** | Asks about an integration that requires a higher tier | Upgrade conversation |
| **High NPS + green health** | NPS 9–10 + green score | Reference ask + expansion conversation |

### Expansion conversation framework

1. **Reference the trigger**: "I noticed your team has grown to 18 seats on a 20-seat plan"
2. **Quantify current value**: "You're processing X records/month — that's [outcome] relative to when you started"
3. **Show the next tier's value**: "Growth plan adds [feature] which would [specific benefit for them]"
4. **Remove friction**: offer a trial of the higher tier feature, not just a price quote

---

## QBR structure

Run QBRs for enterprise and high-value mid-market customers quarterly.

### Agenda (60 minutes)

| Section | Time | Content |
|---------|------|---------|
| **Business review** | 15 min | Customer's goals for the quarter; did they achieve them? |
| **Product usage summary** | 15 min | Health score trend, key metrics, adoption highlights |
| **Value delivered** | 10 min | Quantified outcomes tied to the customer's stated goals |
| **Roadmap preview** | 10 min | Upcoming features relevant to their use case |
| **Next quarter goals** | 10 min | Agree on 2–3 success criteria for next QBR |

### QBR output

Every QBR must end with:
- A written summary sent within 24 hours
- 2–3 agreed next-quarter goals with owners on both sides
- A decision or commitment (renewal, expansion, project kickoff, or escalation)

A QBR that ends with "we'll stay in touch" has failed.

---

## CS-to-sales handoff

Define clearly to avoid CS doing unpaid sales work and sales missing warm leads.

| Signal | CS action | Sales action |
|--------|-----------|-------------|
| Account asks about enterprise features | CS qualifies: budget + authority + need + timeline | CS hands off with BANT summary; Sales leads from here |
| Expansion > 30% of current ARR | CS flags to sales | AE takes the expansion conversation |
| New executive sponsor | CS introduces AE | AE re-qualifies and builds relationship |
| Customer asks about new product line | CS captures the need | AE demos the new product |

CS and sales share the expansion number. CS owns the relationship; sales owns the close.

---

## NRR impact framework

Quantify the expected impact of CS investment:

```
Current NRR:           102%
Target NRR:            112%

Gap:                    10 percentage points on $X ARR base
= additional $X × 10% = $Y MRR retained or expanded per year

CS headcount to close gap:
  Average CSM manages $2M–$3M ARR
  Improvement target: 10pp NRR on $X ARR
  Required headcount: X / $2.5M CSMs
```

Frame CS hiring as an NRR investment, not a cost centre. A CSM who improves NRR by 5pp on a $3M book pays for themselves in < 6 months.

# Prioritization Frameworks

## Framework selection guide

| Framework | Best when | Avoid when |
|-----------|----------|-----------|
| RICE | You have quantitative estimates for reach and effort | Most inputs are guesses with no data to anchor them |
| MoSCoW | You need to align stakeholders on what ships in a fixed release | You need to rank 20+ items against each other |
| ICE | You want fast, low-ceremony scoring | Precision matters and you have the data for RICE |
| Opportunity scoring | You have user research with importance + satisfaction ratings | You haven't done structured user research |

---

## RICE

**Score = (Reach × Impact × Confidence) / Effort**

| Factor | Definition | Scale |
|--------|-----------|-------|
| Reach | How many users affected per quarter | Raw number (e.g., 2,000 users) |
| Impact | How much does it move the needle per user | 3 = massive, 2 = high, 1 = medium, 0.5 = low, 0.25 = minimal |
| Confidence | How certain are you of the estimates | 100% = high, 80% = medium, 50% = low |
| Effort | Total person-months to ship | Raw number (e.g., 2 person-months) |

Example:
- Reach: 1,500 users/quarter
- Impact: 2 (high)
- Confidence: 80%
- Effort: 3 person-months
- Score: (1500 × 2 × 0.8) / 3 = **800**

Use RICE when you have quantitative anchors. When you do not, state the assumption and use a range.

---

## MoSCoW

Categorise each item into exactly one bucket:

| Bucket | Meaning |
|--------|---------|
| **Must have** | Non-negotiable — without this, the release fails or is not viable |
| **Should have** | Important and expected, but the release can ship without it |
| **Could have** | Nice-to-have; include only if capacity allows |
| **Won't have (this time)** | Explicitly deferred — sets expectations and prevents scope creep |

Rules:
- "Must have" should account for no more than 60% of capacity — if everything is a must, nothing is
- Every "Won't have" item should have an owner and a revisit date
- Use MoSCoW to align stakeholders on a release scope, not to compare items against each other

---

## ICE

**Score = Impact + Confidence + Ease** (each 1–10)

| Factor | Definition |
|--------|-----------|
| Impact | How significantly will this move the target metric (1 = minimal, 10 = transformative) |
| Confidence | How sure are you of the impact and ease estimates (1 = pure guess, 10 = validated with data) |
| Ease | How easy is this to implement (1 = months of work, 10 = hours of work) |

Fast and dirty. Good for sprint-level prioritisation when you need a quick forcing function, not a quarterly roadmap.

---

## Opportunity scoring (Ulwick)

For each underserved outcome:

**Opportunity score = Importance + max(Importance − Satisfaction, 0)**

Survey users on:
- **Importance:** "When you [do job X], how important is it that you are able to [outcome]?" (1–10)
- **Satisfaction:** "When you [do job X], how satisfied are you with your current ability to [outcome]?" (1–10)

| Score | Interpretation |
|-------|---------------|
| ≥15 | Extreme opportunity — underserved and critical |
| 12–14 | Strong opportunity |
| 10–11 | Moderate opportunity |
| <10 | Overserved or low importance — deprioritise |

Use when you have structured user research. Produces the most defensible priorities.

---

## Scoring table template

For RICE:

| Item | Reach | Impact | Confidence | Effort | RICE score | Notes |
|------|-------|--------|-----------|--------|-----------|-------|
| Feature A | 2,000 | 2 | 0.8 | 2 | 1,600 | Assumption: reach based on active users last Q |
| Feature B | 500 | 3 | 0.5 | 1 | 750 | Confidence low — no user research yet |

For ICE:

| Item | Impact | Confidence | Ease | ICE score | Notes |
|------|--------|-----------|------|-----------|-------|
| Feature A | 8 | 7 | 6 | 21 | |

---

## Common pitfalls

| Pitfall | Fix |
|---------|-----|
| Everything scores high | Recalibrate — force a distribution; not every item can be massive impact |
| Effort is always underestimated | Apply a 1.5–2× buffer unless you have strong historical velocity data |
| Confidence is always 100% | Default to 80% for features with no user research; 50% for pure bets |
| Score overrides sequencing constraints | Note hard dependencies before sorting by score — a #3 item that unblocks #1 and #2 ships first |
| The framework is the output | The output is a decision; the framework is the reasoning |

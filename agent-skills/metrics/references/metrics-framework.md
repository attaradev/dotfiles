# Metrics Framework

## Metric taxonomy

| Type | Definition | Cadence | Example |
|------|-----------|---------|---------|
| North star | One metric that best represents the value the product delivers | Weekly/monthly | "Weekly active editors" |
| Input metric | A leading indicator the team can directly influence through product decisions | Daily/weekly | "% of new users who complete their first export within 7 days" |
| Output metric | A lagging outcome that confirms the product is working | Monthly/quarterly | "30-day retention", "NPS" |
| Guardrail metric | A signal that monitors for unintended harm | Ongoing | "Support ticket volume", "error rate", "revenue per user" |
| Anti-metric | Something the team explicitly will not optimise for | — | "Time on site" (if long sessions indicate confusion) |

---

## North star selection

A good north star:
- Reflects **user value**, not just business activity ("weekly active collaborators" > "DAU")
- Is **sensitive** — it moves when the product improves and drops when it degrades
- Is **specific** — "active users who have completed at least one [core action]" > "users"
- Is **lagging enough** to be meaningful but **leading enough** to be actionable (usually weekly or monthly)

North star formula patterns:
- Frequency × depth: "Users who [core action] ≥ N times per week"
- Adoption × retention: "Users who activated [feature] and returned within 30 days"
- Value delivered: "Outcomes completed per active user per week"

**Test for a good north star:** If this number goes up sustainably, is the business clearly healthier? If it can go up through manipulation (spam, dark patterns, inflating numbers), it fails the test.

---

## Input metrics

Input metrics are levers. The team must be able to run experiments that move them.

Common input metrics by category:

**Acquisition**
- Activation rate: % of new sign-ups who complete the core setup action
- Time to first value: median time from sign-up to first successful [core action]
- Onboarding completion rate

**Engagement**
- Feature adoption rate: % of active users who have used [feature] in the last 30 days
- Frequency distribution: % of actives who use the product daily / weekly / monthly
- Depth of use: median number of [actions] per session

**Retention**
- D1/D7/D30 retention: % of users who return on day 1, 7, 30 after first use
- Churn rate: % of active users who have not returned in [N] days
- Resurrection rate: % of churned users who reactivate

**Monetisation**
- Trial-to-paid conversion rate
- Expansion revenue rate: % of accounts that upsell within 90 days
- Net revenue retention (NRR)

---

## Guardrail metrics

Always include at least one from each category:

**Engagement health**
- Session error rate: if the feature introduces errors, users will bounce
- Support ticket volume: rising tickets indicate confusion or bugs
- NPS / CSAT: a proxy for user sentiment

**Business safety**
- Revenue per user: optimising for engagement should not cannibalise monetisation
- Conversion rate from free to paid: engagement gains should not come at the expense of conversion

**Technical health**
- p95 response time: performance regressions reduce engagement
- Error rate: errors directly cause drop-off

---

## Anti-metrics

Name what you will NOT optimise for, and state why.

| Anti-metric | Why we reject it |
|------------|----------------|
| Total page views | Users who are confused browse more pages; this metric rewards poor UX |
| Time on site | Longer sessions may indicate confusion, not value |
| Total sign-ups | Without activation and retention, sign-ups are vanity |
| Features shipped | Output ≠ outcomes; shipping features that nobody uses harms the product |

---

## Measurement plan template

| Metric | Type | Definition | Data source | Collection method | Reporting cadence | Owner |
|--------|------|-----------|------------|------------------|-----------------|-------|
| [Metric name] | North star / Input / Output / Guardrail | [Precise definition] | [DB table / event / API] | [Query / event tracking / survey] | [Daily / weekly / monthly] | [Name] |

---

## Measurement anti-patterns

| Pattern | Problem |
|---------|---------|
| North star = revenue | Revenue is an output of user value, not a measure of it; it optimises for extraction |
| Measuring too many things | If everything is a north star, nothing is; pick one |
| Input metrics that cannot be moved | "Brand awareness" cannot be directly influenced by a product team |
| Guardrails without owners | Guardrail metrics without someone responsible for acting on them are decoration |
| No baseline | Without a baseline, you cannot know if you moved the metric |
| Measuring after the fact | Define metrics before the feature ships; post-hoc metric selection is p-hacking |

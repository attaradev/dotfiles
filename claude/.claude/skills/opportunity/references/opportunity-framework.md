# Opportunity Assessment Framework

## Document template

Use this structure. Omit sections only when genuinely not applicable — do not omit them because the answer is uncertain; instead, state the uncertainty.

---

**Opportunity Assessment: [Name]**
**Date:** YYYY-MM-DD | **Author:** [Name] | **Status:** Draft

---

### Problem

One to two paragraphs. What is broken, missing, or suboptimal? Who experiences it? How often? What is the real cost — time, money, frustration, missed outcome?

Distinguish the symptom from the root cause. "Users complain about slow reports" is a symptom. "Aggregation runs synchronously on the request thread because we never had a job queue" is the cause.

### Target users

| Segment | Size estimate | Frequency | Severity |
|---------|--------------|-----------|----------|
| [Primary segment] | [N users / % of base] | [daily / weekly / monthly] | [high / medium / low] |
| [Secondary segment] | | | |

For B2B: distinguish buyer from user. Both matter; they have different jobs and different pain.

### Current alternatives

How do users solve this today? List workarounds, competitors, and manual processes. Explain why each alternative falls short and what that tells you about the job to be done.

### Why now

What has changed — technically, behaviourally, or competitively — that makes this the right time? If nothing has changed, explain why it was not worth investing before and what is different now.

### Strategic fit

Why is this the right company/team to solve it? What assets, data, distribution, or trust give an unfair advantage? If none, that is a signal worth naming.

### Size of opportunity

Back-of-envelope impact estimate. State your model and assumptions explicitly.

- **Top-down:** total addressable users × % experiencing problem × frequency × value per occurrence
- **Bottom-up:** known affected users × conversion assumption × value per user

Flag which assumptions carry the most uncertainty.

### Risks and unknowns

| Risk | Type | Likelihood | Impact | What would reduce it |
|------|------|-----------|--------|---------------------|
| [Risk] | Market / Feasibility / Viability / Adoption | H/M/L | H/M/L | [Evidence, spike, or experiment] |

### Investment case

**Proceed if:** [Conditions under which this is clearly worth investing]

**Do not proceed if:** [Conditions under which this is not worth the cost]

**Open questions:** [What you need to know to be confident — ordered by importance]

### Recommendation

One paragraph. Should the team invest? At what scale? What is the minimum next step to reduce the biggest uncertainty before committing?

---

## Key questions by section

### Problem
- Would users pay money or change their workflow to fix this?
- Is the pain acute (causes failure) or chronic (causes friction)?
- Does the problem recur, or is it a one-time setup cost?

### Target users
- Who feels the pain most acutely today? (early adopters)
- Who is the economic buyer vs. the daily user?
- What is the user's goal — what are they trying to accomplish when this problem gets in the way?

### Why now
- Regulatory change? Technology shift? Competitor gap? Behaviour change?
- If "not now" was the right answer before, what changed?

### Size
- Would a 10× larger market change the investment case? A 10× smaller one?
- What is the minimum viable size to justify building?

### Risks
- Market risk: does enough of the right audience have this problem?
- Feasibility risk: can we build a solution that actually works?
- Viability risk: can we charge enough, or will users adopt an alternative for free?
- Adoption risk: will users change their existing behaviour?

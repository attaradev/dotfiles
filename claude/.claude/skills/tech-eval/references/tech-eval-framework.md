# Technology Evaluation Framework

## Decision framing

Before scoring anything, answer:
- **What specifically is being decided?** (Not "which database" but "which database for storing time-series telemetry at 50K events/second with 90-day retention and ad-hoc query access")
- **What are the hard constraints?** (Budget cap, must integrate with X, must be self-hostable, team has no Go experience)
- **What is the time horizon?** (Proof-of-concept vs. 5-year platform decision)
- **Who owns the decision?** (Individual contributor vs. committee vs. needs executive sign-off)
- **What is the cost of being wrong?** (Easy to switch later vs. lock-in)

---

## Options to always include

Even if not requested, always evaluate:
- **Status quo** — what happens if nothing changes
- **Build in-house** — even if expensive, the comparison calibrates make-vs-buy
- **At least two external options** — a single external option comparison is not an evaluation

---

## Evaluation criteria

### Universal criteria (always include)

| Criterion | Description |
|-----------|------------|
| Functional fit | Does it do what we need today and in 18 months? |
| Total cost of ownership | Licensing + hosting + engineering + operational toil |
| Operational complexity | How hard is it to run, monitor, and upgrade? |
| Integration effort | How long to integrate with the existing stack? |
| Vendor/project risk | Is the vendor stable? Is the OSS project actively maintained? |
| Team capability | Does the team have the skills, or can they acquire them reasonably? |
| Lock-in risk | How hard is it to switch away if the decision turns out to be wrong? |

### Context-specific criteria (add as relevant)

| Context | Criteria to add |
|---------|----------------|
| Data stores | Query patterns, consistency model, write throughput, storage efficiency |
| Message systems | Ordering guarantees, delivery semantics, consumer group model |
| Infrastructure | Managed vs. self-hosted, cloud portability, autoscaling behaviour |
| Security-sensitive | Compliance certifications (SOC2, HIPAA), encryption at rest/transit, audit logging |
| Developer tools | DX quality, documentation, ecosystem, community size |

---

## Scoring matrix

Rate each option against each criterion. Use a 1–5 scale where 3 is "meets requirements adequately."

| Criterion | Weight | Option A | Option B | Option C | Build |
|-----------|--------|----------|----------|----------|-------|
| Functional fit | 30% | 4 | 5 | 3 | 5 |
| TCO | 25% | 4 | 3 | 5 | 2 |
| Operational complexity | 20% | 3 | 4 | 5 | 2 |
| Integration effort | 15% | 4 | 3 | 4 | 3 |
| Lock-in risk | 10% | 2 | 3 | 5 | 5 |
| **Weighted score** | | **3.5** | **3.8** | **4.1** | **3.3** |

Every score cell must have a one-sentence justification. "5 — fully meets requirements because it natively supports X and Y" is useful. "5" alone is not.

---

## Build vs. buy heuristics

**Build when:**
- The capability is a core competency and a source of competitive advantage
- No vendor solution fits well enough without significant customisation
- The team has the capacity and skills to build and maintain it
- Long-term TCO of build is clearly lower than buy after factoring in maintenance
- The problem space is well-understood and requirements are stable

**Buy when:**
- The capability is commodity infrastructure (auth, email, payments, logging)
- A vendor solution exists that covers ≥80% of requirements out of the box
- The team lacks the skills or capacity to maintain a custom solution
- Time-to-market matters more than customisation
- The problem space is poorly understood — buy first, build later if needed

---

## Trade-off analysis template

After the scoring matrix, write one paragraph per option:

**Option A: [Name]**
Wins on: [Where it genuinely leads]
Loses on: [Where it genuinely lags]
Non-obvious consideration: [What the score does not capture — ecosystem maturity, a hidden migration complexity, a strong community, a vendor's financial stability]
Best if: [The condition under which this option becomes the clear winner]

---

## Recommendation structure

**Recommended:** [Option X]

**Rationale:** [2–3 sentences. Why this option, not just that it scored highest — what specific attributes make it the right fit for this context.]

**Fallback:** [Option Y, if the primary fails procurement / budget / timeline.]

**Conditions that would change this recommendation:**
- If [constraint] changes, then [option Z] becomes preferable because [reason]
- If the team cannot acquire [skill], then [option W] is a safer choice

**Next step:** [The concrete action to move from decision to implementation — e.g., "run a one-week proof of concept against the production data model before committing"]

---

## Common pitfalls

| Pitfall | Fix |
|---------|-----|
| Evaluating against hypothetical requirements | Score against actual, confirmed requirements |
| Ignoring operational cost | A free tier product with high toil costs more than a paid managed service |
| Missing the exit cost | How much does it cost to switch away? Include this in TCO |
| Recency bias toward familiar tools | Weight criteria by importance to the problem, not familiarity |
| Analysis paralysis | Time-box the evaluation; a good-enough decision made quickly beats a perfect decision too late |
| Not including "do nothing" | Status quo must be an explicit option with explicit costs |

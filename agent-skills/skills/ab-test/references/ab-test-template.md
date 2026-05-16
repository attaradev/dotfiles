# A/B Test Brief Template

---

**Experiment: [Name]**
**Owner:** [PM] | **Date:** YYYY-MM-DD | **Target run date:** YYYY-MM-DD
**Status:** Designing | Running | Complete

---

## Hypothesis

**We believe that** [change]
**for** [user segment]
**will** [increase / decrease / not affect] [primary metric]
**because** [mechanism].

The hypothesis must be falsifiable: there must be a result that would cause you to reject it.

## Variants

| Variant | Description | Traffic allocation |
|---------|------------|-------------------|
| Control (A) | [Current experience — describe precisely] | 50% |
| Treatment (B) | [Changed experience — describe precisely] | 50% |

For multi-variant tests, justify why you need more than one treatment. Each additional variant increases the required sample size proportionally.

## Target population

**Unit of randomisation:** User / session / account / device

Choose the unit that matches the granularity of the change. Randomising by session when the change persists across sessions introduces carryover effects.

**Eligible population:** [Filter criteria — e.g., "logged-in users on web who have visited the pricing page at least once in the last 30 days"]

**Exclusions:** [Users to exclude and why — e.g., "internal employees", "users in other active experiments on this surface"]

## Metrics

### Primary metric (one only)

The single number that determines the ship decision.

| Metric | Baseline | MDE | Direction |
|--------|---------|-----|-----------|
| [e.g., Checkout conversion rate] | [e.g., 3.2%] | [e.g., 0.5 percentage points = 15.6% relative increase] | Increase |

**MDE justification:** Why is this the minimum effect worth detecting? (Smaller MDE = larger sample required — justify the trade-off.)

### Secondary metrics

Supporting signals that help interpret the primary result. A win on the primary + a loss on a secondary is a nuanced result, not a clean win.

| Metric | Baseline | Direction | Reason for tracking |
|--------|---------|-----------|-------------------|

### Guardrail metrics

Metrics that, if they move negatively beyond a threshold, trigger an early stop regardless of the primary result.

| Metric | Threshold | Action if breached |
|--------|----------|-------------------|
| Error rate | >0.5% increase | Stop experiment immediately |
| Support ticket volume | >20% increase vs. baseline week | Stop and investigate |
| Revenue per user | >5% decrease | Escalate to leadership |

## Sample size and duration

**Significance level (α):** 0.05 (5% false positive rate)
**Statistical power (1−β):** 0.80 (80% chance of detecting a true effect of the MDE)
**Required sample size per variant:** [N] — calculated using the MDE, baseline rate, α, and power above

Use an online calculator (e.g., Evan Miller's sample size calculator) or note the formula:

For proportions: n ≈ 2 × (Z_α/2 + Z_β)² × p(1−p) / δ²

Where p = baseline rate, δ = MDE in absolute terms.

**Estimated daily traffic to experiment:** [N eligible users / day]
**Estimated run time:** [N days] = [sample size per variant × 2] / [daily eligible traffic]

**Minimum run time:** 2 weeks, regardless of when significance is reached, to account for day-of-week effects and novelty bias.

## Analysis plan

**When to analyse:** After the minimum run time has elapsed AND the required sample size has been reached.

**Do not peek:** Do not analyse results before the pre-specified end date. Early stopping inflates false positive rates. If you must monitor early, use a sequential testing method (e.g., always-valid confidence intervals).

**Primary analysis:** Two-proportion z-test (or t-test for continuous metrics). Report the observed effect, 95% confidence interval, p-value, and absolute and relative change.

**Segmentation analysis (post-hoc):** If pre-specified, report results for [segment 1, segment 2]. Do not run exploratory segmentation after seeing results — this inflates false positives.

## Decision criteria

Pre-commit these before the experiment runs.

| Result | Condition | Decision |
|--------|-----------|---------|
| Ship | Primary metric improvement ≥ MDE with p < 0.05; no guardrail breached | Ship to 100% |
| Do not ship | Primary metric improvement < MDE or p ≥ 0.05 | Do not ship; document learning |
| Inconclusive | Effect direction inconsistent with hypothesis but not statistically significant | Extend run time by [N] days; do not adjust MDE |
| Escalate | Any guardrail metric breached | Stop experiment; investigate before deciding |

---

## Threats to validity

Identify at least two before running:

| Threat | Description | Mitigation |
|--------|------------|-----------|
| Novelty effect | Users behave differently because something changed, not because the change is better | Run for at least 2 weeks; analyse returning users separately |
| Selection bias | Eligible population is not representative of all users | Check that control and treatment groups are balanced on key attributes at randomisation |
| Seasonality | Business cycles (end of month, weekends, promotions) affect behaviour | Run across at least one complete weekly cycle; avoid launching during major holidays or campaigns |
| Instrumentation bias | The tracking for one variant is more reliable than the other | Verify event firing rates are equal across variants before launch |
| Interaction effects | Another experiment running on the same population affects results | Check experiment collision before launching |
| Carryover effects | Users who saw the treatment remember it after being assigned to control | Ensure randomisation is user-level and sticky |

---

## Results (complete after experiment)

**Run dates:** YYYY-MM-DD → YYYY-MM-DD
**Actual sample size:** [N control] / [N treatment]

| Metric | Control | Treatment | Absolute Δ | Relative Δ | p-value | 95% CI |
|--------|---------|-----------|------------|------------|---------|--------|
| [Primary] | | | | | | |
| [Guardrail 1] | | | | | | |

**Decision:** Ship / Do not ship / Extend / Escalate

**Learning:** [What did we learn, regardless of the outcome?]

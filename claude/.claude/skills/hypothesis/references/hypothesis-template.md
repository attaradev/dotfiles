# Hypothesis & Experiment Template

## Hypothesis statement format

**We believe that** [doing / building X]
**for** [this user segment]
**will result in** [this outcome]
**because** [this underlying reason or mechanism].

**We will know this is true when** [specific, measurable signal].

Example:
> We believe that showing estimated delivery dates on the product page for users in checkout will result in a 15% reduction in cart abandonment because uncertainty about delivery is the primary reason users leave without purchasing. We will know this is true when ≥15% fewer sessions that reach the cart page end without purchase within 7 days of shipping the feature.

---

## Assumption map

Before designing the experiment, list all assumptions embedded in the hypothesis and rank them by risk:

| Assumption | Type | Confidence | If wrong, impact |
|-----------|------|-----------|-----------------|
| Users abandon because of delivery uncertainty | Desirability | Low | High — kills the idea |
| We can accurately estimate delivery dates | Feasibility | Medium | High — degrades trust |
| Showing dates will not reduce conversion for in-stock items | Viability | High | Medium |

**Riskiest assumption:** The one with the highest impact if wrong and lowest current confidence. This is what the experiment must test.

Assumption types:
- **Desirability** — do users want this?
- **Feasibility** — can we build it?
- **Viability** — does it create or capture enough value?
- **Usability** — can users actually use it?

---

## Experiment design

### Hypothesis being tested
[Restate just the riskiest assumption in falsifiable form]

### Test type
Choose the cheapest method that can produce a falsifiable result:

| Method | Best for | Cost |
|--------|---------|------|
| User interview | Desirability, early exploration | Very low |
| Concierge / Wizard of Oz | Feasibility without building | Low |
| Landing page / smoke test | Demand validation | Low |
| Fake door / 404 test | Feature demand before building | Low |
| Prototype usability test | Usability | Medium |
| A/B test | Impact at scale, needs traffic | High |
| Shadow launch | Feasibility with real data | High |
| Beta program | All types, slower | High |

### What we will build or do
[Describe the experiment — be specific enough that someone else could run it]

### Who we will test with
[Sample size, segment, recruitment method]

### Duration
[How long will we run before reading results]

### What we will measure
**Primary metric:** [The one number that determines pass/fail]
**Secondary metrics:** [Supporting signals]
**Guardrail metrics:** [Signals that would make us stop early even if primary looks good]

### Success criteria (set before running)
**Pass:** [Specific threshold that confirms the hypothesis — e.g., ≥20% CTR, ≥5 out of 8 users complete the task without help]
**Fail:** [Specific threshold that invalidates the hypothesis]
**Inconclusive:** [What range of results means we need more data]

---

## Interpretation guide

### If the result is positive
- Does it confirm the specific assumption, or could another explanation account for it?
- Is the sample representative enough to generalise?
- What is the next experiment to run before committing to build?

### If the result is negative
- Does this kill the idea, or just this approach?
- What did we learn? Update the assumption map.
- Is there a narrower version of the hypothesis worth testing?

### If the result is inconclusive
- Was the sample size too small?
- Was the measurement period too short?
- Is the hypothesis falsifiable as stated? If not, rewrite it.

---

## Worked example

**Idea:** Add a "Save for later" button to the cart to reduce abandonment.

**Hypothesis:** We believe that giving users who add multiple items to their cart a way to save items for later will reduce cart abandonment by ≥10% because some users abandon when the total is higher than they expected, not because they lost interest. We will know this is true when checkout conversion from multi-item cart sessions increases by ≥10% in a 2-week A/B test.

**Riskiest assumption:** Users abandon because of total price shock, not because they lost interest or found a better price elsewhere.

**Cheapest test before building:** 5-minute exit survey shown to users who leave without purchasing: "What was the main reason you didn't complete your purchase today?" — if "total was too high" accounts for <10% of responses, the feature will not move the needle and should not be built.

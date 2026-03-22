---
name: pricing
description: This skill should be used when the user asks to "design a pricing model", "should we use freemium", "how should we price this", "pricing strategy", "pricing tiers", "free trial vs freemium", "usage-based pricing", "pricing page design", or "how do we test pricing". Designs a SaaS pricing model covering model selection, tier architecture, and go-to-market approach.
disable-model-invocation: true
argument-hint: "[your product, target customer, and current pricing situation or question]"
---

# SaaS Pricing Strategy

Product / context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing pricing references: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.txt" | xargs grep -l -iE "(pricing|tier|plan|freemium|trial)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the product and customer description carefully. Design a complete pricing strategy following `references/pricing-guide.md`.

Produce:
1. **Model recommendation** — which pricing model fits (per-seat, usage-based, flat, hybrid) and why
2. **Acquisition motion** — freemium, free trial, demo, or paid trial — with the decision rationale
3. **Tier architecture** — 2–4 tiers with names, price points, and the differentiating features per tier
4. **Value metric** — the unit that scales with customer value (seats, API calls, records, revenue)
5. **Packaging** — what goes in free/starter vs growth vs enterprise, and what is intentionally withheld
6. **Price testing plan** — how to validate price sensitivity before fully committing

## Quality bar

- The value metric must correlate with the customer's success, not just usage volume
- Freemium requires a sustainable conversion funnel — state the assumed free-to-paid conversion rate
- Every tier gate must reflect a real buyer segment, not arbitrary feature splitting
- Enterprise tier must justify itself: what does it include that growth customers genuinely need?
- Price anchoring: the highest tier should make the middle tier feel like the obvious choice

## Additional resources

- **`references/pricing-guide.md`** — Model taxonomy, freemium vs trial decision framework, value metric selection, tier design rules, price anchoring, and price testing methods.

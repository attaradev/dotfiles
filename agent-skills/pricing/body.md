## Task

Read `references/pricing-guide.md` before writing anything. Then read the product and customer description carefully. If a required input is unavailable (e.g., no defined value metric), flag it and state the default assumption being used. Design a complete pricing strategy following the guide.

Produce:
1. **Model recommendation** — which pricing model fits (per-seat, usage-based, flat, hybrid) and why
2. **Acquisition motion** — freemium, free trial, demo, or paid trial — with the decision rationale
3. **Tier architecture** — 2–4 tiers with names, price points, and the differentiating features per tier
4. **Value metric** — the unit that scales with customer value (seats, API calls, records, revenue)
5. **Packaging** — what goes in free/starter vs growth vs enterprise, and what is intentionally withheld
6. **Price testing plan** — pick 1–2 methods from the guide (Van Westendorp, A/B, WTP interviews, competitive map), state which price points are being tested, the acceptance criterion, and the minimum sample size or interview count

## Quality bar

- The value metric must correlate with customer outcomes, not just activity — state explicitly why the chosen metric rises when the customer gets more value (e.g., "more seats → wider team adoption → more workflows automated")
- Freemium requires a sustainable conversion funnel — state the assumed free-to-paid conversion rate
- Every tier gate must reflect a real buyer segment, not arbitrary feature splitting
- Enterprise tier must justify itself: what does it include that growth customers genuinely need?
- Price anchoring: the highest tier should make the middle tier feel like the obvious choice
- Reject tier designs that split by feature rather than by user segment, usage volume, or budget tier — feature-gating is a smell, not a strategy

## Additional resources

- **`references/pricing-guide.md`** — Model taxonomy, freemium vs trial decision framework, value metric selection, tier design rules, price anchoring, and price testing methods.

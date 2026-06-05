## Task

Read the financial context and questions carefully. Before modeling, confirm: current MRR/ARR, monthly churn rate, new MRR growth rate, CAC, and LTV. State which inputs are actuals vs. assumptions.

Build a complete SaaS financial model following `references/mrr-model-guide.md`.

Produce:
1. **MRR waterfall** — new MRR, expansion MRR, contraction MRR, churn MRR, and net new MRR for the period
2. **Unit economics** — CAC, LTV, LTV:CAC ratio, and CAC payback period per acquisition channel
3. **Net Revenue Retention** — NRR calculation and what it signals about expansion vs churn balance
4. **12-month ARR forecast** — base case, upside, and downside scenarios with key assumptions stated
5. **Rule of 40 assessment** — growth rate + profit margin and what it indicates for the current stage
6. **Levers** — the 2–3 model inputs with the highest impact on ARR in 12 months

## Quality bar

- Every assumption must be labeled as either "actual" or "assumed (reason)" — unlabeled numbers are not acceptable
- Show all five waterfall components (new, expansion, contraction, churn, net new) — a single net MRR number is an incomplete output
- If NRR < 90%, state: "NRR of X% is below the 90% floor — churn must be addressed before scaling acquisition"; if NRR > 120%, note it as best-in-class
- If CAC payback > 18 months, state: "Payback of X months exceeds the 18-month seed/Series A benchmark — capital efficiency is a risk"
- Scenarios must vary input assumptions (growth rate, churn rate); multiplying the base ARR by a factor is not a scenario

## Anti-patterns

- **Net-only MRR**: reporting "$5K net new MRR" without waterfall components — hides whether growth is driven by new logos, expansion, or churn masking
- **Blended CAC only**: computing a single blended CAC without channel breakdown — obscures which acquisition channels are efficient or underwater
- **Assumption-free scenarios**: labeling "upside" and "downside" without changing input assumptions — produces meaningless scenario bands
- **Silent assumptions**: using numbers from context without explicitly flagging them as actuals or estimates
- **Rule of 40 below $10M ARR**: applying Rule of 40 as a primary health signal for sub-$10M ARR businesses — it is not relevant at that stage (growth rate dominates)

## Additional resources

- **`references/mrr-model-guide.md`** — MRR waterfall formula, NRR/GRR calculations, CAC/LTV mechanics, rule-of-40, benchmark ranges by ARR stage, and forecast model structure.

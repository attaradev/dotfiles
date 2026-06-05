## Task

Read `references/churn-guide.md` before writing anything. Then read the churn context carefully. Before designing interventions, audit existing analytics to classify current churn as voluntary vs. involuntary and identify the top 3 cancellation reasons — do not assume them.

Diagnose drivers and produce a reduction plan following `references/churn-guide.md`.

Produce:
1. **Churn type breakdown** — voluntary vs involuntary; logo churn vs revenue churn; by segment/tier
2. **Root cause analysis** — classify cancellation reasons using the churn taxonomy
3. **At-risk signals** — product usage patterns that predict cancellation 30–60 days out
4. **Reduction interventions** — specific actions by churn type (in-product, email, CS, pricing)
5. **Cancellation flow design** — what to show, offer, and ask at the cancel moment
6. **Win-back sequence** — timing, trigger, and message for churned customers worth re-engaging
7. **Involuntary churn playbook** — failed payment recovery: dunning sequence and timing

## Quality bar

- Distinguish logo churn from revenue churn — they require different interventions
- At-risk signals must be observable in product data, not just "they stopped logging in" — distinguish measurable analytics signals (feature usage, login frequency) from those requiring user interviews
- Cancellation flow must not be manipulative ("roach motel") — cancellation must be reachable in ≤3 clicks from the account settings page with no mandatory phone call or support ticket
- Every intervention must map to a specific churn cause — do not apply generic retention tactics
- State the expected impact: "reducing involuntary churn from 1.5% to 0.8% MoM adds ~X% to net MRR"

## Anti-patterns

- **Pooling churn causes**: recommending "improve onboarding" when the data shows competitive displacement — interventions must map to the specific classified cause, not the most common generic one
- **Logo vs revenue conflation**: reporting "5% churn" without specifying logo or revenue; recommending the same intervention for both when a small number of large customers drive most revenue churn
- **Vague root cause hypotheses**: "customers may be leaving due to product issues" — state as "adoption-failure churn accounts for ~40% of logo churn because 60% of churned accounts never reached the activation milestone (first export/share)"
- **Applying win-back to all churned accounts**: win-back is for formerly-healthy accounts; running it on adoption failures wastes budget and re-inflates vanity metrics
- **Dunning on fixed intervals only**: retrying payment on day 3/7/14 without aligning to payday (1st and 15th) reduces recovery rates

## Additional resources

- **`references/churn-guide.md`** — Churn type taxonomy, root cause classification, at-risk signal library, cancellation flow patterns, dunning sequence timing, and win-back frameworks.

---
name: customer-success
description: This skill should be used when the user asks to "design a CS playbook", "customer health score", "QBR template", "expansion playbook", "upsell triggers", "at-risk customer intervention", "customer success strategy", "CS-to-sales handoff", or "how to scale customer success". Produces a complete CS playbook covering health scoring, expansion plays, and at-risk intervention.
disable-model-invocation: true
argument-hint: "[your product, customer segments, and current CS challenges or goals]"
---

# Customer Success Playbook

Context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing CS or account management docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(customer.success|health.score|qbr|expansion|upsell|churn|account)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the product and customer context carefully. Design a complete CS playbook following `references/customer-success-guide.md`.

Produce:
1. **CS model** — high-touch vs low-touch vs tech-touch segmentation by ARR tier
2. **Health score** — the 4–6 signals that predict retention and expansion; how to weight them
3. **Intervention playbook** — specific actions for red/yellow/green health states
4. **Expansion playbook** — the triggers, signals, and plays for upsell and cross-sell
5. **QBR template** — agenda, metrics to present, and outcome (decision / next step)
6. **CS-to-sales handoff** — when CS escalates to sales and what constitutes a warm lead

## Quality bar

- CS segmentation must be tied to ARR bands — high-touch for accounts that justify the CAC
- Health score signals must come from actual product data, not CS gut feeling
- Expansion plays must be triggered by genuine product usage signals, not calendar-based check-ins
- The QBR must drive to a decision or commitment — not just a status update
- CS is a revenue function: state the expected impact of the playbook on NRR

## Additional resources

- **`references/customer-success-guide.md`** — CS model selection, health score signal library, intervention playbook by health state, expansion trigger taxonomy, QBR structure, and NRR impact framework.

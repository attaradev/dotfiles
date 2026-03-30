---
name: churn
description: This skill should be used when the user asks to "analyse our churn", "why are customers leaving", "reduce churn", "churn investigation", "at-risk customers", "cancellation flow", "win-back strategy", "involuntary churn", "revenue churn vs logo churn", or "cohort churn analysis". Diagnoses churn drivers and produces a concrete reduction plan.
argument-hint: "[your product, current churn rate, and what you know about why customers cancel]"
---

# Churn Analysis and Reduction

Context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Analytics or metrics files: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.sql" | xargs grep -l -iE "(churn|cancel|retention|cohort|mrr)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the churn context carefully. Diagnose drivers and produce a reduction plan following `references/churn-guide.md`.

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
- At-risk signals must be observable in product data, not just "they stopped logging in"
- Cancellation flow must not be manipulative ("roach motel") — it must be honest and fast
- Every intervention must map to a specific churn cause — do not apply generic retention tactics
- State the expected impact: "reducing involuntary churn from 1.5% to 0.8% MoM adds ~X% to net MRR"

## Additional resources

- **`references/churn-guide.md`** — Churn type taxonomy, root cause classification, at-risk signal library, cancellation flow patterns, dunning sequence timing, and win-back frameworks.

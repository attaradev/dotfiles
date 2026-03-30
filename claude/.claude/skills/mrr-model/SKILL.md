---
name: mrr-model
description: This skill should be used when the user asks to "model our MRR", "ARR forecast", "MRR waterfall", "CAC LTV ratio", "SaaS financial model", "payback period", "rule of 40", "net revenue retention", "expansion MRR", or "build a SaaS metrics model". Builds a SaaS financial model covering MRR waterfall, unit economics, and growth forecasting.
argument-hint: "[current MRR, churn rate, growth rate, and any specific financial question to answer]"
---

# SaaS MRR / Financial Model

Context: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing financial model files: !`find . -maxdepth 4 -type f -name "*.md" -o -name "*.csv" | xargs grep -l -iE "(mrr|arr|cac|ltv|churn|revenue|arpu)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -6 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the financial context and questions carefully. Build a complete SaaS financial model following `references/mrr-model-guide.md`.

Produce:
1. **MRR waterfall** — new MRR, expansion MRR, contraction MRR, churn MRR, and net new MRR for the period
2. **Unit economics** — CAC, LTV, LTV:CAC ratio, and CAC payback period per acquisition channel
3. **Net Revenue Retention** — NRR calculation and what it signals about expansion vs churn balance
4. **12-month ARR forecast** — base case, upside, and downside scenarios with key assumptions stated
5. **Rule of 40 assessment** — growth rate + profit margin and what it indicates for the current stage
6. **Levers** — the 2–3 model inputs with the highest impact on ARR in 12 months

## Quality bar

- State every assumption explicitly — a model is only as useful as its assumptions are transparent
- Show the waterfall, not just the net number — the composition of MRR growth tells the real story
- NRR above 100% is a compounding asset; below 90% is a structural problem — call it out
- CAC payback period over 18 months is a warning sign at seed/Series A; note the benchmark
- Scenarios must use different input assumptions, not arbitrary revenue multipliers

## Additional resources

- **`references/mrr-model-guide.md`** — MRR waterfall formula, NRR/GRR calculations, CAC/LTV mechanics, rule-of-40, benchmark ranges by ARR stage, and forecast model structure.

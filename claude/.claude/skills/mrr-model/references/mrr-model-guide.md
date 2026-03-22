# SaaS MRR / Financial Model Guide

## MRR waterfall

The waterfall breaks net MRR change into its components. Never report just the net number — the composition tells the real story.

```
MRR at start of month:           $100,000

+ New MRR          (new customers)         +$8,000
+ Expansion MRR    (upgrades, seats added) +$4,000
− Contraction MRR  (downgrades)            −$2,000
− Churned MRR      (cancellations)         −$5,000
─────────────────────────────────────────────────
Net new MRR:                               +$5,000

MRR at end of month:             $105,000
```

### Formulas

```
Gross MRR Churn Rate     = Churned MRR / MRR at start
Net MRR Churn Rate       = (Churned MRR − Expansion MRR) / MRR at start
MRR Growth Rate          = Net new MRR / MRR at start
```

A negative net MRR churn rate means expansion outpaces churn — the business grows even without new customers.

---

## Net Revenue Retention (NRR)

NRR is the most important SaaS health metric after product-market fit.

```
NRR = (Starting MRR + Expansion − Contraction − Churn) / Starting MRR × 100

Example:
  Starting MRR:   $100,000
  + Expansion:     +$8,000
  − Contraction:   −$2,000
  − Churn:         −$5,000
  ─────────────
  Ending cohort:  $101,000

  NRR = $101,000 / $100,000 = 101%
```

### What NRR signals

| NRR | Signal |
|-----|--------|
| > 120% | Best-in-class; business compounds without new sales |
| 110–120% | Excellent; expansion revenue partially funds growth |
| 100–110% | Healthy; expansion roughly offsets churn |
| 90–100% | Warning; churn is outpacing expansion in cohorts |
| < 90% | Critical; fix churn before scaling acquisition |

### Gross Revenue Retention (GRR)

GRR excludes expansion (only counts contraction and churn):

```
GRR = (Starting MRR − Contraction − Churn) / Starting MRR × 100
```

GRR is a ceiling for NRR — no amount of expansion can compensate for a low GRR long-term. GRR < 80% is a structural problem.

---

## Unit economics

### CAC (Customer Acquisition Cost)

```
CAC = Total Sales & Marketing Spend / New Customers Acquired

Blended CAC: includes all S&M spend
Channel CAC: calculated per acquisition channel (paid, SEO, referral, outbound)
```

Always calculate CAC by channel — blended CAC hides which channels are efficient.

### LTV (Lifetime Value)

```
LTV = ARPU / Monthly Churn Rate

Example: $200 ARPU / 2% monthly churn = $10,000 LTV

More accurate (with expansion):
LTV = ARPU / (Gross Churn Rate − Expansion Rate)
```

### LTV:CAC ratio

| Ratio | Signal |
|-------|--------|
| < 1:1 | Losing money on every customer — stop acquiring |
| 1:1 – 3:1 | Marginal; improving |
| 3:1 | Healthy baseline for most SaaS |
| > 5:1 | Strong; potentially underinvesting in growth |

### CAC Payback Period

```
CAC Payback Period = CAC / (ARPU × Gross Margin)

Example: $1,200 CAC / ($200 ARPU × 70% gross margin) = 8.6 months
```

| Payback | Signal |
|---------|--------|
| < 12 months | Good for self-serve |
| 12–18 months | Acceptable for sales-led |
| > 24 months | Requires significant capital to sustain growth |

---

## ARR forecast model

### 12-month forecast structure

```
Month | Starting MRR | New | Expansion | Contraction | Churn | Ending MRR
  1   |   $100,000   | $8K |    $4K    |    −$2K     |  −$5K |  $105,000
  2   |   $105,000   | ... |    ...    |     ...     |  ...  |   ...
  ...
 12   |      ?       |     |           |             |       |      ?
```

### Assumptions to state explicitly

| Assumption | Example |
|-----------|---------|
| Monthly new MRR | $8,000 (flat) or +5% MoM growth |
| Gross churn rate | 2% MoM |
| Expansion rate | 3% of existing MRR per month |
| Contraction rate | 1% of existing MRR per month |
| New ACV | $2,400/year (fixed or growing) |

### Three scenarios

| Scenario | How to construct |
|----------|----------------|
| **Base** | Current growth rate continues; churn flat |
| **Upside** | New MRR grows 20% faster; churn improves 0.5% |
| **Downside** | New MRR slows 30%; churn increases 0.5% |

Do not construct scenarios by multiplying the base result — change the input assumptions.

---

## Rule of 40

```
Rule of 40 = ARR Growth Rate (%) + EBITDA Margin (%)

Example: 80% ARR growth + (−40)% margin = 40 → meets the rule
         30% ARR growth + 15% margin = 45  → above the rule
```

| Score | Signal |
|-------|--------|
| > 40 | Healthy; acceptable balance of growth and profitability |
| 20–40 | Needs improvement in at least one dimension |
| < 20 | Concerning; requires diagnosis |

The Rule of 40 is most relevant at $10M+ ARR. Below that, prioritize growth rate over margin.

---

## Benchmarks by ARR stage

| Stage | Acceptable MoM growth | Gross margin | NRR target |
|-------|----------------------|-------------|------------|
| $0–$1M ARR | 15–20% MoM | >60% | >100% |
| $1M–$10M | 10–15% MoM | >65% | >105% |
| $10M–$50M | 5–10% MoM | >70% | >110% |
| $50M+ | 3–6% MoM | >75% | >115% |

---

## High-leverage model inputs

Rank inputs by sensitivity (change 10%; measure ARR impact at month 12):

1. **Gross churn rate** — most sensitive input at every stage; 1% improvement in churn compounds heavily
2. **New MRR growth rate** — dominant at early stage before existing base is large
3. **Expansion rate** — increasingly important as base grows; best-in-class SaaS gets >30% of growth from expansion
4. **ACV (average contract value)** — increasing ACV by moving upmarket has higher unit economics than volume

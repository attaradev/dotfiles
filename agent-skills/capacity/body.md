## Task

Read `references/capacity-framework.md` before writing anything — it contains the document template, demand modelling patterns, and bottleneck identification rules you must follow.

Then read the system description and any existing infrastructure configuration. Produce a capacity plan using the document template in that reference.

Work through:
1. **Current state** — what are the key resources and their current utilisation?
2. **Demand model** — what drives load? What is the current peak and growth trajectory?
3. **Bottleneck identification** — which resource will be exhausted first?
4. **Headroom calculation** — how much runway exists at current and projected growth?
5. **Scaling options** — vertical, horizontal, architectural — with trade-offs
6. **Scaling triggers** — the specific thresholds at which each scaling action should be taken

Every assumption must be labelled inline as `[assumed]`, `[measured]`, or `[calculated]` — the same tags used in the Current state table. An unlabelled number is a hidden assumption and is not acceptable.

## Quality bar

- Every resource estimate must have a source (measured, assumed, or calculated)
- Growth projections must state the model used and its confidence level
- Bottleneck analysis must cover: CPU, memory, I/O (disk and network), connection pool, external dependency limits
- Scaling triggers must be specific: "scale out when p95 CPU > 70% for 5 minutes" not "when load is high"
- Headroom must be stated as days/months of runway at current growth rate — fast-growing systems need ≥90 days minimum; stable systems ≥30 days
- Cost estimates must include: compute, storage, bandwidth, and external services — provide per-option cost delta, not just absolute totals

## Anti-patterns

- **Planning for average, not peak** — headroom calculated on average load will be wrong; use p95/p99 or the measured peak window.
- **Skipping bottleneck identification** — listing scaling options before naming the primary bottleneck produces a menu, not a plan.
- **Vague triggers** — "scale when load is high" is not actionable; every trigger must have a metric, threshold, and window.
- **Single-resource analysis** — fixing CPU without checking whether the DB connection pool or external API quota will become the next bottleneck wastes the exercise.
- **Cost delta only** — stating "+$200/month" without noting what runway it buys makes the trade-off impossible to evaluate.

## Output format

Follow the document template in `references/capacity-framework.md` exactly — the sections are: Current state → Demand model → Bottleneck analysis → Scaling options → Scaling triggers → Cost model → Recommendations → Open questions.

## Additional resources

- **`references/capacity-framework.md`** — Document template, demand modelling patterns, bottleneck identification rules, and trigger design guidance.

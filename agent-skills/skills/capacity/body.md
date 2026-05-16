## Task

Read the system description and any existing infrastructure configuration. Produce a capacity plan following the framework in `references/capacity-framework.md`.

Work through:
1. **Current state** — what are the key resources and their current utilisation?
2. **Demand model** — what drives load? What is the current peak and growth trajectory?
3. **Bottleneck identification** — which resource will be exhausted first?
4. **Headroom calculation** — how much runway exists at current and projected growth?
5. **Scaling options** — vertical, horizontal, architectural — with trade-offs
6. **Scaling triggers** — the specific thresholds at which each scaling action should be taken

State assumptions explicitly. A capacity plan with hidden assumptions is dangerous.

## Quality bar

- Every resource estimate must have a source (measured, assumed, or calculated)
- Growth projections must state the model used and its confidence level
- Bottleneck analysis must cover: CPU, memory, I/O (disk and network), connection pool, external dependency limits
- Scaling triggers must be specific: "scale out when p95 CPU > 70% for 5 minutes" not "when load is high"
- Headroom must be stated as days/months of runway at current growth rate — fast-growing systems need ≥90 days minimum; stable systems ≥30 days
- Cost estimates must include: compute, storage, bandwidth, and external services — provide per-option cost delta, not just absolute totals

## Additional resources

- **`references/capacity-framework.md`** — Demand modelling, bottleneck analysis, headroom calculation, scaling patterns, and trigger design.

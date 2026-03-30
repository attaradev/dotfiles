---
name: capacity
description: This skill should be used when the user asks to "capacity plan for this", "how do we scale this", "sizing estimate", "can this handle the load", "what are the bottlenecks", "capacity analysis", "headroom analysis", or "when will we run out of capacity". Produces a capacity analysis covering current headroom, growth projections, bottlenecks, and scaling triggers.
argument-hint: "[service, system, or infrastructure component to analyse]"
---

# Capacity Plan

System: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Infrastructure / config files: !`find . -maxdepth 4 -type f \( -name "*.tf" -o -name "*.yaml" -o -name "*.yml" \) | xargs grep -l -iE "(cpu|memory|replica|instance|node|limit|request)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -10 || true`
- Existing capacity or scaling docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(capacity|scaling|throughput|bottleneck|headroom)" 2>/dev/null | head -8 || true`

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
- Include cost implications of each scaling option

## Additional resources

- **`references/capacity-framework.md`** — Demand modelling, bottleneck analysis, headroom calculation, scaling patterns, and trigger design.

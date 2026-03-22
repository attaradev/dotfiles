---
name: "capacity"
description: "Produce a capacity analysis for a service or infrastructure component when the user asks about load, bottlenecks, headroom, scaling, or when capacity will run out."
---

# Capacity Plan

Use this skill to assess current headroom, demand growth, likely bottlenecks, and scaling triggers for a system.

## Workflow

1. Read the system context and any existing infra or capacity docs.
2. Establish the current state: topology, allocations, and measured utilisation.
3. Model demand and growth explicitly, including the assumptions behind the projection.
4. Identify the first resource to saturate and the next constraint after that.
5. Compare vertical, horizontal, and architectural scaling options with cost and effort.
6. Define concrete thresholds that should trigger scaling action.

## Quality rules

- Source every estimate as measured, assumed, or calculated.
- Cover CPU, memory, disk I/O, network, DB connections, and external quotas where relevant.
- Use specific trigger thresholds, not vague "high load" language.
- State assumptions and confidence levels clearly.

## Resources

- `references/capacity-framework.md` contains the document template, demand modelling patterns, bottleneck rules, and trigger examples.

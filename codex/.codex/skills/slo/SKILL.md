---
name: "slo"
description: "Define SLIs, SLOs, SLAs, and error-budget policy for a service. Use when the user asks about reliability targets, SLOs, SLAs, or alert thresholds."
---

# SLI / SLO / SLA Definition

Use this skill to turn service reliability into measurable targets and action thresholds.

## Workflow

1. Read the service and its existing monitoring before choosing metrics.
2. Define measurable SLIs first, then set SLOs over a rolling window.
3. Compute the error budget and define fast-burn and slow-burn alerts.
4. Add an SLA only if there is an external commitment.

## Quality rules

- Use metrics that can be collected today.
- Make the SLO achievable from current reliability, not aspirational.
- Keep the SLA weaker than the SLO.
- State the measurement window explicitly.

## Resource map

- `references/slo-framework.md` -> SLI types, SLO target guidance, error-budget math, burn-rate alerting, and document template

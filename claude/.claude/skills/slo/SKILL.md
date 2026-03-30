---
name: slo
description: This skill should be used when the user asks to "define SLOs", "error budget for this", "what SLAs should we set", "reliability targets", "SLI SLO SLA for this", "service level objectives", or "how reliable does this need to be". Defines SLIs, SLOs, SLAs, and error budget policy with alerting thresholds for a service or feature.
argument-hint: "[service, API, or system to define reliability targets for]"
---

# SLI / SLO / SLA Definition

Service: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing SLO or monitoring config: !`find . -maxdepth 4 -type f | xargs grep -l -iE "(slo|sli|sla|error.budget|availability|p99|latency)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Alerting / monitoring definitions: !`find . -maxdepth 4 -name "*.yaml" -o -name "*.yml" | xargs grep -l -iE "(alert|promethe|grafana|datadog|slo)" 2>/dev/null | head -8 || true`

## Task

Read the service description. Think about what reliability means to the users of this service — what failures would they notice and how quickly.

Produce a complete SLO document following the framework in `references/slo-framework.md`:

1. **SLIs** — the raw measurements that indicate health (latency, availability, error rate, throughput)
2. **SLOs** — the targets those measurements must meet over a rolling window
3. **Error budget** — how much unreliability is acceptable per month, and the burn rate policy
4. **Alerting thresholds** — when to page (fast burn) vs. create a ticket (slow burn)
5. **SLA** — the external commitment, if any (must be softer than the SLO)
6. **Review cadence** — when and how to revisit the targets

Challenge the obvious targets. 99.9% availability sounds precise but means 43 minutes of downtime per month. Is that acceptable for this service? Is 99.99% achievable with the current architecture?

## Quality bar

- SLIs must be measurable today — if you cannot collect the metric, it is not an SLI yet
- SLOs must be aspirational but achievable — setting a target you have never hit sets the team up to fail
- Error budget burn rate alerts must distinguish fast burn (page now) from slow burn (ticket)
- The SLA must be weaker than the SLO — the internal target is always stricter than the external commitment
- Document the measurement window explicitly: 28-day rolling is more stable than calendar month

## Additional resources

- **`references/slo-framework.md`** — SLI types, SLO target guidance, error budget calculation, burn rate alerting, and common pitfalls.

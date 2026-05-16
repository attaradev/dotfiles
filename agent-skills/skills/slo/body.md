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

Before setting targets, ask: "What would customers consider unacceptable?" Reverse-engineer the SLA from that answer, then set the SLO 20% tighter than the SLA.

## Quality bar

- SLIs must be measurable today — if you cannot collect the metric, it is not an SLI yet
- SLOs must be aspirational but achievable — setting a target you have never hit sets the team up to fail
- Error budget burn rate alerts must distinguish fast burn (page now) from slow burn (ticket)
- The SLA must be weaker than the SLO — the internal target is always stricter than the external commitment
- Document the measurement window explicitly: 28-day rolling is more stable than calendar month
- Every SLO must name the specific metric being measured, the measurement window, and the alerting threshold (the alerting threshold must differ from the SLO target)

## Additional resources

- **`references/slo-framework.md`** — SLI types, SLO target guidance, error budget calculation, burn rate alerting, and common pitfalls.

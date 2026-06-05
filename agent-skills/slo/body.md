## Task

Read `references/slo-framework.md` before writing anything. Then read the service description. Think about what reliability means to the users of this service — what failures would they notice and how quickly.

Produce a complete SLO document following the framework in `references/slo-framework.md`. Use the document template in that file as the output structure:

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
- SLOs must be achievable — set the target at or just above current measured reliability; a target you have never hit creates a permanently depleted error budget
- Error budget burn rate alerts must distinguish fast burn (page now) from slow burn (ticket)
- The SLA must be weaker than the SLO — the internal target is always stricter than the external commitment
- Document the measurement window explicitly: 28-day rolling is more stable than calendar month
- Every SLO must name the specific metric being measured, the measurement window, and the alerting threshold (the alerting threshold must differ from the SLO target)

## Anti-patterns

- **SLA = SLO**: If the external commitment equals the internal target, any SLO breach triggers a contractual penalty. The SLA must always be weaker.
- **Immeasurable SLI**: If the metric cannot be collected today with the current stack, it is a future goal, not a current SLI — label it as such or drop it.
- **No baseline**: Setting a target without first measuring current reliability produces an arbitrary number. State the baseline that informed each target.
- **p50 latency SLO**: p50 hides tail latency. Only SLO on p95 or p99.
- **No error budget policy**: An SLO without a defined response (what happens when the budget is gone) is decorative.

## Additional resources

- **`references/slo-framework.md`** — SLI types, SLO target guidance, error budget calculation, burn rate alerting, document template, and common pitfalls.

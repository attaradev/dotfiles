# SLI / SLO / SLA Framework

## Definitions

| Term | Definition |
|------|-----------|
| **SLI** (Service Level Indicator) | A quantitative measure of a service behaviour (e.g., request success rate) |
| **SLO** (Service Level Objective) | The target value for an SLI over a measurement window (e.g., 99.9% success rate over 28 days) |
| **Error budget** | The amount of unreliability permitted within the SLO window (1 − SLO target) |
| **SLA** (Service Level Agreement) | An external contractual commitment, typically with financial consequences; must be weaker than the SLO |

---

## SLI types

### Availability

Proportion of requests that succeed (non-5xx response within a timeout).

```
SLI = successful_requests / total_requests
```

Exclude:
- Requests that fail due to client error (4xx)
- Requests during planned maintenance windows
- Health-check / synthetic monitor traffic

### Latency

Proportion of requests that complete within a threshold.

```
SLI = requests_under_threshold_ms / total_requests
```

Pick a threshold that matches user perception. Common thresholds: 100ms (interactive), 500ms (acceptable), 2000ms (degraded).

Report multiple percentiles but SLO on p99 or p95 — median hides tail latency.

### Error rate

Proportion of requests that return an error (often the inverse of availability, but can be scoped to a specific error class).

### Throughput / saturation

For batch systems or queues: proportion of time the system processes at the expected rate, or queue depth stays below a threshold.

### Data freshness

For data pipelines: proportion of time the most recent data is no older than a threshold.

---

## SLO target selection

| Nines | Availability | Monthly downtime budget |
|-------|------------|------------------------|
| 99% | 2 nines | 7h 18m |
| 99.5% | | 3h 39m |
| 99.9% | 3 nines | 43m 48s |
| 99.95% | | 21m 54s |
| 99.99% | 4 nines | 4m 22s |
| 99.999% | 5 nines | 26s |

**Guidance:**
- Start with your current actual reliability, not an aspirational target
- A target you have never hit creates a permanently depleted error budget
- Internal platform services can typically be one nine lower than the consumer-facing services they support
- 99.9% is a reasonable starting point for most APIs; 99.99% requires significant architectural investment

---

## Error budget

**Monthly error budget (minutes) = (1 − SLO) × 43,200 minutes**

For a 99.9% SLO: (1 − 0.999) × 43,200 = **43.2 minutes per month**

Error budget policy:
- **> 50% budget remaining:** Ship at normal velocity; experiments and changes proceed
- **25–50% budget remaining:** Increase caution on risky changes; review change queue
- **< 25% budget remaining:** Freeze non-critical deployments; focus on reliability
- **0% budget:** Freeze all changes; reliability work takes absolute priority until budget recovers

---

## Burn rate alerting

Burn rate = how fast the error budget is being consumed relative to the allowed rate.

A burn rate of 1 = consuming budget at exactly the SLO-allowed rate.
A burn rate of 10 = consuming budget 10× faster than allowed.

| Alert | Burn rate | Window | Urgency |
|-------|-----------|--------|---------|
| Fast burn (page) | > 14.4× | 1 hour | Page on-call immediately |
| Fast burn (page) | > 6× | 6 hours | Page on-call |
| Slow burn (ticket) | > 3× | 3 days | Create reliability ticket |
| Budget watch | > 1× | 28 days | Weekly review |

For a 99.9% SLO:
- Fast burn at 14.4× means: 2% of monthly budget consumed in 1 hour (14.4 = 0.02 / (1/720))
- At that rate, the monthly budget would be gone in ~2 hours

---

## Document template

---

**SLO Document: [Service Name]**
**Owner:** [Team] | **Date:** YYYY-MM-DD | **Review cadence:** [Quarterly]

### Service description

[What this service does, who depends on it, and why reliability matters]

### SLIs

| SLI | Measurement | Collection method |
|-----|------------|-----------------|
| Availability | `successful_requests / total_requests` | [Prometheus / Datadog / CloudWatch metric name] |
| Latency p99 | `requests < 500ms / total_requests` | [Metric name] |

### SLOs

| SLI | Target | Window |
|-----|--------|--------|
| Availability | ≥ 99.9% | 28-day rolling |
| Latency p99 | ≥ 95% of requests < 500ms | 28-day rolling |

### Error budget

| SLI | Monthly budget | Current consumption |
|-----|--------------|-------------------|
| Availability | 43.2 minutes | [Link to dashboard] |
| Latency | [N] minutes | [Link to dashboard] |

**Error budget policy:** [Link to or describe the freeze / slowdown thresholds above]

### Alerting

| Alert | Condition | Action |
|-------|-----------|--------|
| SLO fast burn — availability | Burn rate > 14.4× over 1 hour | Page on-call |
| SLO slow burn — availability | Burn rate > 3× over 3 days | Create P2 ticket |

### SLA (external commitment)

| Metric | Commitment | Remedy |
|--------|-----------|--------|
| Availability | ≥ 99.5% per calendar month | [Service credit / notification] |

SLA target (99.5%) is weaker than SLO target (99.9%) to provide a safety margin.

### Review cadence

SLOs reviewed [quarterly] by [owner + stakeholders]. Triggers for out-of-cycle review:
- Error budget depleted
- Significant architectural change
- New major dependency added

---

## Common pitfalls

| Pitfall | Fix |
|---------|-----|
| SLA = SLO | The SLA must be weaker than the SLO; otherwise any SLO breach triggers a contractual penalty |
| Immeasurable SLI | If you cannot collect the metric today, it is an aspiration, not an SLI |
| Target set without baseline | Always measure current reliability before setting a target |
| p50 latency SLO | p50 hides tail latency; SLO on p95 or p99 |
| No error budget policy | An SLO without a policy for when the budget runs out is decorative |
| Calendar month window | 28-day rolling window is more stable and avoids end-of-month spikes |

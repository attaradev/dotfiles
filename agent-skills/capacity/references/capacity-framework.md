# Capacity Planning Framework

## Document template

---

**Capacity Plan: [System Name]**
**Author:** [Name] | **Date:** YYYY-MM-DD | **Review date:** YYYY-MM-DD (quarterly)

---

### Current state

Describe the current deployment topology and resource allocations.

| Resource | Current allocation | Current peak utilisation | Source |
|----------|-------------------|------------------------|--------|
| CPU | [N vCPU per instance × N instances] | [X%] | [Measured / estimated] |
| Memory | [N GB per instance] | [X%] | [Measured / estimated] |
| Disk I/O | [N MB/s read / N MB/s write] | [X%] | [Measured / estimated] |
| Network | [N Gbps] | [X%] | [Measured / estimated] |
| DB connections | [Pool size: N] | [X active] | [Measured / estimated] |
| External API quota | [N req/s] | [X req/s] | [Measured / estimated] |

---

### Demand model

**What drives load?**
[Identify the primary demand driver: requests per second, concurrent users, data volume, job queue depth, etc.]

**Current peak load:**
- Requests per second: [N] (peak), [N] (average)
- Peak window: [time of day / day of week / event-driven]
- Load pattern: [steady / bursty / seasonal / event-driven]

**Growth trajectory:**
| Period | Projected load | Model basis |
|--------|--------------|-------------|
| Current | [N rps] | Measured |
| +3 months | [N rps] | [Linear / compound growth at X%/month based on Y] |
| +6 months | [N rps] | |
| +12 months | [N rps] | |

State growth model explicitly: "Linear growth at 15%/month based on user acquisition over the last quarter" is better than "assumes rapid growth."

---

### Bottleneck analysis

For each resource, calculate when it will be exhausted at projected growth:

| Resource | Saturation point | Current headroom | Time to saturation |
|----------|-----------------|-----------------|-------------------|
| CPU | 80% utilisation | [X%] | [N months at current growth] |
| Memory | 85% utilisation | [X%] | |
| DB connections | Pool exhausted | [X free] | |
| Disk IOPS | [Limit] | [X%] | |

**Primary bottleneck:** [The resource that will be exhausted first — this is where to focus]

**Secondary bottleneck:** [The next constraint after the primary is addressed]

**Why these thresholds?**
- CPU: >80% leaves insufficient headroom for bursts
- Memory: >85% risks OOM kills under sudden spikes
- DB connections: pool exhaustion causes cascading timeouts

---

### Scaling options

For each bottleneck, list the options in order of effort:

**Option 1: [Name]** — [e.g., Vertical scale: upgrade instance type]
- Effect: [Doubles CPU and memory]
- Cost: [+$X/month]
- Effort: [Low — config change + rolling restart]
- Buys: [N months of headroom]
- Limit: [Maximum instance type available]
- Risk: [Single point of failure; no redundancy improvement]

**Option 2: [Name]** — [e.g., Horizontal scale: add replicas]
- Effect: [Linearly increases throughput]
- Cost: [+$X/month per replica]
- Effort: [Medium — requires stateless service; session affinity review]
- Buys: [Unlimited headroom if stateless]
- Limit: [Database connection pool will become the next bottleneck at N replicas]

**Option 3: [Name]** — [e.g., Architectural: introduce read replicas / caching]
- Effect: [Reduces primary DB load by estimated X%]
- Cost: [+$X/month; N weeks of engineering]
- Effort: [High — requires application changes and cache invalidation strategy]
- Buys: [N months of headroom; reduces single-DB dependency]

---

### Scaling triggers

Pre-commit the thresholds at which each action will be taken. These must be monitored.

| Trigger | Threshold | Window | Action | Owner |
|---------|-----------|--------|--------|-------|
| CPU — warning | p95 CPU > 70% | 15 min | Review scaling options; no immediate action | On-call |
| CPU — critical | p95 CPU > 85% | 5 min | Scale out immediately | On-call |
| Memory — warning | RSS > 80% | 10 min | Investigate memory growth | On-call |
| DB connections — warning | Active > 80% of pool | 5 min | Scale out or increase pool | On-call |
| Response time degradation | p99 > 2× baseline | 5 min | Investigate; consider scale-out | On-call |

---

### Cost model

| Scenario | Monthly cost | Notes |
|----------|-------------|-------|
| Current | $[X] | [N instances of type Y] |
| Option 1 — vertical | $[X+Y] | [Upgraded to type Z] |
| Option 2 — horizontal (+N replicas) | $[X+Y] | [N additional instances] |
| Option 3 — architectural | $[X+Y] | [Caching layer + replicas] |

---

### Recommendations

1. **Immediate (< 1 month):** [Most urgent action based on headroom analysis]
2. **Short-term (1–3 months):** [Next action to buy runway]
3. **Medium-term (3–6 months):** [Architectural change to address root constraint]

### Open questions

| Question | Owner | Due |
|---------|-------|-----|
| [e.g., What is the actual DB connection pool size?] | [Name] | YYYY-MM-DD |

---

## Demand modelling patterns

| Pattern | Description | When to use |
|---------|------------|------------|
| Linear | Load grows by a fixed amount per period | Stable user base with predictable acquisition |
| Compound | Load grows by a fixed percentage per period | High-growth product |
| Seasonal | Cyclical peaks (daily, weekly, annual) | Consumer products, retail, payroll |
| Event-driven | Spikes tied to external events (releases, campaigns) | Marketing-heavy products |
| Step function | Sudden jumps when a large customer onboards | B2B / enterprise products |

Always ask: "What would a 10× traffic spike look like?" Even if unlikely, the answer reveals architecture fragility.

---

## Bottleneck identification rules

1. Profile before guessing — use APM traces, flame graphs, and database slow query logs
2. The bottleneck is always the slowest part of the system under load
3. Fixing a non-bottleneck resource does not improve throughput (Little's Law)
4. After fixing the primary bottleneck, a new one will emerge — plan for the next one
5. Connection pools exhaust faster than CPU — check pool sizing before scaling compute

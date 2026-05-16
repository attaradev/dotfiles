# Integration Design Framework

## Pattern selection

### Synchronous (request/response)

**Use when:**
- The caller needs the result immediately to proceed
- The latency budget allows for the round-trip (typically < 500ms)
- Simple error handling: if the call fails, the caller handles it directly

**Avoid when:**
- The callee is slow, unreliable, or under heavy load — it will drag the caller down
- The operation takes longer than a reasonable HTTP timeout
- You need to fan out to multiple systems

**Patterns:** REST API, gRPC, GraphQL

### Asynchronous (fire and forget / queue)

**Use when:**
- The caller does not need the result immediately
- The callee may be slower than the caller's acceptable latency
- You need to absorb traffic spikes (queue acts as buffer)
- The work can be retried safely if the callee fails

**Avoid when:**
- The user is waiting for the result and needs it in the same request
- Ordering is required but the queue does not guarantee it
- Exactly-once semantics are required and the queue only offers at-least-once

**Patterns:** Message queue (SQS, RabbitMQ), task queue (Celery, Sidekiq)

### Event-driven (pub/sub)

**Use when:**
- Multiple consumers need to react to the same event independently
- Producers and consumers should be decoupled — the producer does not know who cares
- The event log is valuable as an audit trail or replay source

**Avoid when:**
- Only one consumer exists — a direct queue is simpler
- The consumer needs to respond to the producer — pub/sub is one-way
- Event ordering across partitions is required

**Patterns:** Kafka, AWS SNS/SQS fan-out, Google Pub/Sub, EventBridge

### Webhook (outbound HTTP callback)

**Use when:**
- Notifying an external system of events in near real-time
- The external system cannot poll (e.g., SaaS partner, customer system)

**Always include:**
- HMAC signature for authenticity
- Retry with exponential backoff
- Delivery acknowledgement (consumer must return 2xx)
- Dead-letter / alerting for repeatedly failing deliveries

---

## Event / message schema

Every event must include:

```json
{
  "id": "evt_01HXYZ",
  "type": "order.completed",
  "version": "1.0",
  "occurred_at": "2024-01-15T10:30:00Z",
  "producer": "order-service",
  "payload": { ... }
}
```

| Field | Purpose |
|-------|---------|
| `id` | Globally unique; used for deduplication |
| `type` | Namespaced event name — `domain.noun.verb` convention |
| `version` | Schema version; enables consumers to handle old and new formats |
| `occurred_at` | When the event happened (not when it was published) |
| `producer` | Which service emitted the event; useful for debugging |
| `payload` | The event data; domain-specific |

**Naming convention:** `domain.noun.verb` in past tense — `order.payment.captured`, `user.account.deactivated`, `inventory.item.restocked`

---

## Failure taxonomy and mitigations

| Failure | Mitigation |
|---------|-----------|
| Producer crashes before publishing | Use transactional outbox pattern: write event to DB in same transaction as state change; background publisher reads and publishes |
| Message broker unavailable | Circuit breaker on producer; local buffer with bounded size |
| Consumer crashes mid-processing | At-least-once delivery + idempotent consumer; message returned to queue on crash |
| Consumer processes but acknowledgement lost | Idempotent consumer handles re-delivery safely |
| Poison message (always fails) | Max retry limit; route to dead-letter queue with alerting |
| Schema incompatibility | Version field; consumer ignores unknown fields; producer never removes required fields without version bump |
| Consumer too slow (backpressure) | Consumer scaling policy; queue depth alerting; backpressure propagation if latency-sensitive |

---

## Idempotency patterns

An idempotent operation produces the same result if executed multiple times.

**Database-level:** Use unique constraints on a natural key (e.g., `event_id`) — duplicate inserts fail silently.

**Application-level:** Store processed event IDs in a deduplication cache (Redis, DB) with a TTL. Before processing, check if the ID has been seen.

**Business-logic-level:** Design state machines so that applying the same transition twice is safe (e.g., "if order is already `completed`, ignore `complete` event").

**Idempotency key for APIs:** Accept a client-generated `Idempotency-Key` header. Return the cached response for duplicate requests within a TTL.

---

## Ordering guarantees

| Guarantee | How | Trade-off |
|-----------|-----|----------|
| No ordering | Parallel consumers; multiple partitions | Highest throughput |
| Per-key ordering | Kafka partition by key; single consumer per partition | Throughput limited by partition count; no cross-key ordering |
| Global ordering | Single partition; single consumer | Lowest throughput; single point of failure |
| Best-effort ordering | Sequence number in payload; consumer reorders in buffer | Added latency; buffer complexity |

**Default recommendation:** Design consumers to be order-independent. If ordering is required, scope it to the smallest possible key domain (e.g., per-user, not global).

---

## Observability requirements

Every integration must instrument:

| Signal | What to measure |
|--------|----------------|
| Publish latency | Time from event trigger to message published |
| Consumer lag | How far behind is the consumer from the producer (in messages or time) |
| Processing duration | Time to process each message |
| Error rate | % of messages that fail after max retries |
| Dead-letter queue depth | Messages that could not be processed; alert if non-zero |
| Throughput | Messages per second published and consumed |

**Consumer lag** is the most important single metric. Lag growing over time means the consumer cannot keep up — scale out or optimise before it becomes an incident.

---

## Integration design document template

**Integration: [Producer] → [Consumer] via [Pattern]**
**Author:** [Name] | **Date:** YYYY-MM-DD

### Why this pattern

[1–2 sentences justifying the pattern choice against the alternatives]

### Data flow

[What events or data move, in which direction, at what volume]

### Event schema

[Schema with all required fields; link to schema registry if applicable]

### Failure modes

| Failure | Detection | Recovery |
|---------|-----------|---------|
| [Component] fails | [How detected] | [Recovery path] |

### Idempotency

[How duplicate messages are handled]

### Ordering

[Whether ordering matters; how it is achieved or relaxed]

### Operational runbook

- Dead-letter queue: [Location and alerting threshold]
- Consumer lag alert: [Threshold and escalation]
- Schema change process: [How changes are versioned and deployed]

## Task

Read `references/integration-framework.md` before writing anything. Then read the integration scope carefully. Understand what data flows between systems, the latency requirements, and the failure consequences.

Produce an integration design following the framework in `references/integration-framework.md`:

1. **Pattern selection** — synchronous, asynchronous, event-driven, or hybrid — with justification
2. **Data flow** — what moves, in which direction, at what volume and frequency
3. **Event / message schema** — the contract between producer and consumer
4. **Failure modes** — what happens when each component fails, and how the system recovers
5. **Idempotency** — how duplicate messages or retries are handled safely
6. **Ordering** — whether ordering matters and how it is guaranteed or relaxed
7. **Operational concerns** — monitoring, dead-letter handling, schema evolution

The failure mode analysis is the most important section. A good integration design assumes every component will fail at the worst possible time.

## Quality bar

- Pattern choice must be justified against the latency, consistency, and coupling requirements
- Every failure mode must have a recovery path — no "this should not happen"
- Idempotency must be addressed for every mutating operation
- Schema must include a version field or equivalent mechanism for evolution
- Dead-letter queue / poison message handling must be explicit
- Every integration point must specify its failure mode and the system's behavior when that dependency is unavailable

## Anti-patterns

- **Skipping idempotency for "simple" operations** — if a message can be delivered more than once (at-least-once queues, webhook retries), every consumer must handle duplicates. "This will only fire once" is not a design.
- **Synchronous call to a slow or unreliable dependency** — if the callee has P99 latency > 200ms or a monthly error rate > 0.1%, a synchronous call will drag the caller's SLA down. Switch to async or add a circuit breaker with a defined fallback.
- **Failure mode listed as "N/A" or "should not happen"** — every component in the integration path must have an explicit failure scenario and recovery path. Omitting one means the on-call engineer has no runbook when it does happen.
- **Implicit schema contract** — consumers that parse raw fields without a version field will break silently on any producer change. Every schema must include `version` and consumers must handle unknown fields without crashing.
- **Dead-letter queue without an alert** — a DLQ with no alerting is a black hole. Poison messages accumulate unnoticed; the integration appears healthy until data loss is discovered.

## Additional resources

- **`references/integration-framework.md`** — Pattern selection guide, sync vs async trade-offs, event schema design, failure taxonomy, idempotency patterns, and observability requirements.

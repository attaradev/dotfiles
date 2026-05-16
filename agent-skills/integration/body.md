## Task

Read the integration scope carefully. Understand what data flows between systems, the latency requirements, and the failure consequences.

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

## Additional resources

- **`references/integration-framework.md`** — Pattern selection guide, sync vs async trade-offs, event schema design, failure taxonomy, idempotency patterns, and observability requirements.

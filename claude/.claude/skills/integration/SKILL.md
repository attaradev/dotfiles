---
name: integration
description: This skill should be used when the user asks to "integration design for this", "how should these systems talk", "event-driven design", "async vs sync for this", "integration pattern", "message queue design", "webhook design", or "API integration architecture". Produces an integration design covering pattern selection, event schema, failure modes, idempotency, ordering, and operational concerns.
argument-hint: "[the systems to integrate and the data or events to exchange]"
---

# Integration Design

Integration: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing integration or messaging code: !`find . -maxdepth 5 -type f | xargs grep -l -iE "(kafka|rabbitmq|sqs|pubsub|webhook|event|message.bus|queue)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -10 || true`
- Existing API clients or adapters: !`find . -maxdepth 5 -type f | xargs grep -l -iE "(http.client|api.client|adapter|gateway|connector)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`

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

## Additional resources

- **`references/integration-framework.md`** — Pattern selection guide, sync vs async trade-offs, event schema design, failure taxonomy, idempotency patterns, and observability requirements.

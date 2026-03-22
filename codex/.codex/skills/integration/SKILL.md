---
name: "integration"
description: "Design service integrations, event flows, and message contracts. Use when the user asks about integration architecture, event-driven design, webhooks, queues, or sync vs async trade-offs."
---

# Integration Design

Use this skill to choose the right integration pattern and make failure handling explicit.

## Workflow

1. Identify the data flow, latency needs, and failure consequences.
2. Choose synchronous, asynchronous, event-driven, or hybrid based on those constraints.
3. Define the event or message contract, ordering rules, retries, and dead-letter handling.
4. Make idempotency and recovery paths explicit for every mutating operation.

## Quality rules

- Justify the pattern choice against consistency, latency, and coupling.
- Every failure mode needs a recovery path.
- Include schema versioning for evolving messages.
- Treat the failure mode analysis as the core of the design.

## Resource map

- `references/integration-framework.md` -> pattern selection, event schema design, failure taxonomy, idempotency, ordering, and operational concerns

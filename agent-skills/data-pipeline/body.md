## Task

Read `references/data-pipeline-guide.md` before writing anything. Then read the pipeline description carefully. Design a complete, production-ready pipeline following the guide.

Produce:
1. **Architecture** — source, transform, sink, orchestration, and trigger mechanism
2. **Schema** — input and output schemas with types and nullability
3. **Transform logic** — step-by-step data transformations with edge case handling
4. **Error handling** — dead-letter strategy, retry policy, and alerting
5. **Observability** — metrics, logging, and lineage tracking
6. **Idempotency** — how re-runs are made safe

Choose the orchestration tool based on: (1) batch vs. stream, (2) scheduling requirements, (3) team expertise. State the reasoning.

## Quality bar

- Every pipeline must be idempotent: re-running the same job must not produce duplicate or incorrect output — batch jobs use checkpoint + resume; streaming jobs track consumer offsets or use per-message deduplication keys
- Define the error boundary: what happens when a record fails — skip, retry, DLQ, or halt?
- Schema changes must be handled explicitly — unknown fields must be routed to DLQ or raise a schema-mismatch error; never silently dropped
- Observability is not optional: row count, error count, and latency must be measurable
- Batch jobs must checkpoint progress; streaming jobs must track consumer offsets

## Additional resources

- **`references/data-pipeline-guide.md`** — Pattern selection (batch vs stream vs micro-batch), orchestration options, idempotency strategies, schema evolution, error taxonomy, and observability checklist.

# Data Pipeline Guide

## Pattern selection

| Pattern | Latency | Use when |
|---------|---------|----------|
| **Batch** | Minutes–hours | Full dataset reprocessing, nightly aggregations, ML training data |
| **Micro-batch** | Seconds–minutes | Near-real-time dashboards, frequent aggregations without per-event latency requirements |
| **Streaming** | Milliseconds–seconds | Fraud detection, real-time personalization, event-driven triggers |
| **Lambda** (batch + stream) | Both | When historical backfill and real-time processing are both required |

Default to **batch** unless the business requires sub-minute freshness. Streaming is significantly harder to operate.

---

## Orchestration options

| Tool | Best for |
|------|---------|
| **Airflow** | Complex DAG dependencies, wide ecosystem |
| **Dagster** | Software-defined assets, lineage-first, type-safe |
| **Prefect** | Simple Python-first workflows, dynamic tasks |
| **dbt** | SQL-only transformation layer on a data warehouse |
| **Temporal** | Long-running workflows with exactly-once guarantees |
| **Cron + script** | Simple, single-step jobs with no dependency graph |

---

## Idempotency strategies

Every pipeline must be safe to re-run. Choose one strategy:

### Overwrite by partition

Delete and re-insert data for the target partition before writing:

```sql
-- Delete partition, then insert
DELETE FROM events WHERE date = '2026-03-22';
INSERT INTO events SELECT * FROM staging_events WHERE date = '2026-03-22';
```

Use with date-partitioned tables. Safe for full backfill.

### Upsert / merge

```sql
INSERT INTO users (id, name, updated_at)
VALUES (...)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  updated_at = EXCLUDED.updated_at;
```

Use when records are keyed and may be updated.

### Write-once + deduplication

Append all events with a unique `event_id`. Deduplicate at read time or in a downstream step.

```sql
SELECT DISTINCT ON (event_id) * FROM raw_events ORDER BY event_id, ingested_at DESC;
```

Use with event streams where the source may re-deliver.

---

## Schema evolution

| Change type | Safe? | Strategy |
|-------------|-------|---------|
| Add nullable column | Yes | Default to NULL; consumers ignore unknown fields |
| Add required column | No | Add as nullable first; backfill; then add NOT NULL constraint |
| Rename column | No | Add new column; dual-write; migrate consumers; drop old |
| Change type (widening) | Usually | INT→BIGINT, VARCHAR(50)→VARCHAR(255) are usually safe |
| Change type (narrowing) | No | Treat as rename: new column + migration |
| Remove column | No | Deprecate; audit all consumers; remove after all are migrated |

Never remove or rename without auditing downstream consumers first.

---

## Error taxonomy and handling

| Error type | Example | Strategy |
|-----------|---------|---------|
| **Transient** | Network timeout, rate limit | Retry with exponential backoff (max 3–5 retries) |
| **Data quality** | Null in required field, type mismatch | Route to DLQ; alert; do not halt pipeline |
| **Schema mismatch** | Unknown field, version incompatibility | Route to DLQ; alert on-call; investigate |
| **Infrastructure** | DB unreachable, out of disk | Halt pipeline; page on-call |
| **Business logic** | Duplicate order ID, negative quantity | Route to DLQ with structured error; flag for human review |

### Dead-letter queue pattern

```
Source → Transform → [Error?] → DLQ (with: record, error reason, timestamp, job run ID)
                   ↓ [OK]
                  Sink
```

DLQ records must be replayable after the root cause is fixed.

---

## Retry policy

```
Attempt 1: immediate
Attempt 2: +2s
Attempt 3: +4s
Attempt 4: +8s (max delay)
Attempt 5: → DLQ
```

Apply retries at the **record level** for data quality errors. Apply retries at the **job level** for infrastructure errors.

---

## Observability checklist

Every pipeline must emit:

- [ ] **Row count**: records read, records written, records failed
- [ ] **Latency**: total job duration; p99 per-record processing time for streaming
- [ ] **Error count**: by error type
- [ ] **Lag**: consumer offset lag (streaming) or schedule delay (batch)
- [ ] **Data freshness**: age of the most recent record in the sink
- [ ] **Job status**: success, failure, partial (rows in DLQ)

### Structured log format

```json
{
  "level": "info",
  "event": "pipeline.batch.complete",
  "job_id": "etl-orders-2026-03-22",
  "rows_read": 142300,
  "rows_written": 142298,
  "rows_failed": 2,
  "duration_ms": 4821,
  "partition": "2026-03-22"
}
```

---

## Pipeline architecture template

```
┌──────────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│  Source  │───▶│  Extract     │───▶│  Transform    │───▶│   Sink   │
│          │    │  (validate   │    │  (clean,      │    │          │
│ DB / API │    │   schema)    │    │   enrich,     │    │ DW / S3  │
│ / stream │    └──────────────┘    │   aggregate)  │    │ / Kafka  │
└──────────┘           │            └───────┬───────┘    └──────────┘
                       │                    │
                       ▼                    ▼
                  ┌─────────┐         ┌─────────┐
                  │   DLQ   │         │   DLQ   │
                  │(schema  │         │ (logic  │
                  │ errors) │         │ errors) │
                  └─────────┘         └─────────┘
```

---

## Backfill strategy

When re-processing historical data:

1. **Partition-based**: re-run each date partition independently; parallelise safely
2. **Checkpoint-based**: record the last successfully processed ID or offset; resume from checkpoint
3. **Dual-write**: run new pipeline in parallel alongside old; compare outputs before cutover
4. **Blue/green table**: write to a new table; swap the view/alias after validation

Always test a single partition backfill before running the full history.

---

## Common anti-patterns

| Anti-pattern | Problem | Fix |
|-------------|---------|-----|
| `SELECT *` from source | Schema changes break downstream silently | Enumerate columns explicitly |
| No checkpoint | Full re-read on failure | Persist last processed offset/ID |
| All-or-nothing transaction on huge batches | One bad record fails everything | Process in micro-batches; DLQ individual failures |
| Hard-coded dates in queries | Job breaks the next day | Use parameterised `execution_date` from orchestrator |
| No DLQ | Failed records disappear | Always route failures to a named, monitored queue |
| Transforming in the source database | Locks tables, impacts production | Extract first; transform in a staging/compute layer |
| Unbounded streaming aggregation | Memory growth, incorrect results | Use windowed aggregations with explicit watermarks |

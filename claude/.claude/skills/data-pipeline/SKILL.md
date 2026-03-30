---
name: data-pipeline
description: This skill should be used when the user asks to "design a data pipeline", "build an ETL", "ingest this data", "transform this dataset", "schedule this data job", "stream processing", "batch processing", "data flow design", or "pipeline orchestration". Designs robust, observable, and maintainable data pipelines.
argument-hint: "[the pipeline to design: source, transform, destination, and trigger]"
---

# Data Pipeline Design

Pipeline: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Orchestration tools: !`find . -maxdepth 4 -name "*.py" -o -name "*.yaml" -o -name "*.yml" | xargs grep -l -iE "(airflow|dagster|prefect|luigi|dbt|spark|flink|kafka|kinesis|pubsub)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -8 || true`
- Existing pipelines: !`find . -maxdepth 4 -type f -name "*.dag*" -o -name "*pipeline*" -o -name "*etl*" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the pipeline description carefully. Design a complete, production-ready pipeline following `references/data-pipeline-guide.md`.

Produce:
1. **Architecture** — source, transform, sink, orchestration, and trigger mechanism
2. **Schema** — input and output schemas with types and nullability
3. **Transform logic** — step-by-step data transformations with edge case handling
4. **Error handling** — dead-letter strategy, retry policy, and alerting
5. **Observability** — metrics, logging, and lineage tracking
6. **Idempotency** — how re-runs are made safe

## Quality bar

- Every pipeline must be idempotent: re-running the same job must not produce duplicate or incorrect output
- Define the error boundary: what happens when a record fails — skip, retry, DLQ, or halt?
- Schema changes must be handled explicitly — never silently drop unknown fields
- Observability is not optional: row count, error count, and latency must be measurable
- Batch jobs must checkpoint progress; streaming jobs must track consumer offsets

## Additional resources

- **`references/data-pipeline-guide.md`** — Pattern selection (batch vs stream vs micro-batch), orchestration options, idempotency strategies, schema evolution, error taxonomy, and observability checklist.

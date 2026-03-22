---
name: "data-pipeline"
description: "Design data pipelines for batch, micro-batch, or streaming workloads. Use when the user asks for ETL, ELT, ingestion, orchestration, or pipeline design."
---

# Data Pipeline Design

Use this skill to design a production-ready pipeline with explicit data flow, retries, observability, and idempotency.

## Workflow

1. Read the source, transform, and sink requirements before choosing a pattern.
2. Prefer batch unless freshness requirements justify micro-batch or streaming.
3. Define schemas, failure handling, replay strategy, and monitoring.
4. Make reruns safe and explain how schema changes will be handled.

## Quality rules

- Every pipeline must be idempotent.
- Define what happens to bad records, transient failures, and infrastructure failures.
- Include row counts, lag, error counts, and freshness in observability.
- Do not silently drop unknown fields or untracked schema changes.

## Resource map

- `references/data-pipeline-guide.md` -> pattern selection, orchestration options, idempotency, schema evolution, error handling, and observability

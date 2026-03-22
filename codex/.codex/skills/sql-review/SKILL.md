---
name: "sql-review"
description: "Review SQL or ORM-generated queries for correctness, performance, safety, and maintainability. Use when the user asks to review SQL, optimise a query, or check for injection and index issues."
---

# SQL Review

Use this skill to review SQL with a focus on correctness, scale, and safety.

## Workflow

1. Read the query and any schema context before commenting.
2. Check correctness, performance, N+1 patterns, safety, and readability.
3. Provide a corrected query and any missing index statements.
4. Explain how the fix changes behaviour at scale.

## Quality rules

- Flag unbounded queries and unsafe interpolation.
- Call out missing indexes and expensive join patterns.
- Explain the scale at which the issue matters.
- Keep fixes concrete, not just descriptive.

## Resource map

- `references/sql-review-checklist.md` -> correctness patterns, performance anti-patterns, N+1 detection, safety, and explain-plan guidance

---
name: sql-review
description: This skill should be used when the user asks to "review this query", "optimise this SQL", "why is this query slow", "SQL review", "check this query for performance", "is this query safe", or "analyse this SQL". Reviews SQL for correctness, performance problems, missing indexes, N+1 patterns, and injection risks.
disable-model-invocation: true
argument-hint: "[the SQL query or ORM code to review, or a file path]"
---

# SQL Review

Query: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Schema / table definitions: !`find . -maxdepth 6 -type f \( -name "*.sql" -o -name "schema.rb" -o -name "schema.prisma" \) | grep -vE "(node_modules|vendor)" | head -5 2>/dev/null || true`
- Database engine: !`cat .env .env.local docker-compose.yml 2>/dev/null | grep -iE "(postgres|mysql|sqlite|database_url)" | head -5 || true`
- Existing indexes: !`find . -maxdepth 6 -name "*.sql" | xargs grep -i "create index" 2>/dev/null | head -20 || true`

## Task

Read the query and any available schema context carefully. Review for all of the following, then apply fixes directly.

Follow the review checklist in `references/sql-review-checklist.md`:

1. **Correctness** — does the query return what it intends to?
2. **Performance** — will this query be fast at scale? (explain plan, indexes, full table scans)
3. **N+1 patterns** — is this query inside a loop? Does it need to be batched?
4. **Safety** — is user input handled safely? (injection, unbounded results)
5. **Maintainability** — is the query readable and correctly aliased?

For each issue found: identify it, explain why it is a problem at scale, and provide the corrected query.

## Quality bar

- Do not just flag issues — provide the fixed query
- Performance issues must explain *at what scale* they become a problem
- If an index is missing, write the `CREATE INDEX` statement
- If the query is inside a loop (N+1), show how to rewrite it as a single query or batched fetch
- Flag if a query lacks a `LIMIT` and could return unbounded rows

## Additional resources

- **`references/sql-review-checklist.md`** — Correctness patterns, performance anti-patterns, index analysis, N+1 detection, injection prevention, and explain plan interpretation.

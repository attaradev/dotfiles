## Task

Read the query and any available schema context carefully. Review for all of the following, then apply fixes directly.

Follow the review checklist in `references/sql-review-checklist.md`:

1. **Correctness** — does the query return what it intends to?
2. **Performance** — will this query be fast at scale? (explain plan, indexes, full table scans)
3. **N+1 patterns** — is this query inside a loop? Does it need to be batched?
4. **Safety** — is user input handled safely? (injection, unbounded results)
5. **Maintainability** — does every table alias resolve unambiguously? Are column references qualified when the query joins 2+ tables? Are CTEs used instead of repeated subqueries?

For each issue found: (1) state the problem, (2) provide the corrected query in a code block, (3) explain why the original is problematic at scale.

## Quality bar

- Do not just flag issues — provide the fixed query
- Performance issues must explain *at what scale* they become a problem
- If an index is missing, write the `CREATE INDEX` statement
- If the query is inside a loop (N+1), show how to rewrite it as a single query or batched fetch
- Flag if a query lacks a `LIMIT` and could return unbounded rows

## Anti-patterns

Avoid these in your review output:

- **Flagging without fixing** — every issue must include the corrected SQL, not just a description
- **Vague severity** — do not mark everything High; use High only for correctness bugs or injection risks, Medium for performance issues at scale, Low for style/maintainability
- **"Consider adding an index"** — write the exact `CREATE INDEX CONCURRENTLY` statement or don't mention it
- **Scale-free performance claims** — "this is slow" is not actionable; state the table size or row count at which the problem manifests (e.g., "at 1M+ rows, a Seq Scan here will take >10s")
- **Ignoring NULL semantics** — if fixing a WHERE clause, verify the fix handles NULL rows correctly and say so

## Additional resources

- **`references/sql-review-checklist.md`** — Correctness patterns, performance anti-patterns, index analysis, N+1 detection, injection prevention, and explain plan interpretation.

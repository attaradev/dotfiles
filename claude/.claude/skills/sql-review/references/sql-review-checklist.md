# SQL Review Checklist

## 1. Correctness

**JOIN type**
- `INNER JOIN` excludes rows with no match — is that intended?
- `LEFT JOIN` includes all left rows — right-side columns can be NULL; handle them
- Mixing `INNER` and `LEFT JOIN` across multiple tables often produces unexpected result sets

**NULL handling**
- `WHERE col != 'value'` does not match NULL rows — add `OR col IS NULL` if needed
- `COUNT(col)` skips NULLs; `COUNT(*)` counts all rows
- Use `COALESCE(col, default)` in SELECT to handle NULLs explicitly

**GROUP BY**
- Every non-aggregate SELECT column must appear in GROUP BY
- `HAVING` filters aggregated results; `WHERE` filters before aggregation
- `SELECT DISTINCT` on a JOIN result often signals a broken join — diagnose why duplicates exist

---

## 2. Performance anti-patterns

**Full table scan signals**
- No `WHERE` clause on a large table
- `WHERE` on an unindexed column
- Function applied to an indexed column defeats index use:
  - Bad: `WHERE DATE(created_at) = '2024-01-01'`
  - Good: `WHERE created_at >= '2024-01-01' AND created_at < '2024-01-02'`
- `WHERE col::text = '...'` — casting prevents index use
- `LIKE '%value%'` — leading wildcard prevents B-tree index use

**Missing index signals**
- `ORDER BY col` on a large table without an index on `col`
- `JOIN ON t1.col = t2.col` where `t2.col` has no index
- Filtering on a FK column with no index (Postgres does not auto-index FKs)

**Expensive operations**
- `SELECT *` — fetches all columns; prevents index-only scans
- `COUNT(*)` without a filter on a large table — full scan
- Correlated subqueries — execute once per outer row; rewrite as JOIN or CTE
- `OFFSET N LIMIT M` for large N — scans and discards N rows; use cursor pagination:
  - Bad: `OFFSET 10000 LIMIT 20`
  - Good: `WHERE id > :last_seen_id ORDER BY id LIMIT 20`

---

## 3. N+1 detection

An N+1 executes one query per row of an outer result set.

Signs in application code:
- A query inside a loop
- ORM lazy-loading in a loop (`order.user.name` for each order)
- Any pattern where the number of DB calls scales linearly with result count

Fix — batch fetch:
```sql
-- Instead of: SELECT * FROM users WHERE id = ? (called N times)
SELECT * FROM users WHERE id = ANY(:user_ids)
```

ORM fix: use eager loading — `includes`, `select_related`, `preload`, `with` depending on the ORM.

---

## 4. Safety

**SQL injection**

Concatenating user input into SQL is always wrong:
```python
# Vulnerable
f"SELECT * FROM users WHERE email = '{user_input}'"

# Safe
cursor.execute("SELECT * FROM users WHERE email = %s", (user_input,))
```

Use parameterised queries — even if the input is validated today.

**Unbounded results**

Any query without a `LIMIT` that could return many rows:
- APIs: enforce a maximum page size
- Background jobs: process in batches to avoid OOM and long transactions

**Long-running transactions**

Queries inside transactions hold locks. Batch mutations to avoid contention:
```sql
DELETE FROM events WHERE id IN (SELECT id FROM events WHERE ... LIMIT 1000)
```

Never hold a transaction open across a network call.

---

## 5. Explain plan interpretation (PostgreSQL)

Run: `EXPLAIN (ANALYZE, BUFFERS) <query>`

| Node | Concern | Fix |
|------|---------|-----|
| `Seq Scan` on large table | Full table scan | Add index on filter column |
| `Sort` with high row count | Filesort | Add index on sort column |
| `Nested Loop` with many rows | Quadratic cost | Check indexes on join columns |
| `Index Only Scan` | Best case — no heap fetch needed | — |

High estimated rows vs actual rows → stale statistics → run `ANALYZE table_name`.

---

## Review output format

For each issue found:

**[Severity: High / Medium / Low] — Issue name**
Why it matters at scale: [one sentence]

Original:
```sql
-- problematic query
```

Fixed:
```sql
-- corrected query
```

Index needed (if applicable):
```sql
CREATE INDEX CONCURRENTLY idx_table_col ON table(col);
```

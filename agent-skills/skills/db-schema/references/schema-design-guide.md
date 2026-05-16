# Database Schema Design Guide

## Naming conventions

| Object | Convention | Example |
|--------|-----------|---------|
| Tables | `snake_case`, plural nouns | `user_accounts`, `order_line_items` |
| Columns | `snake_case` | `created_at`, `user_id`, `is_active` |
| Primary keys | `id` (surrogate) | `id BIGSERIAL PRIMARY KEY` |
| Foreign keys | `<table_singular>_id` | `user_id`, `order_id` |
| Indexes | `idx_<table>_<columns>` | `idx_orders_user_id_status` |
| Unique constraints | `uq_<table>_<columns>` | `uq_users_email` |
| Booleans | `is_` or `has_` prefix | `is_active`, `has_verified_email` |
| Timestamps | `_at` suffix, UTC | `created_at`, `updated_at`, `deleted_at` |

---

## Primary key strategy

| Strategy | When to use | Trade-off |
|----------|------------|-----------|
| `BIGSERIAL` / auto-increment | Default for internal tables | Sequential — predictable, index-friendly; exposes row count |
| `UUID v4` | Cross-service IDs, public-facing IDs, distributed generation | Random — avoids enumeration; larger index; worse cache locality |
| `UUID v7` | Default for new systems (time-ordered UUID) | Sequential like bigint + globally unique; best of both |
| Natural key | Codes that are meaningful and stable (ISO country code, IATA code) | Only safe if the natural key truly never changes |

**Default recommendation:** Use `BIGSERIAL` for internal join tables; `UUID v7` (or `UUID v4`) for any ID that crosses a service boundary or is exposed in an API.

---

## Normalization guide

### When to normalise (3NF)

Use 3NF when:
- Data is written frequently and consistency is critical
- The same value appears in multiple rows (e.g., country name stored with every address)
- You need to enforce referential integrity

### When to denormalise

Denormalise deliberately when:
- Read performance is critical and joins are too slow at scale
- The data is append-only or rarely changes (analytics, event logs)
- The relationship is genuinely one-to-one and the data is always read together

Document every denormalisation decision — future maintainers must know it was a choice.

### JSONB vs relational columns

| Use JSONB when | Use relational columns when |
|---------------|---------------------------|
| Schema is genuinely variable (user-defined attributes, plugin configs) | Schema is known and stable |
| You never need to query individual fields in WHERE or GROUP BY | You need to filter, sort, or index individual fields |
| The data is opaque to the application (pass-through storage) | The application logic depends on specific fields |

Never store JSONB just to avoid a schema migration. That debt compounds.

---

## Index strategy

### Always index

- Every foreign key column (Postgres does not auto-index FK columns)
- Columns used in frequent `WHERE` clauses
- Columns used in `ORDER BY` on large tables
- Columns used in `JOIN` conditions that are not already primary keys

### Index types

| Type | When |
|------|------|
| B-tree (default) | Equality, range, sort — works for almost everything |
| GIN | `JSONB` containment, full-text search, array overlap |
| GiST | Geometric types, range types, fuzzy text |
| BRIN | Very large append-only tables with natural sort order (timestamps, sequential IDs) |
| Partial | When only a subset of rows is ever queried: `WHERE deleted_at IS NULL` |

### Composite index column order

Place the most selective column first, unless the query always provides an equality condition on a specific column (put that one first).

Example: `idx_orders_user_id_status` for `WHERE user_id = ? AND status = 'pending'` — `user_id` first if it is more selective.

### Index anti-patterns

- Indexing every column "just in case" — writes slower, planner confused
- Duplicate indexes (an index on `(a, b)` covers `(a)` queries; a separate `(a)` index is redundant)
- Indexing low-cardinality columns alone (e.g., a boolean) — sequential scan is faster

---

## Schema DDL template

```sql
CREATE TABLE orders (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    status      TEXT NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    total_cents BIGINT NOT NULL CHECK (total_cents >= 0),
    currency    CHAR(3) NOT NULL DEFAULT 'USD',
    metadata    JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- FK index (not auto-created by Postgres)
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Query pattern: list pending orders sorted by creation time
CREATE INDEX idx_orders_status_created_at ON orders(status, created_at DESC)
    WHERE status NOT IN ('completed', 'cancelled');  -- partial index

-- Trigger to maintain updated_at
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION trigger_set_updated_at();
```

---

## Migration safety patterns

### Adding a column

Safe: adding a nullable column or a column with a default that Postgres can evaluate instantly.

Unsafe on large tables: adding a `NOT NULL` column without a default — Postgres rewrites the entire table.

Safe approach:
1. Add column as nullable
2. Backfill values in batches
3. Add `NOT NULL` constraint (fast once all rows have values)

### Dropping a column

1. Remove all application references to the column first
2. Mark as `deprecated` in schema comments
3. Drop only after confirming no queries reference it (check logs)

### Adding a unique constraint

1. Create a unique index `CONCURRENTLY` first (non-blocking)
2. Then add the constraint using the existing index: `ALTER TABLE ADD CONSTRAINT USING INDEX`

### Adding an index to a large table

Always use `CREATE INDEX CONCURRENTLY` — blocks writes otherwise.

### Renaming a column

Rename requires rewriting all query references first. Safer: add a new column, dual-write, backfill, remove old column. Never rename a column directly in production without a coordinated deploy.

---

## Soft delete pattern

If records must be deleted but preserved for audit:

```sql
deleted_at TIMESTAMPTZ  -- NULL = active; non-NULL = deleted
```

Add a partial index to exclude deleted rows from normal queries:

```sql
CREATE INDEX idx_orders_user_id ON orders(user_id) WHERE deleted_at IS NULL;
```

Ensure all application queries include `WHERE deleted_at IS NULL` — missing this is a common bug.

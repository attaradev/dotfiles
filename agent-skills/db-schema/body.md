## Task

Read the domain description and any existing schema carefully. Design the data model following the principles in `references/schema-design-guide.md`.

Produce:
1. **Entity model** — the entities, their attributes, and cardinality of relationships
2. **Schema definition** — SQL DDL or ORM schema in the format matching the existing codebase
3. **Normalization rationale** — why this normal form is appropriate for this use case
4. **Index strategy** — indexes for the expected query patterns, with justification
5. **Migration notes** — if this changes an existing schema, provide a migration script (up/down) for simple changes, or a detailed strategy for changes requiring downtime or backfill
6. **Open questions** — decisions that depend on product or access pattern clarification

For each design choice, state the trade-off. A JSONB column is not always wrong; a fully normalised schema is not always right.

## Quality bar

- Every table must have a primary key — state the trade-off: surrogate keys (simpler, auto-indexed) vs. natural keys (data-level uniqueness guarantee); justify the choice
- Foreign key constraints must be explicit — never rely on application-level enforcement alone
- Index every foreign key column unless you have a measured reason not to
- Avoid nullable columns where possible — a separate join table expresses optionality more cleanly
- If adding columns to an existing table with millions of rows, note the migration risk and safe strategy

## Additional resources

- **`references/schema-design-guide.md`** — Normalization, primary key strategy, index design, JSONB vs relational trade-offs, migration safety patterns, and naming conventions.

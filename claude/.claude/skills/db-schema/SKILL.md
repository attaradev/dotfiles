---
name: db-schema
description: This skill should be used when the user asks to "design the schema", "ERD for this", "data model design", "what tables do we need", "database schema for this feature", "design the data model", or "how should we structure this in the database". Produces a schema design with entity model, normalization rationale, index strategy, and migration notes.
argument-hint: "[the domain, feature, or entities to model]"
---

# Database Schema Design

Domain: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing schema / migrations: !`find . -maxdepth 6 -type f \( -name "*.sql" -o -name "schema.rb" -o -name "schema.prisma" -o -name "models.py" \) | grep -vE "(node_modules|vendor)" | head -10 2>/dev/null || true`
- Migration files: !`find . -maxdepth 6 -type f -name "*migration*" -o -name "*migrate*" | grep -vE "(node_modules|vendor)" | head -10 2>/dev/null || true`
- ORM models: !`find . -maxdepth 6 -type f | xargs grep -l -iE "^class.*Model|@Entity|schema\.define|table\s*:" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`

## Task

Read the domain description and any existing schema carefully. Design the data model following the principles in `references/schema-design-guide.md`.

Produce:
1. **Entity model** — the entities, their attributes, and cardinality of relationships
2. **Schema definition** — SQL DDL or ORM schema in the format matching the existing codebase
3. **Normalization rationale** — why this normal form is appropriate for this use case
4. **Index strategy** — indexes for the expected query patterns, with justification
5. **Migration notes** — if this changes an existing schema, how to migrate safely
6. **Open questions** — decisions that depend on product or access pattern clarification

For each design choice, state the trade-off. A JSONB column is not always wrong; a fully normalised schema is not always right.

## Quality bar

- Every table must have a primary key; prefer surrogate keys (UUID or serial) over natural keys unless there is a strong reason
- Foreign key constraints must be explicit — never rely on application-level enforcement alone
- Index every foreign key column unless you have a measured reason not to
- Avoid nullable columns where possible — a separate join table expresses optionality more cleanly
- If adding columns to an existing table with millions of rows, note the migration risk and safe strategy

## Additional resources

- **`references/schema-design-guide.md`** — Normalization, primary key strategy, index design, JSONB vs relational trade-offs, migration safety patterns, and naming conventions.

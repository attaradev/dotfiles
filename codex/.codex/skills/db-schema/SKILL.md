---
name: "db-schema"
description: "Design relational database schemas and migrations. Use when the user asks for a schema, ERD, data model, table layout, or migration notes."
---

# Database Schema Design

Use this skill to design a schema that matches the domain, query patterns, and migration constraints.

## Workflow

1. Read the existing schema and migration style before proposing new tables.
2. Define the entity model, key relationships, indexes, and constraints.
3. Choose normalization deliberately and explain any denormalization trade-offs.
4. Include safe migration notes for existing data and large tables.

## Quality rules

- Give every table a primary key and explicit foreign keys.
- Index foreign keys and common filter columns.
- Prefer nullable columns only when optionality is real.
- Call out migration risk for large or hot tables.

## Resource map

- `references/schema-design-guide.md` -> naming, normalization, primary keys, indexing, JSONB trade-offs, and migration safety

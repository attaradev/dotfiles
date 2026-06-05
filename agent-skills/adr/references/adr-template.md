# ADR Template

Based on Michael Nygard's original format, extended with Options and a Consequences split.

---

## File naming

```
docs/adr/ADR-0042-use-postgres-for-primary-storage.md
```

- Zero-padded sequential number
- Kebab-case title matching the ADR title
- Place in `docs/adr/`, `docs/decisions/`, or wherever existing ADRs live

---

## Template

```markdown
# ADR-NNNN: [Title — a noun phrase describing the decision, not the problem]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by [ADR-XXXX]
**Deciders:** [Names or roles of people involved in this decision]

---

## Context

[Describe the forces at play: technical constraints, business requirements, team capabilities,
timeline pressure, existing architecture. This section answers "why did we need to make a
decision at all?" Do not mention the decision itself here. 2–5 paragraphs.]

## Options considered

### Before state

[Describe the current architecture, process, or tool being replaced or extended. Explain specifically why the status quo is insufficient — what problem does it cause or block? This anchors all options against a concrete starting point.]

### Options

#### Option 1: [Name]

[One-paragraph description. What does this option change relative to the before state?]

#### Option 2: [Name]

[Same format]

#### Option N: [Name]

[Add as many options as were meaningfully evaluated. Do not list options that were not
actually considered — this is a record, not a brainstorm.]

### Comparison

| Decision driver | Option 1 | Option 2 | Option N |
|-----------------|----------|----------|----------|
| [Driver 1]      | ✅ note  | ⚠️ note | ❌ note  |
| [Driver 2]      | …        | …        | …        |
| [Driver N]      | …        | …        | …        |

Use ✅ (satisfies), ⚠️ (partial / with caveats), ❌ (does not satisfy). Add a brief inline note for any non-obvious rating.

## Decision

We will [chosen option].

[Explain why this option was chosen, citing specific drivers from the comparison table where it outperformed alternatives. Then explain why each rejected option fell short — one sentence per rejected option. Use decisive language: "We will" not "We should consider".]

## Consequences

### Positive
- [What improves as a result of this decision]
- [...]

### Negative
- [What gets worse, or what technical debt is incurred]
- [What constraints this decision places on future work]
- [...]

### Neutral / follow-up actions
- [Tasks that must happen as a result of this decision]
- [Future decisions that are now unblocked or constrained]
- [Migrations, deprecations, or compatibility windows needed]
```

---

## Section guidance

### Context
The most important section. A good Context makes the Decision and Consequences self-evident.

Ask: if someone reads this in two years with no prior knowledge, will they understand why this decision had to be made?

Include:
- The specific problem or requirement that triggered this decision
- Constraints that eliminated some options (cost, time, skills, existing architecture)
- What happens if no decision is made (status quo and its problems)

Do not include:
- The decision itself (save for the Decision section)
- Generic background that is not specific to this decision

### Decision
State what was decided, not what will be considered. Use decisive language:
- "We will use X" not "We should consider using X"
- "We chose X over Y because Z" not "X and Y are both valid options"

### Consequences
Be honest about the downsides. An ADR with no negative consequences is not credible and will not be trusted. The negatives do not need to outweigh the positives — they need to be acknowledged.

Good negative consequences:
- "This requires a migration of all existing session tokens (estimated 1 day of work)"
- "Future developers must understand concept X to work in this area"
- "This approach does not support feature Y — a separate decision will be needed if Y becomes required"

---

## Status lifecycle

| Status | Meaning |
|--------|---------|
| **Proposed** | Decision is under discussion, not yet committed |
| **Accepted** | Decision is committed and in effect |
| **Deprecated** | Decision is no longer recommended but not formally replaced |
| **Superseded** | Replaced by a newer ADR — link to it |

When superseding an ADR, update the old ADR's status to `Superseded by ADR-XXXX` and link back.

---

## Example (filled)

```markdown
# ADR-0007: Use Postgres as the primary data store

**Date:** 2026-02-14
**Status:** Accepted
**Deciders:** Platform team

---

## Context

The service currently uses DynamoDB for all persistence. As query complexity has grown,
we are writing increasingly complex filter expressions and performing multiple round-trips
to reconstruct relational data. Two features in the current roadmap (reporting and audit
log queries) require joins that DynamoDB cannot express efficiently.

The team has strong SQL expertise but limited DynamoDB expertise. Operational complexity
of DynamoDB (capacity planning, GSI maintenance) has caused two incidents in the past quarter.

## Options considered

### Before state

The service uses DynamoDB for all persistence. As query complexity has grown, we are writing
increasingly complex filter expressions and performing multiple round-trips to reconstruct
relational data. Two roadmap features require joins that DynamoDB cannot express efficiently.
Two operational incidents in the past quarter stemmed from DynamoDB capacity planning and GSI
maintenance — areas where the team has limited expertise.

### Options

#### Option 1: Postgres
Migrate to RDS Postgres as the single primary data store. The team is fluent in SQL. Managed
offering reduces operational overhead. Supports the join patterns needed for reporting.

#### Option 2: Continue with DynamoDB
No migration required; retain current schema and application patterns.

#### Option 3: Add a separate analytics database
Keep DynamoDB for operational data, add Postgres (or Redshift) for reporting queries only.

### Comparison

| Decision driver              | Option 1: Postgres | Option 2: DynamoDB | Option 3: Dual-store |
|------------------------------|--------------------|--------------------|----------------------|
| Supports reporting joins      | ✅                 | ❌ requires app-level joins | ✅ for analytics queries |
| Team can operate confidently  | ✅ strong SQL skills | ⚠️ limited DynamoDB expertise | ⚠️ requires DynamoDB + Postgres skills |
| Reduces operational incidents | ✅ eliminates capacity/GSI toil | ❌ same failure modes remain | ⚠️ adds dual-write complexity |
| Migration cost                | ⚠️ ~2 sprints      | ✅ none            | ⚠️ ongoing sync cost |
| Single source of truth        | ✅                 | ✅                 | ❌ dual-write consistency risk |

## Decision

We will migrate to Postgres as the single primary data store.

The comparison table makes this clear: Option 2 cannot satisfy the reporting join requirement
and perpetuates the operational incidents that are already costing the team time. Option 3
avoids migration cost but introduces dual-write complexity that exceeds the one-time migration
effort of Option 1 and creates a persistent data consistency risk. Postgres satisfies all
drivers except migration cost, which is bounded and one-time.

## Consequences

### Positive
- SQL query patterns unlock the reporting and audit features on the roadmap
- Reduced operational complexity vs. DynamoDB capacity planning
- ACID transactions simplify several write paths that currently use conditional expressions

### Negative
- Migration of existing data requires a compatibility window (estimated 2 sprints)
- Connection pool management (pgBouncer or RDS Proxy) needed before production traffic
- DynamoDB-specific patterns in the codebase must be replaced

### Neutral / follow-up actions
- ADR-0008 needed: connection pooling approach
- Schema design and migration plan to be created before implementation begins
- DynamoDB tables to be kept read-only for 30 days post-migration as rollback option
```

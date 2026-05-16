# Design Document Template

---

## Template

```markdown
# Design: [Feature or system name]

**Author:** [Name]
**Date:** YYYY-MM-DD
**Status:** Draft | In Review | Approved | Superseded
**Reviewers:** [Names or teams]
**Related:** [Links to issues, ADRs, prior designs]

---

## Problem

[What problem is being solved, and why it matters now. Include the impact of not solving it.
Do not mention the proposed solution here. 1–3 paragraphs.]

## Goals

- [Specific, measurable outcome this design achieves]
- [...]

## Non-goals

- [What this design explicitly does not address — prevents scope creep]
- [...]

---

## Background

[Context a reviewer needs to understand the design. System components involved, relevant
history, current limitations. Include a diagram if it helps. Keep it factual — this is
not the place to argue for the solution.]

### Current state

[How the system works today and where it falls short.]

### Constraints

[Technical or non-technical constraints that bound the solution space: performance
requirements, backward compatibility, existing dependencies, timeline, team skills.]

---

## Proposed design

[The solution. Describe the approach, components, and how they interact. Lead with the
high-level idea before diving into details. Use sub-sections as needed.]

### Architecture

[Diagram and/or description of the system components and their relationships.]

### Data model

[New or changed schemas, types, or storage structures. Include migration strategy if
changing existing data.]

### API / interface changes

[New or changed APIs — REST endpoints, gRPC methods, function signatures, events, or
configuration. Include request/response shapes for external APIs.]

### Key workflows

[Step-by-step description of the most important flows. Use sequence diagrams or numbered
steps. Cover the happy path first, then error cases.]

### Error handling

[How failures are detected, surfaced, and recovered from. What the caller sees. What
gets logged.]

---

## Alternatives considered

### Alternative 1: [Name]

[Description and trade-offs.]

**Rejected because:** [Specific reason]

### Alternative 2: [Name]

[Description and trade-offs.]

**Rejected because:** [Specific reason]

---

## Security and privacy

[Required for any design touching auth, user data, external services, or permissions.]

- **Authentication / authorization:** [How access is controlled]
- **Data sensitivity:** [What sensitive data is involved and how it is protected]
- **Input validation:** [How untrusted input is handled]
- **Audit logging:** [What actions are logged and where]
- **Attack surface:** [New vectors introduced and mitigations]

---

## Performance and scalability

- **Expected load:** [Request rates, data volumes, growth projections]
- **Bottlenecks:** [Where the system may become constrained]
- **Caching strategy:** [What is cached, TTL, invalidation]
- **Database impact:** [New queries, indexes needed, migration costs]

---

## Observability

- **Metrics:** [What to instrument and why]
- **Logging:** [Key events to log, log levels, structured fields]
- **Alerting:** [Conditions that should page someone]
- **Dashboards:** [What to visualize]

---

## Rollout plan

- **Feature flag:** [Yes / No — flag name and rollout strategy]
- **Migration:** [Data migrations required and their reversibility]
- **Rollback:** [How to revert if the rollout fails]
- **Phasing:** [If rolling out incrementally, describe the phases]

---

## Open questions

| Question | Owner | Needed by |
|----------|-------|-----------|
| [Specific question that blocks or materially changes the design] | @name | YYYY-MM-DD |

---

## Appendix

[Supporting material: detailed schemas, lengthy examples, benchmark results, links.]
```

---

## Section guidance

### Problem vs. Goals

The Problem explains *why* something needs to change. Goals state *what success looks like*. These are different things. A design with clear goals and a vague problem statement usually means the author started with the solution.

Good problem statement: "The current coupon system validates expiry at the API handler layer. When checkout is initiated through the mobile SDK, this validation is bypassed, allowing expired coupons to be applied. This was reported by three customers in Q4."

Good goal: "Coupons with an expiry date in the past are rejected regardless of which code path initiates checkout."

### Non-goals

Non-goals are as important as goals. They tell reviewers and future contributors what was intentionally excluded so the design isn't judged against requirements it wasn't trying to meet.

"Support for multi-currency coupons is out of scope for this design — tracked in #789."

### Alternatives considered

Alternatives must be real alternatives that were meaningfully evaluated, not obviously bad ideas included to make the chosen solution look good. If only one approach was considered, say so honestly — "we did not evaluate alternatives because X" is fine.

### Open questions

Only include questions that are actually open — unresolved decisions that a reviewer or stakeholder needs to help answer. Questions you already know the answer to should not be in this section.

Bad: "How should we handle errors?" (You should know this before writing the design.)
Good: "Should coupon validation be synchronous or move to an async job queue? Async gives better p99 at checkout but requires compensating logic for the window between order creation and validation."

---

## When to write a design doc vs. an ADR

| Situation | Use |
|-----------|-----|
| One architectural decision | ADR |
| New feature touching multiple components | Design doc |
| System-level change with API surface | Design doc |
| Choosing between two libraries | ADR |
| Full technical spec for a quarter's work | Design doc |

Design docs are broader and cover the *how*. ADRs are narrower and cover the *why a specific decision was made*. A design doc may reference or generate several ADRs.

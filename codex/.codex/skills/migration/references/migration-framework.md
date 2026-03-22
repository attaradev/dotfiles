# System Migration Framework

## Migration strategy selection

| Strategy | Description | Best for | Risk |
|----------|------------|---------|------|
| **Big bang** | Cut over all at once in a maintenance window | Small systems, simple data models, short cutover | High — no fallback path after cutover starts |
| **Phased / incremental** | Migrate in segments (by feature, user cohort, or data subset) | Large systems, multiple teams | Medium — complexity of managing dual systems |
| **Strangler fig** | New system intercepts traffic; old system handles what new cannot | Legacy monolith replacement, no downtime requirement | Low — old system stays live throughout |
| **Parallel run** | Both systems run simultaneously; results compared | High-confidence requirement (financial, safety-critical) | Low — most expensive to operate |

**Default recommendation:** Prefer strangler fig or phased over big bang for anything that takes more than a few hours to execute. Big bang migrations have a poor track record for systems with complex data models.

---

## Document template

---

**Migration Plan: [From X to Y]**
**Author:** [Name] | **Date:** YYYY-MM-DD
**Target completion:** YYYY-MM-DD | **Maintenance window required:** Yes / No

---

### Problem statement

Why is this migration necessary? What is the cost of NOT migrating?

### Current state

[What exists today: architecture, data model, integrations, known limitations, estimated data volume]

### Target state

[What success looks like: new architecture, benefits delivered, what the old system no longer does]

### Migration strategy

[Which strategy was chosen and why — include the alternatives considered and why they were rejected]

---

### Phases

#### Phase 0: Preparation (before any migration work)

- [ ] Migration runbook written and reviewed
- [ ] Rollback plan written and tested in staging
- [ ] Monitoring and alerting for migration progress in place
- [ ] Stakeholders informed of timeline and impact
- [ ] Data validation tooling built

**Exit criteria:** All preparation items checked; dry-run completed successfully in staging.

#### Phase 1: [Name] — [Brief description]

**Goal:** [What this phase achieves]
**Duration:** [Estimated]

Steps:
1. [Step with owner]
2. [Step with owner]

**Exit criteria:** [Specific, measurable condition — e.g., "New system processing 100% of read traffic; error rate < 0.05% for 48 hours"]

**Rollback:** [How to reverse this phase — must be specific, not "revert the changes"]

#### Phase 2: [Name]

...

#### Phase N: Decommission (final)

**Goal:** Remove the old system entirely.

**Do not execute until:**
- New system has been stable for at least [30 days]
- All integrations confirmed migrated
- Old system traffic at zero for at least [7 days]
- Data backup of old system taken and verified

---

### Data migration

**Volume:** [Estimated rows / bytes]
**Migration method:** [Bulk export + import / Change Data Capture / dual-write / backfill job]

**Consistency approach:**
- **Synchronous dual-write:** New writes go to both systems; highest consistency, higher latency
- **CDC / replication:** Changes replicated async; eventual consistency; monitor lag
- **Backfill:** Historical data migrated in batch; acceptable for append-only data

**Validation:**
- Row counts must match within [tolerance] after migration
- Checksums / hashes computed on [key fields] before and after
- Sample-based spot-check: [N]% of records verified for correctness
- Business-logic validation: [Key invariants that must hold in the new system]

**Cutover lag:** Maximum acceptable data lag during cutover: [N seconds / N minutes / zero]

---

### Cutover plan (go-live day)

Document this as a numbered runbook — each step has an owner, a command or action, and a verification check.

| Step | Action | Owner | Verification |
|------|--------|-------|-------------|
| 1 | Enable maintenance mode / feature flag | [Name] | [Check URL / metric] |
| 2 | Final data sync; verify lag = 0 | [Name] | [Command to run] |
| 3 | Update DNS / load balancer / feature flag to route to new system | [Name] | [Health check URL] |
| 4 | Smoke test critical paths | [Name] | [Test script / checklist] |
| 5 | Monitor error rate and latency for 30 minutes | [Name] | [Dashboard URL] |
| 6 | Declare cutover complete; notify stakeholders | [Name] | — |

**Decision point:** At step 5, if error rate > [threshold] or latency > [threshold], execute rollback immediately.

---

### Rollback plan

Rollback must be rehearsed before the cutover, not designed during an incident.

| Phase | Rollback action | Time to execute | Owner |
|-------|----------------|----------------|-------|
| During cutover | [Specific steps to reverse the cutover] | < [N minutes] | [Name] |
| Phase 1 complete | [Steps to revert phase 1 changes] | [N hours] | [Name] |
| Phase 2 complete | [Steps — may require data backfill] | [N hours/days] | [Name] |

**Rollback go/no-go criteria:** Automatically roll back if any of:
- Error rate > [X]% for more than [N minutes]
- P99 latency > [Y ms] for more than [N minutes]
- Data validation failure detected

---

### Risk register

| Risk | Likelihood | Impact | Mitigation | Owner |
|------|-----------|--------|-----------|-------|
| Data loss during migration | M | High | Dual-write + backfill verification before cutover | [Name] |
| Extended downtime | L | High | Strangler fig avoids downtime; maintenance window if needed | [Name] |
| Third-party integration failure | M | Medium | Test all integrations in staging before cutover | [Name] |
| Rollback takes too long | L | High | Rehearse rollback in staging; set time limits | [Name] |
| Performance regression in new system | M | Medium | Load test at 2× expected peak before cutover | [Name] |
| Partial cutover leaves data inconsistent | M | High | Transactional cutover; no partial states | [Name] |

---

### Success criteria

The migration is complete when:
- [ ] 100% of traffic routed to new system for [N days]
- [ ] Error rate equivalent to or better than baseline
- [ ] Data validation: all records present and correct
- [ ] All integrations confirmed working
- [ ] Old system decommissioned
- [ ] Documentation updated to reflect new architecture

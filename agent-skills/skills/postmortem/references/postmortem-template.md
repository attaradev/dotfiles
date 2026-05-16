# Postmortem Template

## Blameless culture principles

A blameless postmortem assumes that people acted rationally given the information and tools they had at the time. The goal is to understand how the system made an unsafe action possible — not to identify who made a mistake.

If your postmortem ends with "we need to be more careful," it has not found the root cause.

---

## Document template

---

**Postmortem: [Incident Name]**
**Date:** YYYY-MM-DD | **Author:** [Name] | **Reviewers:** [Names]
**Severity:** P0 / P1 / P2 | **Status:** Draft | In Review | Final

---

### Incident summary

| Field | Value |
|-------|-------|
| Date | YYYY-MM-DD |
| Duration | [N hours N minutes] |
| Detection time | [How long from start to first alert] |
| Resolution time | [How long from detection to resolution] |
| Impact | [Who was affected and how: "100% of users could not complete checkout for 47 minutes"] |
| Services affected | [List] |

One paragraph: What happened, what was the impact, and how was it resolved?

---

### Timeline

All times in UTC. Be precise — "around 14:30" is not a timeline entry.

| Time (UTC) | Event |
|------------|-------|
| 14:02 | Deployment of v2.4.1 completed to production |
| 14:07 | Error rate alert fires: `checkout.errors > 1%` |
| 14:09 | On-call engineer acknowledges alert |
| 14:12 | Engineer identifies spike in `payment_service` 503 errors |
| 14:18 | Root cause identified: database connection pool exhausted |
| 14:23 | Feature flag disabled; traffic rerouted to previous version |
| 14:31 | Error rate returns to baseline |
| 14:49 | Full rollback confirmed complete; all systems nominal |

---

### Root cause (5-whys)

Apply the 5-whys technique. Keep asking "why" until you reach a systemic cause.

**Why** did users experience checkout failures?
→ The payment service returned 503 errors.

**Why** did the payment service return 503 errors?
→ The database connection pool was exhausted.

**Why** was the connection pool exhausted?
→ The new query introduced in v2.4.1 held connections open for up to 30 seconds.

**Why** did the query hold connections open for 30 seconds?
→ It lacked a query timeout; the ORM default is no timeout.

**Why** was there no query timeout?
→ Our ORM configuration template does not include a default query timeout, and the code review checklist does not include a timeout check.

**Root cause:** The ORM configuration template does not enforce a query timeout, and the review process has no mechanism to catch this class of resource leak before production.

---

### Contributing factors

Conditions that made the incident possible, worse, or harder to detect. These are systemic — not personal.

| Factor | Category | Description |
|--------|---------|-------------|
| No query timeout in ORM defaults | Prevention | Any query can hold a connection indefinitely |
| Connection pool size set to default | Prevention | Default pool (5 connections) is too small for production load |
| Alert threshold too high (1% error rate) | Detection | Incident was already impacting users significantly before alerting |
| No canary deployment | Prevention | 100% of traffic hit the broken version immediately |
| Runbook did not cover DB pool exhaustion | Response | Engineer had to diagnose from scratch instead of following a known procedure |

Factor categories:
- **Prevention** — would have stopped the incident from occurring
- **Detection** — would have caught it sooner
- **Response** — would have reduced the time to resolution

---

### What went well

- On-call engineer acknowledged the alert within 2 minutes
- The deployment pipeline retains the previous artifact, enabling a fast rollback
- The feature flag system allowed partial rollback without a full redeploy
- Communication to the team was clear and timely

---

### What went wrong

- The query timeout omission was not caught in code review
- The monitoring threshold was too coarse to detect the issue during the 5-minute ramp-up window
- The connection pool size had not been reviewed since traffic doubled six months ago
- No runbook existed for database connection pool exhaustion

---

### Action items

Every action item must be: specific, owned, and time-bounded. "Improve monitoring" is not an action item.

| ID | Action | Owner | Type | Due |
|----|--------|-------|------|-----|
| PM-1 | Add default query timeout (30s) to ORM configuration template | [Engineer] | Prevention | YYYY-MM-DD |
| PM-2 | Add connection pool sizing to monthly infrastructure review checklist | [SRE] | Prevention | YYYY-MM-DD |
| PM-3 | Lower checkout error rate alert threshold from 1% to 0.1% | [SRE] | Detection | YYYY-MM-DD |
| PM-4 | Add DB connection pool exhaustion scenario to runbook | [Engineer] | Response | YYYY-MM-DD |
| PM-5 | Implement canary deployment for payment service (10% traffic before 100%) | [Platform] | Prevention | YYYY-MM-DD |
| PM-6 | Add query timeout check to PR review template | [EM] | Prevention | YYYY-MM-DD |

Action types:
- **Prevention** — stops the incident from happening again
- **Detection** — catches it sooner next time
- **Response** — reduces time to resolution next time
- **Mitigation** — reduces the blast radius

---

### Metrics

| Metric | Value |
|--------|-------|
| Time to detect | [N minutes] |
| Time to acknowledge | [N minutes] |
| Time to mitigate | [N minutes] |
| Time to resolve | [N minutes] |
| Users affected | [N] |
| Error budget consumed | [N minutes of [SLO window]] |

---

## 5-whys guide

Rules for a valid 5-whys chain:
1. Each "why" must be answered by something the team could have controlled
2. "Human error" is never a terminal answer — ask why the human was in a position to make that error
3. The chain ends when you reach something systemic: a missing process, a missing tool, an assumption that was never validated
4. A good root cause points to a concrete action item that prevents recurrence

**Bad root cause:** "The engineer forgot to add a timeout."
**Why bad:** It blames the person. It suggests the action item is "be more careful."

**Good root cause:** "The ORM template does not include a default timeout, and the review process has no check for this class of resource leak."
**Why good:** It points to two concrete fixes: update the template, add the check.

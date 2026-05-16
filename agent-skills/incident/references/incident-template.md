# Incident Report Template

Blameless postmortem format. Focus on systemic causes, not individuals.

---

## Template

```markdown
# Incident Report: [Short title — what failed]

**Date:** YYYY-MM-DD
**Severity:** SEV1 (complete outage) | SEV2 (major degradation) | SEV3 (minor impact)
**Status:** Ongoing | Resolved
**Incident Commander:** [Name or role]
**Report Author:** [Name]
**Review Date:** [Date of retrospective meeting]

---

## Impact

**Duration:** HH:MM (start time → end time, all times in UTC)
**Services affected:** [List of services, APIs, or features impacted]
**Users affected:** [Estimated count or percentage, or "unknown"]
**Customer impact:** [What users experienced — error messages, degraded performance, data unavailability]
**Business impact:** [Revenue, SLA breach, support ticket volume, reputational — quantify if known]

---

## Timeline

All times UTC.

| Time | Event |
|------|-------|
| HH:MM | [First indicator — alert fired, user report, metric anomaly] |
| HH:MM | [On-call acknowledged] |
| HH:MM | [Initial diagnosis or hypothesis] |
| HH:MM | [Mitigation attempted] |
| HH:MM | [Outcome of mitigation] |
| HH:MM | [Incident resolved / service restored] |
| HH:MM | [Post-resolution monitoring period ended] |

---

## Root Cause

[One or two paragraphs describing the technical cause of the incident. Be specific: name the
component, the failure mode, and the conditions that triggered it.

Avoid "human error" as a root cause — if a human action triggered the incident, ask why
the system allowed that action to cause an outage. The root cause is the systemic gap.]

### Contributing factors

- [Factor 1 — e.g., "No canary deployment; change went to 100% of traffic immediately"]
- [Factor 2 — e.g., "Alert threshold was set too high to catch early-stage degradation"]
- [Factor 3 — e.g., "Runbook did not cover this failure mode"]

### Five Whys

1. **Why** did the service fail? → [Answer]
2. **Why** did [answer 1] happen? → [Answer]
3. **Why** did [answer 2] happen? → [Answer]
4. **Why** did [answer 3] happen? → [Answer]
5. **Why** did [answer 4] happen? → [Systemic root cause]

---

## Detection

**How was the incident detected?** [Alert / user report / manual observation]
**Time to detection:** [Duration from first impact to first alert or report]
**Was detection fast enough?** [Yes / No — and why]

---

## Response

**Time to acknowledge:** [Duration from alert to on-call response]
**Time to mitigate:** [Duration from acknowledgement to impact reduction]
**Time to resolve:** [Duration from acknowledgement to full resolution]
**Was the runbook followed?** [Yes / No / Partially — note gaps]

---

## Resolution

[What was done to resolve the incident. Include the specific change, rollback, or configuration update.]

---

## Action Items

Each action item must have a type, owner, and target date.

| Type | Action | Owner | Due |
|------|--------|-------|-----|
| Prevent | [Change that prevents recurrence] | @name | YYYY-MM-DD |
| Detect | [Monitoring or alerting improvement] | @name | YYYY-MM-DD |
| Mitigate | [Change that reduces impact when it occurs] | @name | YYYY-MM-DD |
| Process | [Runbook, on-call, or process improvement] | @name | YYYY-MM-DD |

**Types:**
- **Prevent** — stops this failure from occurring again
- **Detect** — catches it faster next time
- **Mitigate** — reduces impact when it occurs
- **Process** — improves how the team responds

---

## What went well

[Honest acknowledgement of things that worked — fast detection, clear communication, good
runbook coverage. This section matters: it reinforces good practices.]

- [Item]
- [Item]

---

## Lessons learned

[Key insights from this incident that apply beyond the immediate fix.]

- [Lesson]
- [Lesson]
```

---

## Guidance notes

### Blameless writing

Avoid language that singles out individuals:

- "Engineer X misconfigured the flag" → "The flag had no validation and accepted invalid values"
- "On-call missed the alert" → "The alert had a 15-minute delay before paging, allowing the incident to escalate"

Blameless does not mean consequence-free — it means the report focuses on *why the system allowed this to happen*, not *who pressed the wrong button*.

### Timeline precision

Times should be UTC. If exact times are not available, use relative times ("T+5min") from a known anchor. Do not invent timestamps.

Mark uncertain times: `~HH:MM (approx)`.

### Five Whys

Stop at the point where the answer is a systemic gap (missing test, missing alert, missing validation, insufficient load testing) rather than individual action. That gap is the actionable root cause.

### Action item quality

Bad action item: "Improve monitoring"
Good action item: "Add alert on p99 latency > 2s for checkout service, firing within 2 minutes of threshold breach"

Each action item should be specific enough that a future reader can verify it was completed.

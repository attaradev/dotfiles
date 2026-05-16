# Runbook Template

Runbooks are written for on-call engineers who may be unfamiliar with the service, under pressure, at 2am. Every step must be self-contained and actionable.

---

## Template

```markdown
# Runbook: [Service or Process Name]

**Service:** [Name]
**Owner:** [Team or person]
**Last reviewed:** YYYY-MM-DD
**Review cadence:** [Quarterly / after each incident / etc.]
**Alerts that link here:** [Alert names or links]

---

## Overview

[Two to four sentences: what this service does, who depends on it, and what breaks if it is down.
Include the blast radius — what users or systems are affected by a failure.]

### SLOs / SLAs

| Metric | Target | Alert threshold |
|--------|--------|----------------|
| Availability | 99.9% | < 99.5% over 5 min |
| p99 latency | < 500ms | > 1s over 5 min |
| Error rate | < 0.1% | > 1% over 5 min |

---

## Quick reference

| Action | Command |
|--------|---------|
| View logs | `[command]` |
| Check health | `[command]` |
| Restart service | `[command]` |
| Scale up | `[command]` |
| Roll back | `[command]` |

---

## Dependencies

### Upstream (what this service depends on)

| Dependency | Type | Impact if unavailable |
|-----------|------|----------------------|
| [Service] | [DB / Cache / API] | [What degrades or fails] |

### Downstream (what depends on this service)

| Consumer | Impact if this service is down |
|----------|-------------------------------|
| [Service / team] | [Impact description] |

---

## Common operations

### Deploy

```sh
[deploy command with flags]
```

Monitor the deploy:
```sh
[command to watch rollout status]
```

Rollback if needed:
```sh
[rollback command]
```

### Scale

```sh
[scale command]
```

### View logs

```sh
# Live logs
[log command]

# Filter for errors
[log command with error filter]

# Last N lines
[log command with tail]
```

### Check health

```sh
[health check command or curl]
```

Expected response: `[what a healthy response looks like]`

---

## Troubleshooting

### Alert: [Alert name]

**Meaning:** [What condition triggered this alert and why it matters]

**First steps:**
1. [Check X]
2. [Run command Y and look for Z]
3. [If Z is present, do A; otherwise do B]

**Likely causes:**
- **[Cause 1]:** [How to confirm] → [How to fix]
- **[Cause 2]:** [How to confirm] → [How to fix]

**If unresolved after 15 minutes:** [Escalate to X / page Y / open incident]

---

### Alert: [Alert name]

[Same structure]

---

### Symptom: Service is returning 5xx errors

1. Check error rate: `[command]`
2. Check recent deploys: `git log --oneline -10` or `[deploy log command]`
3. Check upstream dependencies: `[health check commands for each dep]`
4. Check logs for error patterns: `[log command with error filter]`
5. If a recent deploy is suspected: [rollback command]

---

### Symptom: High latency

1. Check p99: `[metrics command]`
2. Check database query times: `[command]`
3. Check connection pool saturation: `[command]`
4. Check for slow queries: `[command]`
5. Check downstream call latency: `[tracing command or dashboard link]`

---

### Symptom: Memory / CPU spike

1. Check resource utilization: `[command]`
2. Identify top processes: `[command]`
3. Check for traffic spike: `[metrics command]`
4. If traffic-driven: [scale command]
5. If not traffic-driven: capture heap/profile before restarting: `[profiling command]`

---

## Escalation

| Severity | Condition | Escalate to | How |
|----------|-----------|-------------|-----|
| SEV1 | Complete outage | [Team / person] | [Slack / PagerDuty / phone] |
| SEV2 | Partial degradation | [Team / person] | [Channel] |
| SEV3 | Elevated error rate | [Team / person] | [Channel] |

**Never escalate without:** current error rate, recent changes (deploys, config), steps already tried.

---

## Runbook maintenance

This runbook should be updated:
- After every incident that revealed a gap
- After any significant architectural change
- At least quarterly (verify commands still work, links still resolve)

[TODO: Set a calendar reminder for next review: YYYY-MM-DD]
```

---

## Writing guidance

### Commands must work

Every command in a runbook must be tested and correct. A runbook with broken commands is worse than no runbook — it wastes time and erodes trust.

Use `[TODO: fill in]` for commands that need team input rather than guessing.

### Describe expected output

After each diagnostic command, describe what a healthy response looks like and what an unhealthy one looks like. Don't make the on-call engineer guess.

**Good:**
```sh
curl https://service/health
# Healthy: {"status":"ok","version":"1.4.2"}
# Unhealthy: non-200 response or {"status":"degraded",...}
```

**Bad:**
```sh
curl https://service/health
# Check the output
```

### Troubleshooting sections must be decision trees

Each troubleshooting section should branch based on what the engineer finds. "Check the logs" is not actionable — "Check the logs for `connection refused` errors — if present, the database is unreachable; if absent, check upstream API latency" is.

### Blast radius first

The first thing an on-call engineer needs to know is: how bad is this? Lead every troubleshooting section with the impact so they can calibrate their urgency.

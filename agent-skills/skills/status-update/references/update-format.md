# Update Format Templates

Use these templates as the structure for both versions. Adapt section names to match the audience's language.

---

## Version 1: Executive / non-technical

Target audience: leadership, product, cross-functional stakeholders. No implementation details. Lead with outcomes and business impact.

**Length target:** 150–300 words. Should fit in a Slack message or email preview.

```
## [Project / Team] Status — [Timeframe]

**Status:** 🟢 On track / 🟡 At risk / 🔴 Blocked

### What shipped
[2–4 bullet points of completed, user-visible outcomes.
Frame in terms of capability or impact, not implementation.
Example: "Checkout flow is now 40% faster on mobile"]

### What's in progress
[2–3 bullets of active work with expected completion.
Example: "Email notification system — targeting next Tuesday"]

### Risks and blockers
[Only include if there are actual risks. Be direct.
Example: "Payment provider API changes require migration by [date] — in progress"]

### Next milestones
[2–3 concrete upcoming deliverables with expected dates]
```

---

## Version 2: Engineering / technical

Target audience: engineering managers, tech leads, peer teams. Include technical context, blockers, and decisions made.

**Length target:** 300–600 words. Should give enough context for an engineer to understand state and help unblock.

```
## [Project / Team] Engineering Update — [Timeframe]

### Delivered
[Commits / PRs / deployments completed. Link to PRs when relevant.
Be specific: "Merged PR #123: migrated auth to JWT, old session tokens still accepted until [date]"]

### In progress
[Active branches / PRs and their state. Note any dependencies.
Example: "PR #145 (rate limiting) — 80% done, blocked on load test results from infra"]

### Blockers and decisions needed
[Technical decisions, dependencies on other teams, or external blockers.
For each: what is blocked, who can unblock it, and what the impact of delay is]

### Technical risks
[Non-obvious risks that engineering or leadership should be aware of.
Include: performance concerns, backward-compat issues, incomplete migrations, etc.]

### Architecture or approach notes
[Document any significant decisions made this period that should be in the record.
Example: "Decided to use optimistic locking instead of SELECT FOR UPDATE — see ADR-14"]

### Next two weeks
[Concrete deliverables, not aspirations. Note what might slip and why.]
```

---

## Guidance notes

**What counts as "confirmed":** commits merged to main, PRs merged, deployments completed, tests passing.

**What counts as "inference":** work visible in open branches, local changes, or verbal reports not yet reflected in code.

**Always label inferences.** Use language like "appears to be on track" or "based on open PR..." rather than stating unmerged work as complete.

**On status indicators:** Only use 🟢 if there are no active blockers and the next milestone is achievable. When in doubt, use 🟡.

**Risks and blockers:** Do not omit these to make the update look better. A stakeholder who learns about a blocker in the update can help. One who learns at the deadline cannot.

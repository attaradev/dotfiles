# PRD Template

## Document structure

---

**PRD: [Feature Name]**
**Author:** [Name] | **Date:** YYYY-MM-DD | **Status:** Draft | In Review | Approved
**Stakeholders:** [PM, Eng lead, Design, Data]

---

### TL;DR

One to three sentences. What is this, who is it for, and what problem does it solve? If a reader only reads this, they should know whether to care.

### Problem statement

Two to four paragraphs covering:
- What is the current state of the world?
- Who is affected and how severely?
- What happens today because this does not exist?
- Why does this matter to the business?

Link to any supporting research, discovery findings, or data.

### Goals

Numbered list of measurable outcomes this feature should achieve. Each goal must have a metric and a target.

1. Increase [metric] from [baseline] to [target] within [timeframe]
2. Reduce [metric] by [N]% within [timeframe]
3. [Qualitative goal framed as observable behaviour, e.g., "Users can complete onboarding without contacting support"]

### Non-goals

Explicit list of things this feature will NOT do in this iteration. Non-goals prevent scope creep and set reviewer expectations.

- Will not support [capability] — tracked separately in [link]
- Will not replace [existing system] in this phase
- Performance optimisation is out of scope; current SLAs are acceptable

### User stories

Format: As a [persona], I want to [action] so that [outcome].

Include acceptance criteria for each story in Given / When / Then format.

**Story 1: [Name]**
As a [persona], I want to [action] so that [outcome].

Acceptance criteria:
- Given [context], when [action], then [expected result]
- Given [error condition], when [action], then [error is handled gracefully]
- Given [edge case], when [action], then [correct behaviour]

**Story 2: [Name]**
...

### Constraints and requirements

List hard constraints with the reason for each.

| Constraint | Reason |
|-----------|--------|
| Must work on mobile (iOS 16+, Android 12+) | [X]% of active users are on mobile |
| Response time < 500ms at p95 | Current SLA requirement |
| GDPR compliant — no PII logged | Legal requirement |
| Backward compatible with API v2 | [N] customers on v2 with no migration path |

### UX and design

Link to mockups, prototypes, or Figma files. Describe key interaction decisions that are not obvious from the mockups.

- [Link to Figma / prototype]
- Key decision: [Describe non-obvious UX choice and why it was made]
- Open UX question: [What still needs to be resolved]

### Technical considerations

High-level notes for engineering — not a technical spec, but enough to surface known complexity.

- Dependencies: [List services, APIs, or systems this feature touches]
- Data model changes: [New tables, fields, or schema changes expected]
- Known risks: [Performance, scaling, migration, or compatibility concerns]
- Open technical question: [What engineering needs to resolve before sizing]

### Success metrics

| Metric | Baseline | Target | Measurement method |
|--------|---------|--------|-------------------|
| [Primary metric] | [Current value] | [Target] | [How it will be measured] |
| [Secondary metric] | | | |
| [Guardrail metric] | | | |

### Launch plan

| Phase | Scope | Criteria to advance |
|-------|-------|-------------------|
| Internal dogfood | [Team / N users] | [Criteria] |
| Beta / limited rollout | [N% / segment] | [Criteria] |
| GA | 100% | [Criteria] |

### Open questions

| Question | Owner | Due date |
|---------|-------|---------|
| [Question] | [Name] | YYYY-MM-DD |

### Appendix

Link to supporting materials: research findings, data analysis, competitive teardowns, prior art.

---

## Scope calibration

| Feature size | TL;DR | Problem | Goals | Stories | Constraints | Metrics |
|-------------|-------|---------|-------|---------|------------|---------|
| Small tweak | Required | 1 para | 1–2 | 1–2 | As needed | 1–2 |
| Medium feature | Required | 2 paras | 2–3 | 3–5 | Required | 2–3 |
| Large feature | Required | Full | Full | Full set | Required | Full |
| Platform / API | Required | Full | Full | Full + edge cases | Extensive | Full |

Do not write five sections for a two-line config change. Do not write two sections for a three-month project.

---

## Anti-patterns

| Pattern | Problem |
|---------|---------|
| "The system should be easy to use" | Not a requirement — unmeasurable |
| Goals without baselines | No way to know if you succeeded |
| Stories without acceptance criteria | Ambiguous definition of done |
| Constraints without reasons | Engineers cannot make trade-offs without context |
| No non-goals | Scope creep will happen |
| "TBD" on critical decisions | Delays engineering and signals the spec is not ready |

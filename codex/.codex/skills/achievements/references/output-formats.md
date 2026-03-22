# Achievement Output Formats

Use the format that best matches the stated audience and purpose. When the user does not specify, default to the Brag Doc format.

---

## Brag Doc (default)

A running record of impact for performance reviews, self-advocacy, and career conversations.

**Tone:** First-person, specific, outcome-focused. Evidence over adjectives.

```markdown
## Achievements — [Period]

### Shipped
- [Project / feature name]: [one sentence on what it does and who benefits]
  - Impact: [measurable or observable outcome if known]
  - PRs: #N, #N

### Improved
- [System or process]: [what changed and why it matters]
  - Before: [state before]
  - After: [state after]

### Led or Unblocked
- [Situation]: [what you did to move things forward]

### Reviews and Collaboration
- Reviewed N PRs across [teams/repos]
- Notable: [any review that caught a real issue or unblocked a team]
```

---

## Performance Review Input

For self-assessments submitted to managers or HR systems. Align language with company competencies if known.

**Tone:** Professional, impact-first, quantified where possible.

```markdown
### Impact and Delivery
[2–4 bullet points of highest-impact shipped work. For each: what, measurable outcome, and any cross-team or customer-facing significance]

### Collaboration and Influence
[Reviews done, teams unblocked, design decisions made or influenced]

### Technical Growth
[New capabilities demonstrated, difficult problems solved, patterns established that others now follow]

### Areas for Development
[Optional: honest self-assessment of gaps or growth areas observed this period]
```

---

## Weekly / Sprint Highlights

For team standups, sprint reviews, or manager syncs.

**Tone:** Direct, brief, no filler. What shipped, what's next, any blocks.

```markdown
## [Your Name] — Week of [date]

**Shipped:** [2–3 bullets, one line each]
**In progress:** [1–2 bullets with expected completion]
**Reviews done:** [count and notable ones]
**Blocked on:** [anything, or "nothing"]
```

---

## Resume Bullets

For updating a CV or LinkedIn. Strong resume bullets follow the XYZ formula: accomplished X, as measured by Y, by doing Z.

**Tone:** Third-person implied, past tense, starts with a strong verb, quantified.

```
- Reduced [metric] by [amount] by [approach]
- Built [system/feature] that [outcome] for [who]
- Led migration of [X] to [Y], improving [metric] by [amount]
- Reviewed N+ pull requests per [period], maintaining [standard]
```

**Strong verbs:** Designed, Built, Shipped, Reduced, Improved, Migrated, Automated, Eliminated, Led, Unblocked, Reviewed, Caught, Prevented

---

## Framing guidance

**Avoid vague qualifiers** — "significantly improved" → "reduced p99 latency from 2s to 300ms"

**Name the beneficiary** — "users can now...", "the team no longer has to...", "on-call burden dropped because..."

**Treat reviews as real work** — catching a bug in review before it ships is an achievement. Name the PR and what was prevented.

**Infer impact when metrics aren't available** — "This unblocked the team from shipping X" or "This removed a manual step from the deploy process" is valid even without a number.

**Flag uncertainty honestly** — "Impact unclear but shipped to N users" beats invented numbers.

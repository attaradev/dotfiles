# Achievement Output Formats

Use the format that best matches the stated audience and purpose. When the user does not specify, default to the Brag Doc format.

Audience shorthand:

- **technical** — engineers, tech leads, architects; jargon is fine, depth is valued
- **non-technical** / **exec** — managers, PMs, executives, HR, investors; no jargon, outcomes only
- **both** — produce two sections back to back

---

## Brag Doc (default)

A running record of impact for performance reviews, self-advocacy, and career conversations.

**Tone:** First-person, specific, business-outcome-focused. Evidence over adjectives.

```markdown
## Achievements — [Period]

### Revenue / Growth
- [Project / feature]: [what shipped and who it enables or benefits]
  - Business impact: [conversion, adoption, revenue, velocity — quantified or estimated]
  - PRs: #N, #N

### Efficiency / Cost
- [System or process]: [what changed]
  - Before: [time cost, error rate, manual steps]
  - After: [measurable improvement]

### Risk Reduction
- [Reliability / security / compliance work]: [what was prevented or hardened]
  - Exposure reduced: [outage risk, blast radius, compliance gap]

### Customer / User Outcomes
- [Feature or fix]: [user-visible change and its effect on experience or retention]

### Collaboration and Influence
- Reviewed N PRs across [teams/repos]
- Notable: [any review that caught a real issue or unblocked a team]
```

---

## Technical Audience

For engineering managers, tech leads, architects, or staff-level peers. Include design decisions, trade-offs, system complexity, and code quality signals.

**Tone:** Peer-to-peer, precise, comfortable with terminology. Depth over brevity.

```markdown
## Technical Achievements — [Period]

### System Design & Architecture
- [What was designed or restructured]: [the decision, the trade-offs considered, and why this approach]
  - Alternatives rejected: [brief note on what was considered and why not]
  - Impact on system properties: [latency, throughput, reliability, coupling, testability]

### Features Shipped
- [Feature]: [technical approach and why it matters beyond the surface behaviour]
  - Key PRs: #N, #N
  - Complexity handled: [e.g., eventual consistency, concurrent access, schema migration]

### Reliability & Correctness
- [Bug / incident / silent failure]: [root cause, fix, and what class of failure this closes]
  - Detection: [how was it caught — test, review, prod signal?]

### Code Quality & Foundations
- [Refactor / abstraction / elimination]: [what was wrong, what replaced it, who benefits]
  - Measurable: [file count, duplication removed, test coverage delta if known]

### Reviews & Technical Leadership
- Reviewed N PRs — [patterns observed, recurring issues caught, teams unblocked]
- Notable catch: [PR #N — what was wrong and what it prevented]
```

---

## Non-Technical / Executive

For managers, PMs, HR, executives, or investors. No jargon. Translate everything to business outcomes: speed, money, risk, and customer experience.

**Tone:** Plain language, present-tense impact, numbers where available. If a number isn't known, give a directional qualifier ("significantly", "eliminating", "from days to minutes").

```markdown
## What I Delivered — [Period]

### New Capabilities (what we can now do that we couldn't before)
- [Plain-language description of the capability]
  - Who benefits: [customers / users / the team / the business]
  - Business outcome: [revenue unlocked, market expanded, adoption enabled]

### Speed & Cost (what we do faster or cheaper now)
- [What changed]: [before → after in plain terms, e.g., "from days to minutes", "no longer requires an engineer"]
  - Estimated savings: [time, cost, headcount, or process steps eliminated]

### Risk Removed (what could have gone wrong and no longer can)
- [What was fixed or hardened]: [plain description of the risk that was closed]
  - Potential exposure: [data loss, downtime, compliance breach, revenue impact — pick the most relevant]

### Customer Experience (what customers or users notice)
- [What changed for them]: [plain description of the improvement]
  - Signal: [adoption, NPS, support tickets, retention — if any data exists]
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

```markdown
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

### Translating technical → non-technical

- "Refactored X" → "Teams can now add new features to X in hours instead of days"
- "Fixed race condition" → "Prevented a class of silent data corruption in a multi-user system"
- "Added RBAC" → "Ensured only authorized users can access sensitive data — audit-ready"
- "Replaced polling loop" → "Eliminated a repeated source of on-call incidents"

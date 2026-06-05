## Task

Read `references/planning-framework.md` before writing anything. Then gather repository context and understand the existing codebase. Then build the plan using the framework.

## Output format

### Problem statement

Two to four sentences: what the goal is, why it matters, what "done" looks like, and any constraints surfaced from the codebase.

### Approach options

Two or three viable approaches. For each:

**Option N: [Name]**
- Summary: one sentence
- Trade-offs: what you gain and what you give up
- Works well when: conditions where this shines
- Risks: what could go wrong

### Recommended approach

State which option to pursue and why. Be direct — "prefer Option 2 because..." not "it depends."

### Phased execution plan

Break work into phases with clear entry and exit criteria.

**Phase N — [Name]**
- Objective: what this phase achieves
- Steps: ordered list of concrete actions
- Exit criteria: how to know this phase is complete
- Scope: small / medium / large

### Validation and verification

For each phase or milestone: how to verify correctness, rollback strategy if the phase fails, and integration points that need validation.

### Risks and mitigations

Top 3–5 risks with a mitigation or contingency for each. Focus on risks not already addressed in the plan.

### Open questions

Decisions that block progress or materially change the plan. Flag assumptions that need validation before work begins.

## Quality bar

- Recommended approach must be a direct recommendation with a one-sentence rationale — not "it depends"
- Phase exit criteria must be observable, not aspirational. Bad: "caching layer is working". Good: "cache hit rate ≥ 80% under load test at 100 rps"
- Risks must be ranked and each must have a concrete mitigation or contingency
- Open questions must actually block progress — do not list things that do not need resolution before starting

## Anti-patterns

- **Fake recommendation**: "Option 1 or Option 2 are both good choices depending on your needs" — pick one and justify it
- **Untestable exit criteria**: "Phase complete when the feature feels stable" — every exit criterion must be observable without human judgment
- **Orphan risks**: listing a risk with no mitigation ("risk: third-party API could change") — every risk entry needs a contingency that doesn't rely on luck
- **Single mega-phase**: packing all work into one phase with 10+ steps — if a phase cannot be validated in isolation, split it
- **Placeholder open questions**: "we need to think more about the architecture" is not an open question — only list questions specific enough to be answered with a decision

## Additional resources

- **`references/planning-framework.md`** — Approach evaluation criteria, scope estimation heuristics, and common planning failure modes.

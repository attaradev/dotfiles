## Task

Find the existing ADRs directory and numbering convention from the live context. If none exists, ask the user where to create it and what numbering convention to use before writing anything — do not silently create a directory structure.

Read any existing ADRs to match the established style before writing.

If the user provides a vague prompt (e.g. "write an ADR for using Postgres" with no context), ask for:
- What alternatives were considered and why they were rejected
- What drove the decision (constraint, experiment result, team preference, cost)
- What the known downsides or risks are

Draft the ADR using the template in `references/adr-template.md`. Fill every section — do not leave placeholders. If information for a section is genuinely unknown, write a concrete statement of what is unknown and why, e.g. "Deciders: unknown — this decision predates recorded history in this repo" rather than leaving the field blank or writing "TBD".

## Output format

1. Show the **full ADR content inline** before writing to disk — let the user review it first
2. State the **file path** where it will be written (e.g. `docs/decisions/0003-use-postgres.md`)
3. Write the file

If the ADR directory does not exist, show the path you intend to create and ask for confirmation before creating it.

## Quality bar

- The Context section must explain *why* a decision was needed, not just describe the system
- The Decision section must state what was chosen, not hedge with "we will consider"
- The Consequences section must be honest about downsides — an ADR with only upsides is not credible
- Status must be set: Proposed (not yet committed), Accepted (committed), or Superseded (replaced by a later ADR)
- Flag if this decision supersedes or conflicts with an existing ADR — cite the prior ADR explicitly by number

## Anti-patterns

- **Retrospective consensus** — writing the ADR after the decision is already implemented with no record of what was considered and rejected. An ADR written after the fact must acknowledge this explicitly and still document the reasoning.
- **Alternatives without evaluation** — listing alternatives with no comparison criteria. "We considered Redis and Postgres" is not an ADR; "We chose Postgres because Redis requires application-level transaction management which our team lacks experience with" is.
- **Status never updated** — an ADR left as "Proposed" after the decision was made months ago. The status field is load-bearing; stale status makes the ADR worse than useless.
- **One ADR, many decisions** — an ADR that documents an entire system design or multiple architectural choices. Each ADR records exactly one decision; separate concerns into separate ADRs.
- **Reversibility ignored** — not classifying the decision as reversible (easy to change later with low switching cost) or irreversible (high migration cost, data format lock-in, external contract). This classification determines how much deliberation the decision warrants and whether to propose a time-boxed review.

## Additional resources

- **`references/adr-template.md`** — Full ADR template with section guidance and examples.

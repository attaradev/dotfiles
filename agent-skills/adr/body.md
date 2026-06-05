## Task

Find the existing ADRs directory and numbering convention from the live context. If none exists, default to `docs/adr/` with `ADR-NNNN-<kebab-title>.md` naming.

Read any existing ADRs to match the established style before writing.

Draft the ADR using the template in `references/adr-template.md`. Fill every section — do not leave placeholders. If information for a section is genuinely unknown, write a concrete statement of what is unknown and why, e.g. "Deciders: unknown — this decision predates recorded history in this repo" rather than leaving the field blank or writing "TBD".

Write the file to the correct location and number.

## Quality bar

- The Context section must explain *why* a decision was needed, not just describe the system
- The Decision section must state what was chosen, not hedge with "we will consider"
- The Consequences section must be honest about downsides — an ADR with only upsides is not credible
- Status must be set: Proposed (not yet committed), Accepted (committed), or Superseded (replaced by a later ADR)
- Flag if this decision supersedes or conflicts with an existing ADR — cite the prior ADR explicitly by number

## Additional resources

- **`references/adr-template.md`** — Full ADR template with section guidance and examples.

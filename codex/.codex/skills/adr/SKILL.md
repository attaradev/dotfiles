---
name: "adr"
description: "Draft an architecture decision record from a concrete decision and its context. Use when the user asks to write an ADR, document a decision, or capture why a design choice was made."
---

# Architecture Decision Record

Use this skill to write a focused ADR that records why a decision was needed, what was chosen, and what trade-offs were accepted.

## Workflow

1. Read the existing ADRs and matching naming convention in the repository before writing.
2. Use the bundled template in `references/adr-template.md` as the structure.
3. Write the decision, the options considered, and the consequences in decisive language.
4. Fill every section. If a detail is unknown, say so explicitly instead of leaving a blank placeholder.

## Quality rules

- Explain the forces that led to the decision, not just the chosen solution.
- Treat the decision section as a record, not a proposal.
- Be honest about the downsides and future constraints.
- Keep the ADR scoped to one decision.

## Resources

- `references/adr-template.md` contains the canonical ADR structure, naming guidance, and examples.

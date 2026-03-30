---
name: adr
description: This skill should be used when the user asks to "write an ADR", "document this decision", "create an architecture decision record", "record this design decision", "capture why we chose", or "write up the decision to". Drafts a structured Architecture Decision Record from a description of the decision and its context.
argument-hint: "[decision description or title]"
---

# Architecture Decision Record

Decision: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing ADRs: !`find . -iname "*.md" -path "*/adr*" -o -iname "*.md" -path "*/decisions*" -o -iname "ADR-*.md" 2>/dev/null | sort | head -20 || true`
- Last ADR number: !`find . -iname "ADR-*.md" -o -iname "[0-9]*.md" -path "*/adr*" 2>/dev/null | sort | tail -1 || echo "(none found)"`
- Recent commits (for context): !`git log --oneline -10 2>/dev/null || true`

## Task

Find the existing ADRs directory and numbering convention from the live context. If none exists, default to `docs/adr/` with `ADR-NNNN-<kebab-title>.md` naming.

Read any existing ADRs to match the established style before writing.

Draft the ADR using the template in `references/adr-template.md`. Fill every section — do not leave placeholders. If information for a section is genuinely unknown, say so explicitly rather than omitting the section.

Write the file to the correct location and number.

## Quality bar

- The Context section must explain *why* a decision was needed, not just describe the system
- The Decision section must state what was chosen, not hedge with "we will consider"
- The Consequences section must be honest about downsides — an ADR with only upsides is not credible
- Status must be set: Proposed (not yet committed), Accepted (committed), or Superseded (replaced by a later ADR)

## Additional resources

- **`references/adr-template.md`** — Full ADR template with section guidance and examples.

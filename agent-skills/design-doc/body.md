## Task

Read `references/design-doc-template.md` before writing anything. Then gather repository context — understand the existing system before designing additions to it.

If the user request is underspecified, state what assumptions are being made and document them in a dedicated 'Assumptions' subsection within Open Questions. Each assumption should be testable or resolvable through a conversation.

Write the design doc using the template in `references/design-doc-template.md`. Save it to the project's docs directory (match existing conventions from the live context, or default to `docs/design/`).

## Quality bar

- Goals and non-goals must be explicit — a design with no non-goals accepts unlimited scope
- Alternatives considered must be real alternatives that were actually evaluated, not strawmen
- Security and privacy sections are required for any design touching auth, data storage, or external APIs
- Open questions must name a specific unresolved decision and what changes if it resolves one way vs. the other — "we need to think about X" is not an open question; "should X be sync or async — async improves p99 but requires compensating logic" is
- A design is ready for implementation when every item in Open Questions either has an answer or is explicitly deferred with an owner and a date
- Do not propose a design that contradicts existing system constraints without acknowledging the conflict

## Anti-patterns

- **Solution in the Problem section** — the Problem section describes only the pain, never the fix; a problem that says "we need to build X" has already skipped to the solution
- **Strawman alternatives** — listing obviously bad options (e.g., "Alternative: do nothing") to make the chosen solution look good; alternatives must be approaches that were genuinely considered
- **Unresolvable open questions** — questions the author already knows the answer to, or vague standing questions like "consider performance"; every question in the table must be answerable by a named person before a specific date
- **Goals without measurable outcomes** — "improve reliability" is not a goal; "reduce checkout error rate from 0.8% to below 0.2%" is
- **Missing non-goals** — a design with no non-goals implicitly accepts unlimited scope; at least one non-goal is required

## Additional resources

- **`references/design-doc-template.md`** — Full template with section guidance and an annotated example.

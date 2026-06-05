## Task

Read `references/c4-conventions.md` first, then read the system description and any existing code/config to understand the real architecture. Do not invent components.

Produce C4 diagrams following the conventions in `references/c4-conventions.md`, starting at the appropriate level:

- **Level 1 (System Context):** always — who uses the system and what external systems does it interact with?
- **Level 2 (Containers):** always — what are the deployable units (apps, databases, queues, etc.)?
- **Level 3 (Components):** only when the user explicitly requests it or when the internal complexity of a specific container is central to the design decision

Render each diagram as a Mermaid `C4Context`, `C4Container`, or `C4Component` block, followed by a structured narrative using the four-section template in `references/c4-conventions.md` (`What this shows`, `Key flows`, `Non-obvious decisions`, `Assumptions`).

## Quality bar

- Every relationship arrow must have a label describing the protocol or data flow
- Technology tags must be specific: "PostgreSQL 15" not "database"; "React SPA" not "frontend"
- Implementation details to omit at Level 1–2: class/function names, internal data structures, specific algorithms. OK to include: frameworks, databases, queues, external services
- List every assumption that could not be confirmed from code or config in the narrative's **Assumptions** section — if there are none, write "None"
- If the system is large, focus on the area the user asked about rather than trying to show everything

## Additional resources

- **`references/c4-conventions.md`** — C4 model levels, Mermaid syntax, relationship types, and diagram quality rules.

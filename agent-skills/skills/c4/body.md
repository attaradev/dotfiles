## Task

Read the system description and any existing code/config to understand the real architecture. Do not invent components.

Produce C4 diagrams following the conventions in `references/c4-conventions.md`, starting at the appropriate level:

- **Level 1 (System Context):** always — who uses the system and what external systems does it interact with?
- **Level 2 (Containers):** always — what are the deployable units (apps, databases, queues, etc.)?
- **Level 3 (Components):** only when the user explicitly requests it or when the internal complexity of a specific container is central to the design decision

Render each diagram as a Mermaid `C4Context`, `C4Container`, or `C4Component` block, followed by a short narrative (3–5 sentences) explaining what the diagram shows and any non-obvious architectural decisions.

## Quality bar

- Every relationship arrow must have a label describing the protocol or data flow
- Technology tags must be specific: "PostgreSQL 15" not "database"; "React SPA" not "frontend"
- Implementation details to omit at Level 1–2: class/function names, internal data structures, specific algorithms. OK to include: frameworks, databases, queues, external services
- Flag any assumptions made about components that could not be confirmed from the code
- If the system is large, focus on the area the user asked about rather than trying to show everything

## Additional resources

- **`references/c4-conventions.md`** — C4 model levels, Mermaid syntax, relationship types, and diagram quality rules.

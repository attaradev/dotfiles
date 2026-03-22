---
name: "c4"
description: "Generate C4 architecture diagrams in Mermaid. Use when the user asks for a system diagram, architecture overview, container diagram, component diagram, or C4 model."
---

# C4 Architecture Diagram

Use this skill to explain architecture with C4 diagrams and a short narrative for each level.

## Workflow

1. Read the real code, config, and docs before drawing anything.
2. Start at Level 1 system context and always include Level 2 containers.
3. Add Level 3 components only when the user asks to zoom in.
4. Describe the important flows and any assumptions that could not be confirmed.

## Quality rules

- Label every relationship with the protocol or data flow.
- Use specific technology tags.
- Do not show implementation details in Level 1 or 2.
- Keep the diagram focused on the area the user asked about.

## Resource map

- `references/c4-conventions.md` -> C4 levels, Mermaid syntax, relationship rules, and narrative template

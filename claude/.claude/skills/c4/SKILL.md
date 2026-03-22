---
name: c4
description: This skill should be used when the user asks to "draw the architecture", "C4 diagram for this", "system diagram", "container diagram", "component diagram", "architecture overview diagram", or "visualise this system". Generates C4 model diagrams (context, containers, components) in Mermaid with narrative for each level.
disable-model-invocation: true
argument-hint: "[system or component to diagram]"
---

# C4 Architecture Diagram

System: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing architecture docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|c4|container|component|system diagram)" 2>/dev/null | head -8 || true`
- Key source directories: !`ls -d */ 2>/dev/null | head -20 || true`
- Docker / compose files: !`find . -maxdepth 3 -name "docker-compose*.yml" -o -name "Dockerfile" 2>/dev/null | head -10 || true`
- Service definitions (k8s, terraform): !`find . -maxdepth 4 -name "*.tf" -o -name "*.yaml" -o -name "*.yml" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -15 || true`

## Task

Read the system description and any existing code/config to understand the real architecture. Do not invent components.

Produce C4 diagrams following the conventions in `references/c4-conventions.md`, starting at the appropriate level:

- **Level 1 (System Context):** always — who uses the system and what external systems does it interact with?
- **Level 2 (Containers):** always — what are the deployable units (apps, databases, queues, etc.)?
- **Level 3 (Components):** only when the user asks to zoom into a specific container

Render each diagram as a Mermaid `C4Context`, `C4Container`, or `C4Component` block, followed by a short narrative (3–5 sentences) explaining what the diagram shows and any non-obvious architectural decisions.

## Quality bar

- Every relationship arrow must have a label describing the protocol or data flow
- Technology tags must be specific: "PostgreSQL 15" not "database"; "React SPA" not "frontend"
- Do not include implementation details (class names, function names) in Level 1 or 2
- Flag any assumptions made about components that could not be confirmed from the code
- If the system is large, focus on the area the user asked about rather than trying to show everything

## Additional resources

- **`references/c4-conventions.md`** — C4 model levels, Mermaid syntax, relationship types, and diagram quality rules.

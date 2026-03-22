---
name: "design-doc"
description: "Draft a technical design document for a feature or system change. Use when the user asks for a design doc, tech spec, or detailed approach for a multi-part implementation."
---

# Design Document

Use this skill to produce a technical design that explains the problem, the solution, alternatives, and rollout considerations.

## Workflow

1. Read the relevant code and repository context before proposing a design.
2. Capture the problem, goals, non-goals, constraints, and current state clearly.
3. Describe the proposed architecture, workflows, data or API changes, and error handling.
4. Evaluate real alternatives and explain why the chosen approach is better.
5. Include security, observability, rollout, and open questions where they matter.

## Quality rules

- Make goals and non-goals explicit.
- Do not smuggle the solution into the problem statement.
- Use real alternatives, not strawmen.
- Keep the design specific enough that implementation can start from it.

## Resources

- `references/design-doc-template.md` provides the structure and section guidance.

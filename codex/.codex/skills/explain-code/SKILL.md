---
name: "explain-code"
description: "Explain unfamiliar code paths or architecture with plain-language analogies, ASCII diagrams, and step-by-step flow breakdowns. Use when the user asks to explain a file, function, module, or how part of the codebase works."
---

# Explain Code

Use this skill to explain code from first principles without hand-waving.

## Workflow

1. Resolve the target from the user request. If it is a symbol or concept rather than a path, search for it first.
2. Read the relevant files completely before explaining anything.
3. Reconstruct the actual control flow and data flow from the code, not from generic framework expectations.
4. Anchor the explanation to concrete file and line references.
5. Scale the explanation to the size of the target: keep utilities tight and larger subsystems structured.

## Output expectations

- Start with a short, concrete analogy.
- Include an ASCII diagram for control flow, data flow, or component relationships when it helps.
- Walk through the code path in execution order and explain why each step exists.
- Call out one subtle gotcha or misconception if there is one.
- End with the next files or functions worth reading.
- If the target is unclear or missing, say so instead of guessing.

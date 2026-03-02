---
name: explain-code
description: Explain code with clear analogies, ASCII diagrams, and step-by-step flow breakdowns. Use when a user asks how code works, wants to understand architecture, or needs onboarding to an unfamiliar code path.
argument-hint: "[file-or-module]"
---

# Explain Code

Target: $ARGUMENTS

## Response format

1. Start with a plain-language analogy.
2. Include an ASCII diagram of the control flow or data flow.
3. Walk through the code path step by step.
4. Call out one common gotcha or misconception.
5. End with a short "what to read next" list of files/functions.

## Quality bar

- Keep explanations concrete and anchored in the actual code.
- Favor clarity over completeness; avoid unnecessary jargon.
- Use file paths and function names when available.

---
name: "prompt-eng"
description: "Analyse and rewrite prompts for clarity, reliability, and output quality when the user asks to improve a prompt or design one for an LLM task."
---

# Prompt Engineering

Use this skill to diagnose a weak prompt and rewrite it so the model has a clear role, task, constraints, and output shape.

## Workflow

1. Diagnose the specific failure modes in the current prompt.
2. Clarify the exact goal and what a good answer looks like.
3. Rewrite only the parts that address the real problems.
4. Explain what changed and why.
5. Define a simple evaluation check for the new prompt.

## Quality rules

- Do not add complexity unless it fixes an observed weakness.
- Include examples only when they reduce ambiguity.
- Avoid instructions the model cannot actually follow.
- Keep the rewritten prompt ready to paste and use.

## Resources

- `references/prompt-eng-guide.md` covers prompt anatomy, common weaknesses, rewrite techniques, and evaluation methods.

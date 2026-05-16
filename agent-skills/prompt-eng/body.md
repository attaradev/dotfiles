## Task

Read the prompt carefully. Diagnose what makes it likely to produce inconsistent, off-target, or low-quality outputs, then rewrite it.

Follow the improvement process in `references/prompt-eng-guide.md`:

1. **Diagnose** — identify the specific weaknesses in the current prompt
2. **Clarify the goal** — what does a perfect output look like?
3. **Rewrite** — apply the appropriate techniques for the task type
4. **Explain changes** — annotate what was changed and why
5. **Evaluation criteria** — define how to tell if the new prompt is better

Apply only the techniques that address real problems in this prompt. Do not add complexity for its own sake. If the original prompt is already clear, specific, and well-structured, say so and do not rewrite — unnecessary rewrites reduce trust in the skill. If no material improvements are found after diagnosis, document why and recommend keeping the original.

## Quality bar

- Every change must have a reason — do not rewrite for style
- Do not add instructions the model cannot follow (e.g., "always be perfectly accurate")
- If the prompt is for a specific model (Claude, GPT-4, etc.), apply model-specific best practices
- Include at least one concrete example in the rewritten prompt if the task is ambiguous
- Output the rewritten prompt in a ready-to-use code block

## Additional resources

- **`references/prompt-eng-guide.md`** — Prompt anatomy, technique library (few-shot, chain-of-thought, role, output format, constraints), model-specific guidance, and evaluation methods.

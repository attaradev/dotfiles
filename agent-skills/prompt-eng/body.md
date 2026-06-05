## Task

Read the prompt carefully. Diagnose what makes it likely to produce inconsistent, off-target, or low-quality outputs, then rewrite it.

Follow the improvement process in `references/prompt-eng-guide.md`:

1. **Diagnose** — identify the specific weaknesses in the current prompt
2. **Clarify the goal** — what does a perfect output look like?
3. **Rewrite** — apply the appropriate techniques for the task type
4. **Explain changes** — annotate what was changed and why
5. **Evaluation criteria** — define how to tell if the new prompt is better

Apply only the techniques that address real problems in this prompt. Do not add complexity for its own sake. If the original prompt is already clear, specific, and well-structured, say so and do not rewrite — unnecessary rewrites reduce trust in the skill. If no material improvements are found after diagnosis, document why and recommend keeping the original.

## Output

Produce sections in this order:
1. **Diagnosis** — bullet list of specific weaknesses found (or "no material weaknesses found")
2. **Rewritten prompt** — in a fenced code block, ready to copy-paste
3. **Change annotations** — one line per change: `[WHAT changed]: why`
4. **Evaluation criteria** — 2–3 measurable tests to confirm the new prompt is better

If no material improvements are found, output only the Diagnosis section explaining why.

## Quality bar

- Every change must have a reason — do not rewrite for style
- Do not add instructions the model cannot follow (e.g., "always be perfectly accurate")
- If the prompt is for a specific model (Claude, GPT-4, etc.), apply model-specific best practices
- Add a few-shot example to the rewritten prompt when the desired output shape is not self-evident from the task description alone
- Output the rewritten prompt in a ready-to-use code block

## Anti-patterns

Avoid these common mistakes when rewriting prompts:

- **Over-engineering a working prompt** — adding role, chain-of-thought, and XML tags to a prompt that already produces correct output. If the original works, say so.
- **Adding a generic role** — "You are a helpful assistant" or "You are an expert" with no specificity. A role only helps when it narrows the domain or shifts the output style in a measurable way.
- **Instruction bloat** — adding 10+ instructions when the model can only reliably follow 3–5. Longer is not more precise; it causes the model to ignore lower-priority items.
- **Aspirational constraints** — "Always be accurate", "Never make mistakes." These cannot be followed and add noise. Use verifiable constraints: "If confidence is low, say so in one sentence."
- **Rewriting for style** — changing wording that doesn't affect output quality. Every change must fix a diagnosed weakness.

## Additional resources

- **`references/prompt-eng-guide.md`** — Prompt anatomy, technique library (few-shot, chain-of-thought, role, output format, constraints), model-specific guidance, and evaluation methods.

---
name: prompt-eng
description: This skill should be used when the user asks to "improve this prompt", "prompt engineering for this", "make this LLM prompt better", "optimise this system prompt", "this prompt is not working", "help me write a prompt for", or "prompt design". Systematically analyses and rewrites prompts for clarity, reliability, and output quality.
argument-hint: "[the prompt to improve, or a description of what the prompt should do]"
---

# Prompt Engineering

Prompt to improve: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing prompt files: !`find . -maxdepth 5 -type f \( -name "*.txt" -o -name "*.md" -o -name "*.yaml" -o -name "*.json" \) | xargs grep -l -iE "(system.?prompt|user.?prompt|instruction|you are a|act as)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Model being used: !`grep -r -iE "(claude|gpt|gemini|llama|mistral|model.?=)" .env .env.local *.py *.ts *.js 2>/dev/null | grep -vE "(node_modules|vendor)" | head -5 || true`

## Task

Read the prompt carefully. Diagnose what makes it likely to produce inconsistent, off-target, or low-quality outputs, then rewrite it.

Follow the improvement process in `references/prompt-eng-guide.md`:

1. **Diagnose** — identify the specific weaknesses in the current prompt
2. **Clarify the goal** — what does a perfect output look like?
3. **Rewrite** — apply the appropriate techniques for the task type
4. **Explain changes** — annotate what was changed and why
5. **Evaluation criteria** — define how to tell if the new prompt is better

Apply only the techniques that address real problems in this prompt. Do not add complexity for its own sake.

## Quality bar

- Every change must have a reason — do not rewrite for style
- Do not add instructions the model cannot follow (e.g., "always be perfectly accurate")
- If the prompt is for a specific model (Claude, GPT-4, etc.), apply model-specific best practices
- Include at least one concrete example in the rewritten prompt if the task is ambiguous
- Output the rewritten prompt in a ready-to-use code block

## Additional resources

- **`references/prompt-eng-guide.md`** — Prompt anatomy, technique library (few-shot, chain-of-thought, role, output format, constraints), model-specific guidance, and evaluation methods.

# Prompt Engineering Guide

## Prompt anatomy

A well-structured prompt has these components (include only what is needed):

| Component | Purpose | Required |
|-----------|---------|---------|
| Role | Sets the model's perspective and expertise | When it improves output quality |
| Context | Background the model needs to reason well | When the task depends on it |
| Task | What to do — specific and unambiguous | Always |
| Input | The data or content to process | When variable |
| Constraints | What NOT to do; format rules; length limits | When the model makes wrong default choices |
| Output format | The exact structure expected | When structure matters |
| Examples | Concrete demonstrations of the desired output | When the task is ambiguous |

---

## Common prompt weaknesses

| Weakness | Symptom | Fix |
|----------|---------|-----|
| Vague task | Model guesses what you want | Replace "summarise this" with "extract the three most important decisions and their rationale" |
| No output format | Inconsistent structure across runs | Specify the exact format: JSON schema, markdown headers, numbered list |
| Missing constraints | Model over-explains, adds caveats, breaks character | Add "Do not explain your reasoning", "Answer in one sentence", "Do not add disclaimers" |
| Contradictory instructions | Model picks one and ignores the other | Audit for contradictions; order instructions by priority |
| Too many instructions | Model follows some, ignores others | Reduce to the 3–5 most critical; move the rest to examples |
| No examples | Model interprets the task differently each run | Add 1–3 few-shot examples that demonstrate the exact output shape |
| Role that adds nothing | "You are a helpful assistant" | Use a specific role when it genuinely shifts output: "You are a senior database engineer reviewing a migration plan for correctness and safety risks" |

---

## Technique library

### Few-shot examples

Show the model what the output should look like. Most impactful technique for consistency.

```
Input: "The deployment pipeline was failing because of a stale cache."
Output: fix(ci): clear stale build cache before dependency install

Input: "Added JWT refresh token support to the auth service."
Output: feat(auth): add JWT refresh token endpoint

Input: [the actual input]
Output:
```

Rules for few-shot examples:
- Cover the range of cases the model will encounter
- Include at least one edge case
- Make sure the examples exactly match the desired output format — the model will copy the style

### Chain-of-thought

Instruct the model to reason before answering. Dramatically improves accuracy for logic, math, and multi-step tasks.

```
Before answering, think through:
1. What is the user actually asking for?
2. What constraints apply?
3. What are the possible approaches?

Then provide your answer.
```

Or simply: "Think step by step before giving your final answer."

Use `<thinking>` tags (for Claude) to keep reasoning separate from the output.

### Output format specification

Be explicit about structure:

```
Respond with a JSON object matching this schema:
{
  "summary": string,        // one sentence
  "severity": "low" | "medium" | "high",
  "action_items": string[]  // max 3 items
}

Do not include any text outside the JSON object.
```

Or for markdown:
```
Format your response as:
## Finding
[one paragraph]

## Recommendation
[bulleted list, max 5 items]
```

### Constraints and negatives

Tell the model what NOT to do — this is often more effective than repeating what TO do:

- "Do not include explanations — only the output."
- "Do not add qualifiers like 'I think' or 'perhaps'."
- "Do not repeat the input in your response."
- "If you are uncertain, say so in one sentence instead of guessing."

### Role assignment

Use a specific role when it genuinely improves the output:

```
You are a staff engineer conducting a security code review. Your focus is on:
- Authentication and authorisation flaws
- Injection vulnerabilities
- Sensitive data exposure

You do not suggest stylistic improvements — only security issues.
```

Generic roles ("You are a helpful assistant") add noise without benefit.

### XML / structured input

For complex inputs, wrap them in tags to reduce ambiguity:

```
<code_to_review>
{{code}}
</code_to_review>

<review_criteria>
Focus on: correctness, performance, security
Do not comment on style or formatting.
</review_criteria>
```

---

## Model-specific guidance

### Claude (Anthropic)

- Claude responds well to explicit reasoning instructions: "Think carefully before answering"
- Use `<thinking>` tags to separate scratchpad reasoning from final output
- Claude respects hierarchical instructions — put the most important constraint first
- For long documents, put the question/task AFTER the document (recency matters)
- Claude is cautious about harmful content — be specific about the legitimate use case if the task could be misread
- Avoid "Do your best" — Claude already does; it adds nothing and can cause over-elaboration

### GPT-4 / OpenAI

- System prompt carries more weight than user prompt for persistent behaviour
- GPT-4 benefits from explicit role assignment in the system prompt
- Use `json_mode` for structured output rather than instructing it to return JSON
- For long contexts, repeat key instructions near the end — model tends to weight recent context more

### General LLMs

- Shorter prompts often outperform longer ones — remove instructions the model already follows by default
- Test prompts with at least 5 varied inputs before declaring them production-ready
- Version your prompts — treat them like code; track changes and regressions

---

## Evaluation criteria

Define how to tell if the new prompt is better before testing it:

| Criterion | How to measure |
|-----------|---------------|
| Consistency | Run the same input 5 times — does the output structure match each time? |
| Accuracy | Check outputs against 10 known-good examples |
| Format compliance | Does every output match the specified format without post-processing? |
| Edge case handling | What happens with empty input, very long input, or adversarial input? |
| Failure mode | When the model is uncertain, does it say so or does it hallucinate? |

---

## Rewrite annotation format

When presenting the improved prompt, annotate the changes:

```
[ROLE added: specifies domain expertise and narrows scope]
You are a senior database engineer reviewing SQL migrations for safety.

[TASK clarified: was "review this", now specifies exactly what to check]
Review the migration below for:
- Data loss risk (irreversible operations without a rollback)
- Lock contention (operations that will block reads/writes at scale)
- Missing index creation for new foreign keys

[CONSTRAINT added: prevents over-explanation]
For each issue: state the risk, the affected line, and the fix. Do not summarise the migration.

[OUTPUT FORMAT added: ensures consistent structure]
Format each issue as:
**[Risk level] — [Issue name]**
Line: [N]
Risk: [one sentence]
Fix: [the corrected SQL]

[FEW-SHOT EXAMPLE added: demonstrates exact output shape]
Example:
**[High] — Irreversible column drop**
Line: 12
Risk: DROP COLUMN is permanent; if data needs to be recovered, no rollback exists.
Fix: Rename column to _deprecated_column_name first; drop in a follow-up migration after confirming no reads.

<migration>
{{migration_sql}}
</migration>
```

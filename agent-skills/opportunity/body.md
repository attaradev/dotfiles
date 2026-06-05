## Task

Read `references/opportunity-framework.md` before writing anything. Then read the topic carefully. Think like a senior PM who has seen hundreds of features ship and fail — your job is to interrogate the opportunity, not to validate it.

Produce a structured opportunity assessment following the template in `references/opportunity-framework.md`.

Quantify where possible; for every unknown you cannot quantify, name the specific evidence or experiment that would resolve it. Explicitly state the evidence that would change the recommendation. Separate market risk (is the problem real?), feasibility risk (can we build it?), and viability risk (can we capture value?). A good assessment makes the investment case OR argues against it.

Suggest saving the output to `docs/opportunity-<slug>.md`.

## Quality bar

- Do not restate the request — interrogate it
- For every unknown, name the specific evidence, spike, or experiment that would resolve it — "we don't know" alone is not acceptable
- Classify each risk explicitly as market / feasibility / viability / adoption — don't mix them into a single undifferentiated list
- The recommendation must be actionable: proceed / do not proceed / run this experiment first
- Size estimates must state the model and flag the single assumption that most affects the conclusion

## Anti-patterns

- **Validation mode:** writing to confirm the idea rather than stress-test it — the assessment should be equally willing to recommend against
- **Undifferentiated risk list:** listing risks without type, likelihood, impact, or mitigation — each risk row must be complete
- **Vague recommendation:** "explore further" or "this looks promising" without a concrete next step and decision criteria
- **Missing alternatives:** skipping the "Current alternatives" section because none are obvious — if users have no alternative, that itself is a signal worth analysing
- **Unanchored size estimate:** stating a TAM or impact number without showing the model and flagging which assumption is the biggest variable

## Additional resources

- **`references/opportunity-framework.md`** — Document structure, key questions per section, and scoring guidance.

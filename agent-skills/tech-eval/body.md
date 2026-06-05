## Task

Read `references/tech-eval-framework.md` before writing anything.

Before evaluating, gather the non-functional requirements that constrain the decision: latency SLA, throughput targets, data volume, team size, hiring velocity, and existing operational expertise. State which inputs are known vs. assumed.

Read the decision context. If the user appears to favour a specific option, evaluate it without privileging it — the recommendation must be determined by the weighted scores, not by what was implied as preferred.

Produce a structured evaluation following `references/tech-eval-framework.md`:

1. **Decision framing** — what exactly is being decided, what are the constraints, and what is out of scope
2. **Options** — all viable options including status quo and building in-house. For greenfield decisions, status quo means "defer the decision" or "hire a contractor" — always include it
3. **Evaluation criteria** — weighted by importance to this specific context
4. **Scoring matrix** — each option rated against each criterion
5. **Trade-off analysis** — what each option wins and loses; what the scoring misses
6. **Recommendation** — with explicit rationale and the conditions under which it would change

Do not omit the "do nothing" or "build in-house" option even if the user seems to prefer a specific vendor.

## Quality bar

- Criteria must be specific to this decision context — not generic ("scalable", "reliable")
- Scores must be justified, not asserted — one sentence per cell in the scoring matrix
- The recommendation must name the winner AND the second-best option to use if the primary fails
- Flag any criteria where you lack sufficient information to score accurately
- TCO must include: licensing + infrastructure + engineering time (implementation + learning curve) + ongoing support + switching cost if migration becomes necessary — not just licensing cost

## Anti-patterns

- Scoring a cell without a justification sentence — "4" alone is not a score
- Recommending the option the user mentioned first without evaluating alternatives
- Using generic criteria ("scalable", "reliable", "performant") that apply equally to every option
- TCO that only lists licensing cost and omits migration, training, and ongoing operational toil
- A recommendation that names only one option and omits the fallback and the conditions that would change the decision

## Additional resources

- **`references/tech-eval-framework.md`** — Criteria selection, scoring guidance, trade-off analysis, and build vs. buy heuristics.

---
name: tech-eval
description: This skill should be used when the user asks to "evaluate these options", "build vs buy", "vendor selection", "compare these technologies", "technology evaluation", "which database should we use", "make vs buy decision", or "tech stack decision". Produces a structured technology evaluation with criteria matrix, trade-off analysis, and a recommendation with rationale.
disable-model-invocation: true
argument-hint: "[the decision to evaluate: options, context, and key constraints]"
---

# Technology Evaluation

Decision: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing architecture or tech docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(architecture|tech stack|decision|adr|evaluation)" 2>/dev/null | head -8 || true`
- Current dependencies: !`cat package.json go.mod requirements.txt Gemfile pom.xml 2>/dev/null | head -40 || true`

## Task

Read the decision context carefully. Think like an architect who has made and lived with technology choices for years — the goal is to make the right long-term decision, not to validate a preference.

Produce a structured evaluation following `references/tech-eval-framework.md`:

1. **Decision framing** — what exactly is being decided, what are the constraints, and what is out of scope
2. **Options** — all viable options including status quo and building in-house
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
- Include total cost of ownership, not just licensing cost

## Additional resources

- **`references/tech-eval-framework.md`** — Criteria selection, scoring guidance, trade-off analysis, and build vs. buy heuristics.

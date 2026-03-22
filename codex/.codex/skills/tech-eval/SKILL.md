---
name: "tech-eval"
description: "Evaluate technology choices with criteria, scoring, trade-offs, and a recommendation when the user asks what stack, database, or vendor to choose."
---

# Technology Evaluation

Use this skill to compare real options, including status quo and build-vs-buy, for a specific technical decision.

## Workflow

1. Frame the decision precisely and state the constraints.
2. Include status quo, build in-house, and at least two external options.
3. Choose criteria that matter for this context and weight them explicitly.
4. Score each option with justification, then analyse trade-offs.
5. Recommend a winner, a fallback, and the conditions that would change the choice.

## Quality rules

- Keep criteria specific to the decision, not generic.
- Include TCO, operational cost, integration effort, and lock-in risk.
- Do not omit the "do nothing" option.
- Flag any scoring gaps caused by missing information.

## Resources

- `references/tech-eval-framework.md` documents decision framing, criteria, scoring, and recommendation structure.

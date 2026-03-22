---
name: metrics
description: This skill should be used when the user asks to "define success metrics", "what KPIs should we track", "north star for this", "metrics for this feature", "how do we measure success", "OKR metrics", or "measurement plan". Defines a north star metric, input metrics, guardrail metrics, and a measurement plan for a feature or product area.
disable-model-invocation: true
argument-hint: "[feature, product area, or goal to define metrics for]"
---

# Metrics & Measurement Plan

Topic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing metrics or analytics docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(metric|kpi|north star|analytics|measurement|okr)" 2>/dev/null | head -8 || true`

## Task

Read the topic carefully. Think about what the feature or product area is ultimately trying to achieve for users and for the business.

Produce a complete measurement plan following the framework in `references/metrics-framework.md`:

1. **North star metric** — the one number that best represents the value delivered
2. **Input metrics** — leading indicators the team can directly influence
3. **Output metrics** — lagging outcomes that confirm success
4. **Guardrail metrics** — signals to watch to ensure you are not causing harm elsewhere
5. **Anti-metrics** — what you explicitly will not optimise for, and why
6. **Measurement plan** — how each metric will be collected and reported

Challenge the obvious metrics. "Number of users" is not a north star; it does not tell you whether users got value. "Active users who completed [core action] at least once per week" is closer.

## Quality bar

- North star must reflect user value, not business value (DAU is a business metric, not a user value metric)
- Input metrics must be actionable — the team must be able to run experiments that move them
- Guardrail metrics must cover at least: engagement health, support load, and a business-safety metric
- Every metric must have a defined measurement method — if you cannot measure it, it is not a metric
- Avoid vanity metrics: total sign-ups, total page views, total features shipped

## Additional resources

- **`references/metrics-framework.md`** — Metric taxonomy, north star selection, input/output/guardrail structure, and anti-pattern guide.

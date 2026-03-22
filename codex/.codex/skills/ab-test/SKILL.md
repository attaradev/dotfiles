---
name: "ab-test"
description: "Design rigorous A/B tests for changes or hypotheses. Use when the user asks to design an experiment, split test, RCT, sample size, MDE, rollout decision, or experiment brief."
---

# A/B Test Design

Use this skill to turn a change into a falsifiable experiment with a clear decision rule.

## Workflow

1. State the hypothesis in falsifiable form.
2. Define control and treatment variants.
3. Set the primary metric, minimum detectable effect, sample size, duration, and guardrails before running.
4. Define analysis and binary decision criteria.
5. Flag threats to validity and any underpowered assumptions.

## Quality rules

- Do not design an experiment that cannot fail.
- Choose the MDE before the test runs.
- State baseline conversion rate, `α`, and power when estimating sample size.
- Make the decision binary: ship or do not ship.

## Resource map

- `references/ab-test-template.md` contains the experiment brief template, sample size guidance, analysis plan, and validity threats.

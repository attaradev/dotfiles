---
name: ab-test
description: This skill should be used when the user asks to "design an A/B test", "experiment design for this", "how do we test this", "split test", "randomised controlled trial for this", "experiment brief", or "what sample size do we need". Produces a complete experiment brief with hypothesis, variants, sample size, duration, primary metrics, and rollout decision criteria.
disable-model-invocation: true
argument-hint: "[the change or hypothesis you want to test]"
---

# A/B Test Design

Change to test: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing experiment or analytics docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(experiment|a/b test|split test|hypothesis|sample size)" 2>/dev/null | head -8 || true`

## Task

Read the change carefully. Design a rigorous experiment that can produce a clear, actionable result — either a confident decision to ship or a confident decision not to.

Follow the template in `references/ab-test-template.md`:

1. State the hypothesis in falsifiable form
2. Define control and treatment variants
3. Identify the primary metric and calculate the required sample size
4. Set the minimum detectable effect (MDE) before running
5. Define guardrail metrics
6. Specify the analysis plan and decision criteria
7. Flag threats to validity

Do not design an experiment that cannot fail. If every plausible outcome would lead to shipping, the experiment is not needed — just ship.

## Quality bar

- The MDE must be set before the experiment runs — not chosen after looking at results
- Sample size calculation must state: baseline conversion rate, MDE, significance level (α), and statistical power (1−β)
- Decision criteria must be binary: ship / do not ship, with no "we'll discuss" escape hatch
- Flag if the experiment is underpowered for the expected effect size
- Identify at least two threats to internal validity (novelty effect, selection bias, seasonality, etc.)

## Additional resources

- **`references/ab-test-template.md`** — Experiment brief template, sample size guidance, analysis plan, and validity threats.

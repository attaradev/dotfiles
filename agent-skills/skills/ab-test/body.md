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

Before finalising the design, validate that the MDE and proposed sample size are achievable within the experiment timeline and available population size. Flag if they are not.

Do not design an experiment that cannot fail. If every plausible outcome would lead to shipping, the experiment is not needed — just ship.

## Quality bar

- The MDE must be set before the experiment runs — not chosen after looking at results
- Sample size calculation must state: baseline conversion rate, MDE, significance level (α ≤ 0.05), and statistical power (1−β ≥ 0.80) — not qualitative estimates
- Decision criteria must be binary: ship / do not ship, with no "we'll discuss" escape hatch
- Flag if the experiment is underpowered for the expected effect size given the available population
- Identify at least two threats to internal validity (novelty effect, selection bias, seasonality, etc.)

## Additional resources

- **`references/ab-test-template.md`** — Experiment brief template, sample size guidance, analysis plan, and validity threats.

## Task

Read `references/ab-test-template.md` before writing anything. Then read the change carefully and fill out the template to produce an experiment brief.

The goal is a rigorous experiment that can produce a clear, actionable result — either a confident decision to ship or a confident decision not to.

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

## Anti-patterns

- **Circular hypothesis**: "We believe the new button will increase clicks because it's a better button" — the mechanism must be a real causal claim, not a tautology.
- **Post-hoc MDE**: Choosing the MDE or significance threshold after seeing early results. The brief must set these before launch.
- **Infinite extension**: Extending run time more than once because results haven't reached significance. Set a hard cap (e.g., max 2 extensions of the original duration) or treat the result as a null.
- **Multiple primary metrics**: Listing two "primary" metrics to maximise the chance one looks good. One primary metric only — everything else is secondary or guardrail.
- **Underpowered and shipped anyway**: Reporting a positive direction with p > 0.05 as a "trend" and shipping. Non-significant means undecided, not a weak yes.

## Quality bar

- The MDE must be set before the experiment runs — not chosen after looking at results
- Sample size calculation must state: baseline conversion rate, MDE, significance level (α ≤ 0.05), and statistical power (1−β ≥ 0.80) — not qualitative estimates
- Decision criteria must be binary: ship / do not ship, with no "we'll discuss" escape hatch
- Flag if the experiment is underpowered for the expected effect size given the available population
- Identify at least two threats to internal validity (novelty effect, selection bias, seasonality, etc.)

## Additional resources

- **`references/ab-test-template.md`** — Experiment brief template, sample size guidance, analysis plan, and validity threats.

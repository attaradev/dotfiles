## Task

Read `references/hypothesis-template.md` before writing anything. Then read the idea carefully. Your job is to surface the riskiest assumption, design the cheapest test that could invalidate it, and define the minimum signal required to proceed.

Work through the hypothesis structure in `references/hypothesis-template.md`:

1. State the belief being tested
2. Identify the riskiest assumption (the one that, if wrong, kills the idea)
3. Define the experiment — the cheapest, fastest test
4. Set the minimum success criteria before running it
5. Identify what a negative result means for the idea

The goal is to find out quickly and cheaply whether the assumption is wrong — not to confirm it. A valid experiment must be able to produce a negative result; if no outcome could falsify the hypothesis, reject the design and start over.

Suggest saving the output to `docs/hypothesis-<slug>.md`.

## Quality bar

- One hypothesis per experiment — multiple assumptions tested together produce uninterpretable results
- The test must be able to produce a negative result — if every outcome confirms the hypothesis, the test is useless
- Success criteria must be defined before running the test, not after
- "We got 50 sign-ups" is not a success criterion; "≥30% of users who see the landing page click 'Get early access'" is
- Success criteria must be falsifiable, not aspirational — "we hope to see 40% engagement" is not a criterion; "we will ship if engagement ≥ 30%; we will stop if ≤ 15%" is
- Separate learning goals from business goals: state both explicitly — "We want to learn whether X" is different from "We want to achieve Y"; conflating them produces success criteria that measure the wrong thing

## Additional resources

- **`references/hypothesis-template.md`** — Hypothesis format, assumption mapping, experiment types, and worked examples.

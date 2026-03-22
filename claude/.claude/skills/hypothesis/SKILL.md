---
name: hypothesis
description: This skill should be used when the user asks to "write a hypothesis", "frame this as an experiment", "how do we validate this", "lean hypothesis for this", "experiment design", "build-measure-learn for this", or "what is our riskiest assumption". Produces a lean experiment hypothesis with the assumption, signal, test design, and minimum evidence required to proceed.
disable-model-invocation: true
argument-hint: "[the feature, idea, or belief you want to validate]"
---

# Hypothesis & Experiment Design

Idea to validate: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing research or experiment docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(hypothesis|experiment|validate|riskiest assumption|lean)" 2>/dev/null | head -8 || true`

## Task

Read the idea carefully. Your job is to surface the riskiest assumption, design the cheapest test that could invalidate it, and define the minimum signal required to proceed.

Work through the hypothesis structure in `references/hypothesis-template.md`:

1. State the belief being tested
2. Identify the riskiest assumption (the one that, if wrong, kills the idea)
3. Define the experiment — the cheapest, fastest test
4. Set the minimum success criteria before running it
5. Identify what a negative result means for the idea

Think like a scientist, not a salesperson. The goal is to find out quickly and cheaply whether the assumption is wrong — not to confirm it.

Suggest saving the output to `docs/hypothesis-<slug>.md`.

## Quality bar

- One hypothesis per experiment — multiple assumptions tested together produce uninterpretable results
- The test must be able to produce a negative result — if every outcome confirms the hypothesis, the test is useless
- Success criteria must be defined before running the test, not after
- "We got 50 sign-ups" is not a success criterion; "≥30% of users who see the landing page click 'Get early access'" is
- Flag the difference between learning goals (what do we want to know?) and business goals (what do we want to happen?)

## Additional resources

- **`references/hypothesis-template.md`** — Hypothesis format, assumption mapping, experiment types, and worked examples.

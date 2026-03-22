---
name: user-jobs
description: This skill should be used when the user asks to "jobs to be done", "what job is this solving", "frame this as JTBD", "what are users really trying to do", "JTBD analysis", or "what is the underlying job". Reframes a feature or problem through the Jobs-to-be-Done lens to expose the real motivation driving user behaviour.
disable-model-invocation: true
argument-hint: "[feature, product area, or user behaviour to analyse]"
---

# Jobs-to-be-Done Analysis

Topic: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing product docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(user story|persona|prd|job to be done|jtbd)" 2>/dev/null | head -8 || true`

## Task

Read the topic. Your goal is to uncover the real job — the progress the user is trying to make in their life or work — not the feature they asked for.

Apply the JTBD framework from `references/jtbd-framework.md` to produce:

1. **Core job statement** — the functional job in canonical form
2. **Job map** — the eight stages of executing the job
3. **Functional, social, and emotional dimensions** of the job
4. **Outcome statements** — what "done well" looks like from the user's perspective
5. **Competing solutions** — everything the user fires when they hire your product
6. **Insights** — what this analysis reveals about where to focus

Think like Clayton Christensen: the user is not buying a product, they are hiring it to do a job. Ask "why" until you hit bedrock.

Suggest saving the output to `docs/jtbd-<slug>.md`.

## Quality bar

- The job statement must describe progress, not a feature: "help me feel confident my data is safe" not "provide backups"
- Functional jobs are the backbone; social and emotional jobs explain why competing solutions win or lose
- Outcome statements must be measurable: "minimise the time to X", "increase the likelihood of Y"
- Surface at least one non-obvious insight that would change how the team approaches the problem

## Additional resources

- **`references/jtbd-framework.md`** — Job statement syntax, job map stages, outcome statement format, and worked examples.

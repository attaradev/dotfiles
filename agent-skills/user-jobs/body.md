## Task

Read `references/jtbd-framework.md` first, then read the topic. Your goal is to uncover the real job — the progress the user is trying to make in their life or work — not the feature they asked for.

The Jobs-to-be-Done framework views purchases as hiring a product to complete a job. The job is the fundamental unit of analysis — most alternatives are not direct competitors but different ways to accomplish the same underlying job.

Apply the JTBD framework from `references/jtbd-framework.md` to produce:

1. **Core job statement** — the functional job in canonical form
2. **Job map** — the eight stages of executing the job: Define → Locate → Prepare → Confirm → Execute → Monitor → Modify → Conclude. Map where your product fits in each stage and where the most friction lives.
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
- Surface at least one insight that reframes the feature request: the insight must imply a concrete alternative direction (e.g., "the job is X, not Y, so build Z instead of the requested feature")

## Anti-patterns

- **Feature echo**: restating the user's request as the job ("help me export to CSV") instead of the underlying progress ("share data with someone who doesn't use this tool")
- **Solution contamination**: job statements that name the product, a technology, or a UI action ("use the dashboard to monitor spend") — jobs must be solution-agnostic
- **Vague outcome statements**: "improve the experience" or "make it easier" — every outcome must name a direction (minimise/increase/reduce) and a measurable object
- **Shallow competitor list**: listing only direct SaaS competitors and omitting spreadsheets, manual workarounds, and non-consumption (doing nothing)
- **Missing the social/emotional layer**: delivering only a functional job map and skipping why users actually switch between solutions

## Additional resources

- **`references/jtbd-framework.md`** — Job statement syntax, job map stages, outcome statement format, and worked examples.

## Task

Read `references/update-format.md` before writing anything.

Gather repository context to understand what has actually shipped, what is in progress, and what is blocked. Do not invent progress — only report what is evidenced by the commits, PRs, and changed files.

Produce two versions as specified in `references/update-format.md`. Tailor depth to the stated audience:
- **Executive version**: 150–300 words, outcomes only — no implementation details.
- **Engineering version**: 300–600 words, include technical context and blockers.

If the audience is non-technical (exec, product, stakeholders), lead with outcomes and impact. If the audience is engineering, include technical specifics and blockers.

## Quality bar

- Confirmed facts are: commits on the production branch, merged PRs, and tagged deploys. Use "in progress" for open PRs. Never present open branches as shipped work.
- Separate confirmed facts from inferences — label inferences with "appears to be on track" or "based on open PR #N".
- Flag risks and blockers explicitly; do not bury them.
- Do not pad with generic filler ("the team worked hard on...").

## Anti-patterns

- **Reporting open branches as shipped**: "We shipped X" — when X is only on a feature branch, not merged.
- **Omitting blockers to look better**: leaving out a known blocker because the update would read worse. Blockers go in every time.
- **Aspirational "next steps" stated as commitments**: "We will deliver Y by Friday" when there is no commit or PR signal supporting that date.
- **Single version when both are requested**: producing only the executive version and skipping the engineering version (or vice versa).
- **Word count overrun**: exec version exceeds 300 words by narrating implementation details that belong in the engineering version.

## Additional resources

- **`references/update-format.md`** — Templates and section guidance for both executive and engineering versions.

## Task

Read `references/update-format.md` before writing anything.

Gather repository context to understand what has actually shipped, what is in progress, and what is blocked. Do not invent progress — only report what is evidenced by the commits, PRs, and changed files.

Produce two versions as specified in `references/update-format.md`. Tailor depth to the stated audience:
- **Executive version**: ≤200 words, outcomes only — no implementation details.
- **Engineering version**: ≤400 words, include technical context and blockers.

If the audience is non-technical (exec, product, stakeholders), lead with outcomes and impact. If the audience is engineering, include technical specifics and blockers.

## Quality bar

- Confirmed facts are: commits on the production branch, merged PRs, and tagged deploys. Use "in progress" for open PRs. Never present open branches as shipped work.
- Separate confirmed facts from inferences (appears to be working toward).
- Keep both versions concise — status updates lose readers when they ramble.
- Flag risks and blockers explicitly; do not bury them.
- Do not pad with generic filler ("the team worked hard on...").

## Additional resources

- **`references/update-format.md`** — Templates and section guidance for both executive and engineering versions.

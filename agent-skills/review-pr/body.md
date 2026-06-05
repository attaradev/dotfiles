## Task

Work through this sequence before writing a single finding:

1. **Understand intent** — read the PR description, linked issues, and labels. What problem is being solved? What is intentionally out of scope?
2. **Scan the file list** — note which files changed, their sizes, and whether the set is internally consistent with the stated intent. Flag any file that looks unrelated or accidental.
3. **Read every changed file completely**, in diff order. For each file:
   - Understand what the file does in the broader system.
   - Annotate every line or block that could be wrong, risky, or improvable.
   - If a hunk references shared abstractions, interfaces, or callers not in the diff, read those files for context.
   - Hold findings until all files are read — cross-file patterns matter.
4. **Apply every category in `references/review-checklist.md`** across the full diff. For each category, annotate 'Not applicable' if the PR is clearly out of scope — do not skip silently.
5. **Check for missing files**: test files for new code, docs for user-facing behavior, migrations for schema changes, config changes for new dependencies.

Guardrails:
- Do not invent findings without evidence in the diff.
- Do not comment on formatting or naming unless it impairs readability or correctness.
- Cite uncertainty explicitly ("I cannot verify this without seeing X").
- When a tradeoff exists, state both sides before recommending — do not flag a design decision as a bug without acknowledging why it was made.

## Anti-patterns

Avoid these failure modes:

- **Padding with trivia** — filing a "Minor concern" for a renamed variable or a two-space indent difference when correctness is unaffected.
- **Fabricating context** — stating "this will cause a race condition" without a code path in the diff that demonstrates concurrent access.
- **Vague blockers** — writing "this looks unsafe" without citing the exact line, the attack vector, and a concrete fix.
- **Over-hedging the recommendation** — choosing "Cannot fully assess" when only one peripheral file lacks context; reserve it for cases where >30% of the changed logic is unreadable without missing context.
- **Skipping the checklist** — producing findings only from a skim of the diff instead of working through every category in `references/review-checklist.md`.

## Output format

### Overall assessment

One paragraph: scope and intent of the PR, confidence level (note limits from diff size or missing context), and dominant risks.

### Per-file summary

One row for every changed file:

| File | Lines +/- | What changed | Risk |
|------|-----------|-------------|------|
| `path/file.ext` | +N / -N | One-line description | High / Medium / Low / None |

Flag any file whose changes appear unintentional or inconsistent with the PR description.

### Blockers

Must be resolved before merge — correctness bugs, data loss, security holes, broken contracts.

**[LABEL]** — `path/file.ext` (line N)
> What is wrong, why it matters, what to do instead. Be concrete.

### Major concerns

Significant but non-blocking: performance regressions, missing observability, backward-compat risks, important test gaps. Same format as Blockers.

### Minor concerns

Low-severity only — unclear error messages, cosmetic drift, non-critical naming confusion. Keep this section tight or omit entirely.

### Test coverage gaps

For each untested behavior: what is untested, why it is risky, and what a useful test would assert. Omit if coverage is adequate.

### Positive observations

Well-executed decisions worth calling out. Balanced reviews build trust. Omit if nothing stands out.

### Inline review comments

Generate a ready-to-post comment for **every finding worth raising** — do not cap at a handful. Format each as:

> **`path/to/file.ext` line N** *(Blocker | Major | Minor)*
>
> [Comment — specific, actionable, no filler. For blockers: state what to do instead.]

### Approval recommendation

Choose one with a one-sentence rationale:
- **Approve** — no blockers, concerns minor or addressed
- **Approve with comments** — no blockers, non-trivial concerns to address
- **Request changes** — one or more blockers present (list by label)
- **Cannot fully assess** — >30% of changed code lacks context (external dependencies not in the diff, missing config files); explain the gap

---

After presenting the review, emit the **single correct command** that matches your approval recommendation — do not list all variants:

| Recommendation | Command |
|---|---|
| Approve | `gh pr review <N> --approve --body "<one-sentence rationale>"` |
| Approve with comments | `gh pr review <N> --comment --body "<one-sentence rationale>"` |
| Request changes | `gh pr review <N> --request-changes --body "<one-sentence rationale>"` |
| Cannot fully assess | `gh pr review <N> --comment --body "<one-sentence explanation of gap>"` |

Ask the user explicitly whether to run the command. **Do not run it without confirmation.** Only execute once the user says yes.

If there are inline comments to post, offer to post each one via `gh pr review <N> --comment --body "<comment>"`, one at a time, waiting for user confirmation on each.

## Quality bar

- All findings must be backed by evidence in the diff — do not invent issues
- Inline comments must be specific and actionable; do not cap their number
- Do not comment on formatting or naming unless it impairs correctness
- Approval recommendation must be explicit — choose one of the four options, do not hedge

## Additional resources

- **`references/review-checklist.md`** — Eight review categories with specific signals to look for. Read before forming findings.
- **`scripts/collect-pr-context.sh`** — Collects PR summary, file list, linked issues, existing reviews, and full diff via `gh`.

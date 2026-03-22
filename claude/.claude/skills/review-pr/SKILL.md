---
name: review-pr
description: This skill should be used when the user asks to "review PR", "review pull request", "review this PR", "look at PR #N", "gh pr review", or provides a GitHub PR number or URL. Performs a deep, file-by-file pull request review via the GitHub CLI — producing a per-file breakdown, severity-ranked findings, exhaustive inline comments, and an approval recommendation.
disable-model-invocation: true
argument-hint: "[PR-number or owner/repo#PR]"
---

# GitHub PR Review

Review target: $ARGUMENTS

## Gather context

Run the context collector via Bash tool before forming any opinion:

```
bash "$HOME/.claude/skills/review-pr/scripts/collect-pr-context.sh" "$ARGUMENTS" 2>&1
```

If the diff is large and key files are referenced without full context, read them directly with the Read tool.

## Review process

Work through this sequence before writing a single finding:

1. **Understand intent** — read the PR description, linked issues, and labels. What problem is being solved? What is intentionally out of scope?
2. **Scan the file list** — note which files changed, their sizes, and whether the set is internally consistent with the stated intent. Flag any file that looks unrelated or accidental.
3. **Read every changed file completely**, in diff order. For each file:
   - Understand what the file does in the broader system.
   - Annotate every line or block that could be wrong, risky, or improvable.
   - If a hunk references shared abstractions, interfaces, or callers not in the diff, read those files for context.
   - Hold findings until all files are read — cross-file patterns matter.
4. **Apply every category in `references/review-checklist.md`** across the full diff.
5. **Check for missing files**: test files for new code, docs for user-facing behavior, migrations for schema changes, config changes for new dependencies.

Guardrails:
- Do not invent findings without evidence in the diff.
- Do not comment on formatting or naming unless it impairs readability or correctness.
- Cite uncertainty explicitly ("I cannot verify this without seeing X").
- Be skeptical but fair — engage with tradeoffs, not just surface observations.

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
- **Cannot fully assess** — missing context; explain the gap

---

After presenting the review, offer to post it to GitHub using one of:
```
gh pr review <N> --comment --body "<summary>"
gh pr review <N> --request-changes --body "<summary>"
gh pr review <N> --approve --body "<summary>"
```

## Additional resources

- **`references/review-checklist.md`** — Eight review categories with specific signals to look for. Read before forming findings.
- **`scripts/collect-pr-context.sh`** — Collects PR summary, file list, linked issues, existing reviews, and full diff via `gh`.

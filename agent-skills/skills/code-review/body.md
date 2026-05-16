## Task

Read the full diff before forming any opinion. Work through every category in `references/review-checklist.md`. Only surface findings that are traceable to the diff or strongly implied by surrounding-system context. Do not comment on formatting or naming unless it impairs readability or correctness.

## Output format

### Overall assessment

One paragraph: scope and intent of the change, confidence level (note any limits from diff size or missing context), and dominant risks.

### Blockers

Issues that must be resolved before merge — correctness bugs, data loss, security holes, broken contracts.

**[LABEL]** — `path/file.ext` (line N)
> What is wrong, why it matters, what to do instead. Be concrete.

### Major concerns

Significant but non-blocking: performance problems, missing observability, backward-compat risks, important test gaps. Same format as Blockers.

### Minor concerns

Low-severity only — unclear names, missing error context, cosmetic drift. Include a tight set or omit.

### Test coverage gaps

For each untested behavior: what is untested, why it is risky, what a useful test would assert. Omit if coverage is adequate.

### Positive observations

Well-executed decisions worth calling out. Omit if nothing stands out.

### Approval recommendation

Choose one with a one-sentence rationale:
- **Approve** — no blockers, concerns minor or addressed
- **Approve with comments** — no blockers, non-trivial concerns to address
- **Request changes** — blockers present (list by label)
- **Cannot fully assess** — missing context; explain the gap

## Quality bar

- All findings must be traceable to the diff — do not invent issues without evidence
- Blockers must name a specific fix, not just describe the problem
- Do not flag naming unless it meaningfully impairs understanding — do not flag `x` in a 3-line lambda; do flag `x` in a 50-line algorithm where its role is ambiguous
- If a section has no findings, omit the heading entirely — do not write "None found"
- Approval recommendation must be explicit — do not hedge with "it depends"

## Additional resources

- **`references/review-checklist.md`** — Eight review categories with specific signals to look for. Read this before forming findings.

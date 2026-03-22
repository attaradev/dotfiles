---
name: status-update
description: This skill should be used when the user asks to "write a status update", "draft a stakeholder update", "prepare a weekly update", "write a leadership summary", "draft a cross-team update", "write an engineering update for", or "summarize progress for". Drafts engineering updates that separate confirmed facts from inferences and give the right level of detail for the audience.
disable-model-invocation: true
argument-hint: "[audience and timeframe — e.g. 'engineering leadership, past week']"
---

# Stakeholder Update

Audience and timeframe: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Recent commits — current repo (last 7 days): !`git log --since='7 days ago' --oneline --decorate 2>/dev/null || true`
- Changed files vs main: !`git diff --name-status origin/HEAD...HEAD 2>/dev/null || git diff --name-status HEAD~5...HEAD 2>/dev/null || true`
- Open PRs — current repo: !`gh pr list --state open --limit 10 2>/dev/null || true`
- Recently merged PRs — current repo: !`gh pr list --state merged --limit 10 2>/dev/null || true`
- Recent activity across all repos (last 7 days): !`bash "$HOME/.claude/skills/status-update/scripts/collect-activity.sh" 2>/dev/null || true`

## Task

Read the live context to understand what has actually shipped, what is in progress, and what is blocked. Do not invent progress — only report what is evidenced by the commits, PRs, and changed files.

Produce two versions as specified in `references/update-format.md`. Tailor depth to the stated audience. If the audience is non-technical (exec, product, stakeholders), lead with outcomes and impact — not implementation details. If the audience is engineering, include technical specifics and blockers.

## Quality bar

- Separate confirmed facts (committed, merged, deployed) from inferences (appears to be working toward).
- Keep both versions concise — status updates lose readers when they ramble.
- Flag risks and blockers explicitly; do not bury them.
- Do not pad with generic filler ("the team worked hard on...").

## Additional resources

- **`references/update-format.md`** — Templates and section guidance for both executive and engineering versions.

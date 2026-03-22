---
name: "status-update"
description: "Draft executive and engineering status updates from repository evidence. Use when the user asks for a weekly update, leadership summary, stakeholder update, or progress report."
---

# Stakeholder Update

Use this skill to turn recent commits, PRs, and repository changes into concise status updates for different audiences.

## Workflow

1. Gather the evidence that shows what shipped, what is in progress, and what is blocked. Check recent commits and merged PRs in the current repo.
2. Run `scripts/collect-activity.sh` to collect recent activity across all local repos (scans common roots: `~/code`, `~/projects`, `~/src`, `~/dev`, `~/work`). Use this when the update should cover multiple projects.
3. Separate confirmed facts (committed, merged, deployed) from inferences (appears to be working toward).
4. Use `references/update-format.md` to produce the executive and engineering versions.
5. Tailor the level of detail to the audience.

## Quality rules

- Lead with outcomes for non-technical audiences.
- Include blockers, dependencies, and technical context for engineering audiences.
- Label inferences clearly.
- Keep the update concise and evidence-based.

## Resources

- `scripts/collect-activity.sh` -> collects recent git activity across all local repos
- `references/update-format.md` contains the canonical executive and engineering update templates.

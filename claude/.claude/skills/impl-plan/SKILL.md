---
name: impl-plan
description: This skill should be used when the user asks to "plan this", "build an execution plan", "how should I approach this", "design the implementation", "create a technical plan", "make a plan for", or "turn this into a concrete plan". Builds a staff-quality execution plan from an objective, covering approach trade-offs, phased milestones, and a verification strategy.
disable-model-invocation: true
argument-hint: "[goal or objective]"
---

# Execution Plan

Goal: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Branch: !`git branch --show-current 2>/dev/null || true`
- Status: !`git status --short --branch 2>/dev/null || true`
- Repository structure: !`find . -maxdepth 3 -not -path './.git/*' -not -path './node_modules/*' -not -path './.venv/*' -type f | sort | head -100 2>/dev/null || true`
- Recent commits: !`git log --oneline -n 15 2>/dev/null || true`
- Key manifests: !`ls -1 *.json *.toml *.yaml *.yml Makefile go.mod pyproject.toml package.json 2>/dev/null | head -15 || true`

## Task

Read the live context and understand the existing codebase before planning. Then build the plan using the framework in `references/planning-framework.md`.

## Output format

### Problem statement

Two to four sentences: what the goal is, why it matters, what "done" looks like, and any constraints surfaced from the codebase.

### Approach options

Two or three viable approaches. For each:

**Option N: [Name]**
- Summary: one sentence
- Trade-offs: what you gain and what you give up
- Works well when: conditions where this shines
- Risks: what could go wrong

### Recommended approach

State which option to pursue and why. Be direct — "prefer Option 2 because..." not "it depends."

### Phased execution plan

Break work into phases with clear entry and exit criteria.

**Phase N — [Name]**
- Objective: what this phase achieves
- Steps: ordered list of concrete actions
- Exit criteria: how to know this phase is complete
- Scope: small / medium / large

### Validation and verification

For each phase or milestone: how to verify correctness, rollback strategy if the phase fails, and integration points that need validation.

### Risks and mitigations

Top 3–5 risks with a mitigation or contingency for each. Focus on risks not already addressed in the plan.

### Open questions

Decisions that block progress or materially change the plan. Flag assumptions that need validation before work begins.

## Additional resources

- **`references/planning-framework.md`** — Approach evaluation criteria, scope estimation heuristics, and common planning failure modes.

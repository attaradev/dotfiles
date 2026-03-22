---
name: migration
description: This skill should be used when the user asks to "migration plan for this", "how do we move off X", "re-platform this", "strangler fig for this", "system migration plan", "move from X to Y", "data migration plan", or "how do we cut over". Produces a structured system migration plan covering current state, target state, phases, risks, validation gates, and rollback.
disable-model-invocation: true
argument-hint: "[the system or data to migrate: from X to Y, or describe the current state and target]"
---

# System Migration Plan

Migration: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Existing architecture or migration docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(migration|migrate|cutover|strangler|re-platform)" 2>/dev/null | head -8 || true`
- Infrastructure config: !`find . -maxdepth 4 -name "*.tf" -o -name "docker-compose*.yml" 2>/dev/null | head -10 || true`

## Task

Read the migration scope carefully. Think about what can go wrong at each phase and how to detect it quickly.

Produce a structured migration plan following the framework in `references/migration-framework.md`:

1. **Current state** — what exists today and why it needs to change
2. **Target state** — what success looks like when the migration is complete
3. **Migration strategy** — big bang, phased, strangler fig, or parallel run — with justification
4. **Phases and milestones** — concrete steps with entry and exit criteria
5. **Data migration** — how data moves, validation approach, and acceptable lag
6. **Cutover plan** — the specific sequence of events on go-live day
7. **Rollback plan** — how to reverse the migration at each phase
8. **Risk register** — what can go wrong and the mitigation for each

The rollback plan is not optional. If you cannot roll back, the migration requires a maintenance window.

## Quality bar

- Each phase must have explicit exit criteria — not "when it looks ready" but "when error rate < 0.1% for 24 hours"
- Data migration must address: volume, consistency, cutover lag, and validation method
- Rollback must be tested before the cutover, not planned for the first time during an incident
- The risk register must include at least: data loss, downtime, partial failure, and third-party dependency failure
- Timeline estimates must account for unexpected problems — add 30–50% buffer

## Additional resources

- **`references/migration-framework.md`** — Migration strategies, phase structure, cutover patterns, rollback design, and risk catalogue.

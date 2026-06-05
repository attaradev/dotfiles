## Task

Read `references/migration-framework.md` before writing anything. Then read the migration scope carefully. Think about what can go wrong at each phase and how to detect it quickly.

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

## Anti-patterns

- **Rollback as an afterthought** — writing "revert the changes" without specifying the exact commands, data backfill steps, and time estimate. A rollback plan that cannot be executed in a drill is not a rollback plan.
- **Aspirational exit criteria** — phases that end "when it looks stable" or "when the team is satisfied" instead of specifying a numeric threshold and observation window.
- **Missing decommission gate** — declaring the migration done before the old system has been traffic-free for the required period and a verified data backup has been taken.
- **Big bang default** — recommending a single cutover with no fallback for a system whose cutover will take more than a few hours, without justifying why phased or strangler fig was rejected.
- **Risk register with no owners** — listing risks without an accountable person and a concrete mitigation action (not just "monitor closely").

## Additional resources

- **`references/migration-framework.md`** — Migration strategies, phase structure, cutover patterns, rollback design, and risk catalogue.

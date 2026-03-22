---
name: "migration"
description: "Plan system or data migrations from one state to another. Use when the user asks for a migration plan, cutover plan, strangler fig approach, or rollback strategy."
---

# System Migration Plan

Use this skill to produce a migration plan that makes cutover, rollback, and validation explicit.

## Workflow

1. Read the current and target states before proposing a strategy.
2. Choose big bang, phased, strangler fig, or parallel run based on risk and reversibility.
3. Break the work into phases with entry criteria, exit criteria, and validation.
4. Define data migration, cutover, rollback, and risk mitigation in detail.

## Quality rules

- Every phase needs measurable exit criteria.
- Rollback is required and should be rehearsed.
- Include data consistency, validation, and third-party dependency risk.
- Add buffer to any timeline estimate.

## Resource map

- `references/migration-framework.md` -> migration strategy selection, phase structure, cutover plan, rollback design, and risk register

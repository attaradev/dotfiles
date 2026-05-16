# Planning Framework

Reference material for building and evaluating execution plans.

---

## Approach evaluation criteria

When comparing options, assess each against these dimensions:

**Correctness risk** — How likely is each approach to produce a correct result? Prefer approaches with smaller, verifiable increments over large-bang rewrites.

**Reversibility** — Can you roll back if the approach fails mid-execution? Migrations, schema changes, and public API changes are hard to reverse. Weight reversible approaches higher when uncertainty is high.

**Blast radius** — What is the worst-case impact if this approach goes wrong? Prefer approaches that bound the blast radius to a single service, module, or dataset.

**Build vs. reuse** — Does this approach require building something new, or can it leverage existing infrastructure, libraries, or patterns already in the codebase? Reuse reduces risk and maintenance burden.

**Testability** — Can the intermediate states be tested? An approach that produces testable increments is safer than one that is only correct at completion.

**Team familiarity** — Does the team have experience with the chosen technologies and patterns? Unfamiliar approaches carry a hidden risk multiplier.

---

## Scope estimation heuristics

Use these as anchors, not absolutes. Adjust based on codebase complexity and team velocity.

| Label  | Rough effort | Typical characteristics |
|--------|-------------|------------------------|
| Small  | < 1 day     | Single file, well-understood change, no external dependencies |
| Medium | 1–3 days    | Multiple files or services, some design decisions, tests required |
| Large  | 3–10 days   | Cross-cutting change, new abstractions, migration or protocol change |
| XL     | > 10 days   | Should be decomposed — flag and re-plan as a prerequisite |

When in doubt, scope up one level. Underestimation is more common than overestimation in software planning.

---

## Phase design principles

**Each phase must be independently deployable or at least independently testable.** If a phase cannot be validated in isolation, it is too large.

**Prefer depth-first over breadth-first.** Complete one vertical slice end-to-end before expanding. This surfaces integration problems early.

**Make the first phase the smallest useful unit.** Starting with a narrow but complete implementation builds confidence and creates a concrete baseline.

**Migration phases need a compatibility window.** Any phase that changes a data format, API contract, or configuration schema should include a period where both old and new are supported simultaneously.

---

## Common planning failure modes

**Skipping the constraints step.** Plans that don't enumerate constraints (timeline, backward compatibility, infrastructure limits) drift into scope creep or hit hard walls mid-execution.

**No rollback strategy.** Every phase that modifies production state (data, config, deployed services) must have a defined rollback path. "We'll figure it out if it breaks" is not a strategy.

**Phases that are too large.** A phase with more than 5–7 steps or that touches more than 3–4 distinct components is likely too large. Decompose further.

**Missing integration checkpoints.** Plans that defer integration testing to the final phase will discover integration problems too late to change course cheaply.

**Underspecified success criteria.** "It works" is not a valid exit criterion. Each phase should have measurable, observable outcomes.

**Optimism about dependencies.** If your plan depends on a third party (team, API, service) delivering something on time, add a risk entry and a mitigation that does not require them.

---

## Verification checklist

Before presenting a plan, confirm:

- [ ] Each phase has a clear, observable exit criterion
- [ ] A rollback strategy exists for any phase that modifies production state
- [ ] The recommended approach is chosen for stated, explicit reasons
- [ ] The top risks are listed with mitigations
- [ ] Open questions are specific enough to be resolvable (not "we need to think about this")
- [ ] No phase is scoped at XL without a note to decompose it

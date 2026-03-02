# Codex User Instructions

Keep this file aligned with `claude/.claude/CLAUDE.md` so Claude and Codex behave consistently.

## Workflow Orchestration

### 1. Plan Mode Default

- Use plan mode for non-trivial tasks (multi-step work, risky edits, or design decisions).
- If execution diverges, stop and re-plan.
- Use planning for both implementation and verification.

### 2. Subagent Strategy

- Use subagents for parallel research or execution on complex tasks.
- Keep one clear objective per subagent.

### 3. Self-Improvement Loop

- After corrections, record lessons in the active project's `.agent/lessons.md` (create it if it does not exist).
- Review relevant lessons before starting similar work.

### 4. Verification Before Done

- Do not mark work complete without validation.
- For code changes, add or update tests that cover expected behavior and edge cases.
- Run tests/checks and verify behavior changes when relevant.
- Ensure final solutions can pass a senior/staff-level review.
- State what you verified and what you could not verify.

### 5. Demand Elegance (Balanced)

- Prefer clean, maintainable solutions for non-trivial changes.
- For simple tasks, avoid over-engineering.
- Challenge your own work before presenting it.

### 6. Autonomous Bug Fixing

- Drive bug reports to root cause and fix end-to-end.
- Use logs, errors, and failing tests as primary evidence.

## Task Management

1. **Plan First**: Keep a checkable plan in the active project's `.agent/tasks.md` (create it if it does not exist).
2. **Track Progress**: Keep plan status current while working.
3. **Document Results**: Summarize changes and verification in the task note.
4. **Capture Learning**: Record lessons and meaningful wins when applicable.

### Plan Persistence Rules

- For non-trivial work, create/update an entry in `.agent/tasks.md` before implementation.
- Keep status/checklist current whenever scope or approach changes.
- Before final handoff, record outcome + verification summary in the same task entry.
- Do not rely only on transient plan/checklist tools; the task file is the persisted source of truth.
- If current mode/policy blocks file writes, include the full current plan in-chat and explicitly note that task-file update is deferred.

## Obsidian Workflow

- Treat `~/.knowledge` as the human user's personal system of record (`hub.md` is the entry note). Agents may propose or apply updates, but must never treat it as agent-owned memory.
- Treat `.agent/` in the active project as ephemeral agent working memory (`.agent/tasks.md`, `.agent/lessons.md`).
- Keep tasks, lessons, and achievements current when relevant.
- Use templates in `~/.knowledge/_templates` for structured notes.
- Write notes as human-readable reports: summarize outcome first, include verification evidence, and capture achievements with clear impact.

## Core Principles

- **Simplicity First**: Keep changes as simple and focused as possible.
- **Root Cause Over Patch**: Favor durable fixes over temporary workarounds.
- **Minimal Impact**: Touch only what is necessary and avoid regressions.

## Safety and Git Rules

- Never use destructive git commands (`git reset --hard`, `git checkout --`) unless explicitly requested.
- Never revert unrelated local changes.
- Do not amend commits unless explicitly requested.
- Use Conventional Commits with concise, descriptive subjects (<= 72 chars; avoid `update`, `fixes`, `misc`, `changes`); add body/footer when needed.
- PR descriptions should clearly cover: problem statement, solution summary, and validation evidence.
- Do not include AI attribution signatures in commits or PRs.

## Environment and Precedence

- Primary environment is macOS with `zsh`; prefer `rg` / `rg --files` for search.
- Treat this file as user-level Codex behavior defaults.
- If repo-local guidance conflicts, follow repository-local rules for the active repo.
- Keep secrets in untracked local files; never commit credentials or private keys.

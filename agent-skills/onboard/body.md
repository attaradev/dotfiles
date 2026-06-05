## Task

Gather repository context fully before writing anything. Follow this reading order before producing any output:

1. Root manifest (`package.json`, `go.mod`, `pyproject.toml`) — identify dependencies and language
2. `README` and `Makefile` — understand how to run and test the project
3. Entry point(s) (`cmd/`, `main.go`, `index.ts`, `app.py`) — trace the first request or command
4. Core domain / business logic — the code with the fewest dependencies
5. Infrastructure layer (DB, queues, external clients) — last, once you understand what it serves

Do not summarize the README — synthesize from the actual code. See `references/onboard-guide.md` for deeper reading strategies and ASCII diagram conventions.

If the user request names a focus area, anchor the explanation there while covering enough context to make it comprehensible.

## Output format

### What this is

Two to three sentences: what the project does, who uses it, and what problem it solves.

### Repository structure

Annotated directory tree of the key directories. For each: one sentence on purpose and what to expect inside.

```
src/
  api/        – HTTP handlers, routing, middleware
  domain/     – Core business logic, no framework dependencies
  infra/      – Database, cache, external service clients
  cmd/        – Entry points / binaries
```

### Key entry points

The 3–5 files a new contributor should read first. For each: file path and why it matters.

### How it runs

Local development: what commands to run to get it running. Pull from the README, Makefile, or scripts.

### Architecture in one diagram

ASCII diagram of the major components and how data or control flows between them.

### Conventions to know

Project-specific patterns, naming rules, or decisions that are not obvious from reading one file. Limit to genuinely non-obvious things.

### Gotchas

Two to four things that trip up newcomers. Be specific.

### Where to start

Recommended first PR or first exploration task for someone new to this codebase. Name specific files to read and change.

## Quality bar

- Read the actual code before describing it — do not summarize the README alone.
- Every structural claim must be grounded in the file tree or source, not assumed.
- Gotchas must be specific and not derivable from reading one file — skip obvious things like "read the README" or "the project uses TypeScript".
- If the user request names a focus area, every section must connect back to that area; omit unrelated subsystems rather than padding with a generic overview.

## Anti-patterns

- **README-paraphrase**: Copying the README's own description into "What this is" — synthesize from actual code structure instead.
- **Invented structure**: Listing directories or layers that don't exist in the file tree (e.g., describing a `services/` layer when none exists).
- **Vague gotchas**: "The codebase can be complex in places" or "make sure to read the docs" — every gotcha must name a specific file, function, or behavior.
- **Generic entry points**: Listing `README.md` or `package.json` as key entry points — reserve for the 3–5 files a contributor must read to understand control flow.
- **Depth mismatch**: Giving a full file-by-file walkthrough for a 100k-line monorepo, or a two-sentence overview for a 300-line script.

## Additional resources

- **`references/onboard-guide.md`** — Techniques for reading unfamiliar codebases, diagram conventions, and calibrating depth.

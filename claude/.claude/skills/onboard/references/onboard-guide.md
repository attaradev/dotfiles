# Codebase Onboarding Guide

## How to read an unfamiliar codebase

Work outside-in: start at the edges (entry points, CLI, main, index) and work toward the core. Do not start in the middle.

**Reading order for most projects:**
1. Root-level manifest (`package.json`, `go.mod`, `pyproject.toml`) — understand dependencies and tooling
2. `README` / `Makefile` — understand how to run and test it
3. Entry point(s) (`cmd/`, `main.go`, `index.ts`, `app.py`) — trace the first request or command
4. Core domain / business logic — the code with the fewest dependencies
5. Infrastructure layer (DB, queues, external clients) — last, once you understand what it serves

---

## Identifying key entry points

| Pattern | Where to look |
|---------|--------------|
| HTTP server | Router registration, middleware chain, handler files |
| CLI tool | `cmd/` directory, cobra/click command definitions |
| Background worker | Queue consumers, cron definitions, event handlers |
| Library | Exported public API surface (`index.ts`, `pkg/`, `__init__.py`) |
| Data pipeline | Source readers, transforms, sink writers |

---

## ASCII diagram conventions

Keep diagrams scannable. Use consistent symbols:

```
Component A  ──── calls ────▶  Component B
     │                              │
     │ reads                        │ writes
     ▼                              ▼
  Store A                        Store B

Actor ──── HTTP ────▶  API ──── SQL ────▶  DB
                        │
                        └──── publishes ──▶  Queue
                                                │
                                        consumes│
                                                ▼
                                           Worker
```

- Use `──▶` for unidirectional flow
- Use `◀──▶` for bidirectional
- Label arrows with the mechanism (HTTP, SQL, gRPC, event, etc.)
- Keep to ≤ 80 chars wide

---

## Calibrating depth

| Codebase size | What to cover |
|---------------|--------------|
| < 5k lines | Full walkthrough, all major files |
| 5k–50k lines | Entry points, domain layer, one end-to-end request trace |
| > 50k lines | Architecture overview, subsystem map, delegate deep-dives to focused `/explain-code` |

If `$ARGUMENTS` names a focus area, go deep on that subsystem and shallow on everything else.

---

## What makes a good Gotchas section

A gotcha is a thing that trips people up and is **not obvious from reading one file**. Examples of good gotchas:
- "The `User` model has two IDs — `id` (internal DB key) and `external_id` (shown to clients). Mixing them up causes silent auth failures."
- "Tests run against a real database seeded by `testdata/seed.sql`. Truncating tables in one test will break tests run after it."
- "The `config` package reads from env vars at import time — tests that set env vars after import won't work."

Examples of bad gotchas (too obvious or too vague):
- "Make sure to read the README before contributing."
- "The codebase uses TypeScript."

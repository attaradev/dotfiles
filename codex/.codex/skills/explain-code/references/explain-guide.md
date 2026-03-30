# Code Explanation Guide

## Constructing analogies

A good analogy anchors unfamiliar code in something the reader already knows. It should be:
- **Concrete**: "it's like a post office sorting room" not "it's like a manager"
- **Accurate enough**: the analogy should hold for the key behavior, even if imperfect at the edges
- **Scoped**: one analogy per explanation — stacking analogies creates confusion

**Pattern**: "[Component] works like [familiar thing] — [key behavioral similarity]."

**Good**: "The middleware chain works like airport security checkpoints — each layer can inspect the request and either pass it forward or reject it, but they run in a fixed order."

**Bad**: "It's like a pipeline but also like a chain of responsibility pattern."

---

## ASCII diagram types

Choose the diagram type that matches what you're explaining:

### Control flow (who calls whom)
```
Caller
  │
  ▼
HandlerA  ──── delegates ────▶  ServiceB
                                    │
                                    ▼
                               Repository
```

### Data flow (what data moves where)
```
HTTP Request
    │ JSON body
    ▼
Parser ──── validated struct ────▶  Domain Logic
                                         │ persisted event
                                         ▼
                                      EventStore
```

### State machine (how state transitions)
```
[pending] ──── approve ────▶ [approved] ──── ship ────▶ [shipped]
    │                                                        │
    └──── reject ────▶ [rejected]          complete ────▶ [done]
```

Keep diagrams to ≤ 80 chars wide and ≤ 20 lines tall. Label every arrow.

---

## Calibrating explanation depth

| Target | Depth |
|--------|-------|
| Single function (< 30 lines) | Line-by-line walkthrough, focus on non-obvious parts |
| Single file (< 200 lines) | Section-by-section, one diagram |
| Module or package | Entry points + data flow, skip implementation details |
| Subsystem / architecture | Component map + one end-to-end trace, delegate file details |

---

## Step-by-step walkthrough format

Anchor each step to a file and line range:

> **Step 1** (`auth/middleware.go:14–32`): The middleware extracts the JWT from the `Authorization` header. If missing or malformed, it immediately returns 401 without calling the next handler.

Explain *why* each step exists, not just what it does. "Why" answers usually come from the surrounding system — "this check happens here so that no handler ever receives an unauthenticated request."

---

## Common gotcha categories

Things worth highlighting as misconceptions:
- **Naming traps**: identifiers that imply one thing but do another (`SaveUser` that also sends an email)
- **Implicit ordering**: code that must run in a specific order with no enforcement
- **Hidden coupling**: code that looks decoupled but shares global state or env vars
- **Silent failures**: errors that are swallowed or logged but not returned
- **Thread safety**: code that is safe in tests (single-threaded) but not in production

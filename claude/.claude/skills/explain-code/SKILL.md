---
name: explain-code
description: This skill should be used when the user asks to "explain this code", "how does this work", "walk me through this", "explain this file", "I don't understand this", "how does X work in this codebase", or needs onboarding to an unfamiliar code path or architecture. Explains code with plain-language analogies, ASCII diagrams, and step-by-step flow breakdowns.
argument-hint: "[file, function, or module to explain]"
---

# Explain Code

Target: $ARGUMENTS

## Live context

Read the target before explaining. If `$ARGUMENTS` is a file path, read it directly. If it names a function or concept, search for it first.

- Working directory: !`pwd`
- Target exists as file: !`[ -f "$ARGUMENTS" ] && echo "yes — reading below" || echo "no — search for it"`
- File content: !`[ -f "$ARGUMENTS" ] && cat "$ARGUMENTS" 2>/dev/null | head -300 || true`
- Related files (if target is a directory or concept): !`[ -d "$ARGUMENTS" ] && find "$ARGUMENTS" -type f | head -30 2>/dev/null || true`

## Task

Read the target completely before writing anything. Understand it from first principles before explaining.

## Output format

### Analogy

One short paragraph anchoring the code in a real-world concept the reader already understands. Be concrete, not vague ("it's like a post office sorting room" not "it's like a manager").

### Architecture or flow diagram

ASCII diagram of the control flow, data flow, or component relationships. Label the key actors and the direction of data or control. Keep it scannable.

```
Example shape (adapt as needed):
  Caller
    │
    ▼
  FunctionA  ──── reads ────▶  Store
    │                            │
    ▼                            ▼
  FunctionB  ◀─── returns ──  Result
```

### Step-by-step walkthrough

Walk through the code path in order. Anchor each step to a specific file and line range. Explain *why* each step exists, not just what it does.

### Gotcha or misconception

One thing that trips people up — a subtle assumption, a surprising behavior, or a naming choice that misleads. Be specific.

### What to read next

Three to five files or functions most useful for deepening understanding. Format as `path/to/file.ext` or `FunctionName` with a one-line reason each.

## Quality bar

- Anchor every claim in the actual code, not generic patterns.
- Favor clarity over completeness — one clear explanation beats five partial ones.
- Scale depth to the target: a 20-line utility needs less than a 500-line subsystem.
- If the target is unclear or not found, say so and ask for clarification rather than guessing.

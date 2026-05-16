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

Three to five files or functions most useful for deepening understanding. Format as `path/to/file.ext` or `FunctionName` with a one-line reason each. Label each as **prerequisite** (must read before this makes sense) or **follow-up** (deepens understanding of this code's context or callers).

## Quality bar

- Anchor every claim in the actual code, not generic patterns.
- Favor clarity over completeness — one clear explanation beats five partial ones.
- Scale depth to the target: ≤50 lines → one short paragraph per section; 50–300 lines → step-by-step walkthrough with inline callouts; 300+ lines → include ASCII flow diagrams.
- If the target is unclear or not found, say so and ask for clarification rather than guessing.

## Additional resources

- **`references/explain-guide.md`** — Guidance on constructing analogies, ASCII diagrams, and calibrating explanation depth.

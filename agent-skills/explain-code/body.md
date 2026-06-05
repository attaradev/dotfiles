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

- Anchor every claim in the actual code: cite the file and line range, not a generic pattern name.
- Each explanation section must add information the code itself doesn't state — if the section only restates what is already visible, cut it.
- Scale depth to the target: <30 lines → line-by-line walkthrough, focus on non-obvious parts; 30–200 lines → section-by-section with one diagram; 200+ lines → entry points + data flow, delegate implementation details to "What to read next".
- If the target is unclear or not found, say so and ask for clarification rather than guessing.

## Anti-patterns

- **Paraphrase without insight**: restating what the code does line-by-line without explaining *why* — e.g., "line 14 calls authenticate(), line 15 checks the result" with no explanation of the design intent.
- **Generic analogy**: using an analogy that fits any code ("it's like a pipeline", "it's like a manager") rather than the specific behavior of this code.
- **Diagram without labels**: an ASCII diagram with unlabeled arrows or actors — every arrow and box must say what it represents.
- **Floating gotcha**: a "gotcha" that isn't anchored to a specific line or behavior in the actual target — e.g., "be careful with concurrency" when the code has no goroutines.
- **Shallow "what to read next"**: listing files without a one-line reason and a prerequisite/follow-up label.

## Additional resources

- **`references/explain-guide.md`** — Guidance on constructing analogies, ASCII diagrams, and calibrating explanation depth.

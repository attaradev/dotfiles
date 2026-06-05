## Task

Read `references/perf-playbook.md` in full before writing anything. Then read the target description and any existing code.

Follow the investigation process in `references/perf-playbook.md`:

1. **Define the problem** — what is slow, by how much, and what does acceptable look like?
2. **Establish a baseline** — reproduce the slowness with a benchmark or profiler before changing anything. If no profiler output or benchmark exists, produce a baseline first — do not recommend optimisations without measurement
3. **Identify the bottleneck** — CPU, memory, I/O, network, lock contention, or algorithmic complexity
4. **Form a hypothesis** — state as "X is slow because Y (evidence Z)", not "might be related to Z"
5. **Apply the fix** — the smallest change that addresses the bottleneck
6. **Measure the improvement** — confirm the fix actually helped; quantify the gain

Do not optimise without measuring. If no profiling output or benchmark exists yet, establish the baseline as the first deliverable — produce it before suggesting any fix.

## Quality bar

- Every proposed fix must be validated by a measurement, not an assumption
- State the baseline and the improved number explicitly: "p99 dropped from 450ms to 38ms"
- Identify only the actual bottleneck — do not "optimise" code that is not in the hot path
- If the fix introduces a trade-off (more memory for less CPU, more complexity for less latency), state it
- Write or update a benchmark so the regression is detectable in the future

## Output format

Produce a structured response with these sections (omit sections that don't apply):

1. **Baseline** — the before measurement (metric, method, numbers)
2. **Bottleneck** — identified type (CPU / memory / I/O / DB / algorithmic) and evidence
3. **Hypothesis** — "X is slow because Y (evidence Z)"
4. **Fix** — code change(s) with explanation
5. **Measurement** — before/after table (use the template in the playbook's Step 5)
6. **Trade-offs** — any regressions introduced (memory, complexity, correctness)
7. **Benchmark** — new or updated benchmark to prevent future regression

## Anti-patterns

Avoid these output-level mistakes:

- Recommending a fix before showing a baseline measurement
- Listing multiple speculative optimisations without identifying which is the actual bottleneck
- Stating improvement as a percentage only ("50% faster") — always include raw numbers ("120ms → 60ms")
- Optimising code that is not in the measured hot path
- Omitting the trade-off when a fix increases memory or code complexity

## Additional resources

- **`references/perf-playbook.md`** — Bottleneck taxonomy, profiling tools by language, benchmarking patterns, and common performance anti-patterns.

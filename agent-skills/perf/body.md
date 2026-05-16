## Task

Read the target description and any existing code carefully. Do not guess — measure first.

Follow the investigation process in `references/perf-playbook.md`:

1. **Define the problem** — what is slow, by how much, and what does acceptable look like?
2. **Establish a baseline** — reproduce the slowness with a benchmark or profiler before changing anything. If no profiler output or benchmark exists, produce a baseline first — do not recommend optimisations without measurement
3. **Identify the bottleneck** — CPU, memory, I/O, network, lock contention, or algorithmic complexity
4. **Form a hypothesis** — where specifically is the time being spent?
5. **Apply the fix** — the smallest change that addresses the bottleneck
6. **Measure the improvement** — confirm the fix actually helped; quantify the gain

Do not optimise without measuring. The bottleneck is almost never where you expect it.

## Quality bar

- Every proposed fix must be validated by a measurement, not an assumption
- State the baseline and the improved number explicitly: "p99 dropped from 450ms to 38ms"
- Identify only the actual bottleneck — do not "optimise" code that is not in the hot path
- If the fix introduces a trade-off (more memory for less CPU, more complexity for less latency), state it
- Write or update a benchmark so the regression is detectable in the future

## Additional resources

- **`references/perf-playbook.md`** — Bottleneck taxonomy, profiling tools by language, algorithmic complexity guide, and common performance anti-patterns.

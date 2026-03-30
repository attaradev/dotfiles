---
name: perf
description: This skill should be used when the user asks to "why is this slow", "profile this", "performance analysis", "find the bottleneck", "this is too slow", "optimise the performance", "latency investigation", or "throughput analysis". Systematically investigates performance problems through measurement, bottleneck identification, and targeted fixes.
argument-hint: "[the slow code path, endpoint, or operation to investigate]"
---

# Performance Investigation

Target: $ARGUMENTS

## Live context

- Working directory: !`pwd`
- Language/framework: !`ls go.mod package.json pyproject.toml Cargo.toml pom.xml 2>/dev/null | head -3 || true`
- Relevant source files: !`find . -maxdepth 5 -type f | xargs grep -l -iE "(slow|timeout|latency|benchmark|profile|perf)" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -8 || true`
- Benchmark files: !`find . -maxdepth 5 -type f \( -name "*bench*" -o -name "*perf*" -o -name "*load*" \) 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Recent profiling output: !`find . -maxdepth 3 \( -name "*.prof" -o -name "*.pprof" -o -name "flamegraph*" -o -name "*.cpuprofile" \) 2>/dev/null | head -5 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Task

Read the target description and any existing code carefully. Do not guess — measure first.

Follow the investigation process in `references/perf-playbook.md`:

1. **Define the problem** — what is slow, by how much, and what does acceptable look like?
2. **Establish a baseline** — reproduce the slowness with a benchmark or profiler before changing anything
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

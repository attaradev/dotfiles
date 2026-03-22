---
name: "perf"
description: "Investigate performance problems through measurement, profiling, and targeted fixes. Use when the user asks why something is slow, for profiling help, or for throughput and latency analysis."
---

# Performance Investigation

Use this skill to measure the slowdown, find the bottleneck, and verify the improvement.

## Workflow

1. Identify the language from project files (go.mod, package.json, pyproject.toml, Cargo.toml, etc.) — this determines which profiling tools to use.
2. Define the problem precisely with a metric and target.
3. Establish a baseline before changing anything.
4. Identify the bottleneck and form a falsifiable hypothesis.
5. Apply the smallest fix that addresses the bottleneck.
6. Measure the result and report the improvement.

## Quality rules

- Never optimise without a before measurement.
- State the baseline and the improved number explicitly.
- Fix only the hot path, not unrelated code.
- Update or add a benchmark so the regression is detectable later.

## Resource map

- `references/perf-playbook.md` -> profiling tools, bottleneck taxonomy, anti-patterns, and measurement guidance

## Live context

- Working directory: !`pwd`
- Language/framework: !`ls go.mod package.json pyproject.toml Cargo.toml pom.xml 2>/dev/null | head -3 || true`
- Benchmark and profiling artifacts: !`find . -maxdepth 5 \( -name "*bench*" -o -name "*perf*" -o -name "*load*" -o -name "*.prof" -o -name "*.pprof" -o -name "flamegraph*" -o -name "*.cpuprofile" \) 2>/dev/null | grep -vE "(node_modules|vendor)" | head -10 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

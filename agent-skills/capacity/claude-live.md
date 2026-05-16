## Live context

- Working directory: !`pwd`
- Infrastructure / config files: !`find . -maxdepth 4 -type f \( -name "*.tf" -o -name "*.yaml" -o -name "*.yml" \) | xargs grep -l -iE "(cpu|memory|replica|instance|node|limit|request)" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -10 || true`
- Existing capacity or scaling docs: !`find . -maxdepth 4 -type f -name "*.md" | xargs grep -l -iE "(capacity|scaling|throughput|bottleneck|headroom)" 2>/dev/null | head -8 || true`

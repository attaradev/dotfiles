## Live context

- Working directory: !`pwd`
- Manifests found: !`find . -maxdepth 6 \( -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | grep -vE "(node_modules|\.git|Chart\.yaml)" | head -10 || true`
- Helm charts: !`find . -maxdepth 4 -name "Chart.yaml" 2>/dev/null | head -5 || true`
- Kustomize: !`find . -maxdepth 4 -name "kustomization.yaml" 2>/dev/null | head -5 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

## Detected Deployment Configuration

!`{ find . \( -name "Dockerfile" -o -name "docker-compose*.yml" -o -name "docker-compose*.yaml" \) -not -path "*/.git/*" 2>/dev/null; find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null; find . \( -name "*.argocd.yaml" -o -name "application.yaml" \) -path "*/argocd/*" -not -path "*/.git/*" 2>/dev/null; } | head -15 | sed 's|^\./||' || echo "none"`

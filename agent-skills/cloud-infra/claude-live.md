## Detected Infrastructure Configuration

!`{ find . -name "*.tf" -not -path "*/.git/*" -not -path "*/.terraform/*" 2>/dev/null | head -5; find . \( -path "*/argocd/*" -o -path "*/kargo/*" \) \( -name "*.yaml" -o -name "*.yml" \) -not -path "*/.git/*" 2>/dev/null | head -5; find .github/workflows -name "*.yml" 2>/dev/null | head -3; } | sed 's|^\./||' || echo "none"`

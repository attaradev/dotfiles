## Frontend Files Detected

!`find . \( -name "*.html" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.vue" -o -name "*.svelte" -o -name "*.css" -o -name "*.scss" \) -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | head -15 | sed 's|^\./||' || echo "none"`

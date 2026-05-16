## Live context

- Working directory: !`pwd`
- Existing flags: !`grep -r -iE "(feature.?flag|feature.?toggle|is_enabled|flag\.|LaunchDarkly|unleash|flipt|posthog\.isFeatureEnabled)" . --include="*.go" --include="*.ts" --include="*.py" --include="*.rb" --include="*.js" 2>/dev/null | grep -vE "(node_modules|vendor|\.git)" | head -15 || true`
- Flag config files: !`find . -maxdepth 4 -name "flags.*" -o -name "features.*" -o -name "toggles.*" 2>/dev/null | grep -vE "(node_modules|vendor)" | head -8 || true`
- Current branch: !`git branch --show-current 2>/dev/null || true`

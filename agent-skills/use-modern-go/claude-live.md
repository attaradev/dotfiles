## Detected Go Version

!`grep -rh "^go " --include="go.mod" . 2>/dev/null | cut -d' ' -f2 | sort | uniq -c | sort -nr | head -1 | xargs | cut -d' ' -f2 | grep . || echo unknown`

## How to Use This Skill

DO NOT search for go.mod files or try to detect the version yourself. Use ONLY the version shown above.

**If version detected (not "unknown"):**
- Say: "This project is using Go X.XX, so I'll stick to modern Go best practices and freely use language features up to and including this version. If you'd prefer a different target version, just let me know."
- Do NOT list features, do NOT ask for confirmation

**If version is "unknown":**
- Say: "Could not detect Go version in this repository"
- Use AskUserQuestion: "Which Go version should I target?" → [1.23] / [1.24] / [1.25] / [1.26]

## Live context

- Last tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "(no tags)"`
- Current CHANGELOG (first 60 lines): !`head -60 CHANGELOG.md 2>/dev/null || head -60 CHANGES.md 2>/dev/null || echo "(no CHANGELOG found)"`
- Today's date: !`date +%Y-%m-%d`

Run the collector via the Bash tool before writing:

```
bash "$HOME/.claude/skills/changelog/scripts/collect-changes.sh" 2>&1
```

## Live context

- Today's date: !`date +%Y-%m-%d`

After resolving the since/until dates from the user's request, run the collector via the Bash tool:

```
bash "$HOME/.claude/skills/achievements/scripts/collect-achievements.sh" "<since>" "<until>" 2>&1
```

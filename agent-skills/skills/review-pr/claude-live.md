## Live context

Run the context collector via Bash tool before forming any opinion:

```
bash "$HOME/.claude/skills/review-pr/scripts/collect-pr-context.sh" "$ARGUMENTS" 2>&1
```

If the script is unavailable, fall back to: `gh pr view $ARGUMENTS` and `gh pr diff $ARGUMENTS`.

If the diff is large and key files are referenced without full context, read them directly with the Read tool.

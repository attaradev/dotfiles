## Live context

- Current branch / recent work: !`git log --oneline --since="2 weeks ago" 2>/dev/null | head -20 || true`
- Recent commits summary: !`git log --format="%s" --since="2 weeks ago" 2>/dev/null | head -30 || true`
- Open issues or recent incidents: !`gh issue list --state open --limit 10 2>/dev/null || true`
- Prior retro notes or action items: !`find . -maxdepth 3 \( -iname "*retro*" -o -iname "*action*items*" \) 2>/dev/null | head -5 || true`

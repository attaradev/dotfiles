# Customization

## Private Local Files (Not Committed)

Use local override files for secrets and machine-specific settings:

- `~/.zshrc.local`
- `~/.zshrc.local.d/*.zsh`
- `~/.bashrc.local`
- `~/.gitconfig.local`
- `~/.npmrc.local`
- `~/.ssh/config.local`
- `~/.ssh/config.local.d/*.conf`

These overrides are optional: they load when present and are skipped when missing.

## Add or Remove Packages

Edit `Brewfile`, then apply:

```bash
make brew
```

If you change installed tools directly and want to sync the file:

```bash
make dump
```

## Adjust Language Runtime Versions

Edit `~/.mise.toml` and re-run:

```bash
make mise
```

Examples:

- Keep Node.js in major line 25: `node = "25"`
- Keep Python on 3.14 patch stream: `python = "3.14"`
- Keep Go on 1.26 patch stream: `go = "1.26"`
- Keep Ruby on 4.0 patch stream: `ruby = "4.0"`
- Add Java when needed on LTS major line 21: `java = "21"`
- Add Rust when needed on 1.93 patch stream: `rust = "1.93"`
- Keep npm in major line 11: `npm = "11"`
- Keep pnpm in major line 10: `pnpm = "10"`
- Keep uv on 0.10 patch stream: `uv = "0.10"`

After changes, verify:

```bash
make mise
mise list
```

To remove a runtime/tool you previously added:

```bash
# 1) Delete its entry from ~/.mise.toml
make mise
mise uninstall --all <tool>
mise prune --tools
mise list
```

See [RUNTIMES.md](RUNTIMES.md) for runtime policies and update workflows.

## Git Identity and Signing

`setup.sh` writes identity and signing behavior to `~/.gitconfig.local`.

- Set `user.name` and `user.email` for your machine.
- Set `user.signingkey` to enable signing.
- Leave signing key empty to keep signing disabled.
- This repository includes personal fallback defaults in `setup.sh`; for your fork, set `DEFAULT_GIT_*` or pass `GIT_USER_*` env vars.
- `make gnupg` materializes machine-local `~/.gnupg/gpg-agent.conf` and `~/.gnupg/gpg.conf` with `pinentry-mac`.
- `make stow` preserves those local GPG config files (it skips re-stowing the `gpg` package when local files are present).

## Shell Aliases and Prompt

Main shell config lives at `zsh/.zshrc`.

Notable defaults:

- `l`, `ll`, `la` use `eza`
- `cat` is aliased to `bat`
- `z` uses `zoxide`
- prompt configured in `starship/.config/starship.toml`

## Claude and Codex Context

Global Claude Code context/settings are tracked at `claude/.claude/CLAUDE.md` and `claude/.claude/settings.json`, then symlinked to `~/.claude/` by stow.
`claude/.claude/settings.json` includes Obsidian-oriented hooks (session start, pre-compact, session end, task completion, and note-write detection) backed by `scripts/claude-obsidian-hook.py`.
Hook context resolves task planning files to the active project (`tasks/todo.md` and `tasks/lessons.md`) and auto-creates them when missing (repo root when available, otherwise the current workspace).
Achievement candidates are intentionally low-noise: prefix Claude task-complete labels or Codex prompts with `achievement:`, `win:`, `impact:`, or `[achievement]` to capture only meaningful wins into `~/.knowledge/career/achievement-inbox.md`.
Codex achievement capture is explicit-only: the marker must be in the latest user prompt, and duplicate candidates for the same source are ignored.
Claude/Codex activity logs are local runtime artifacts (not tracked in git) and auto-create on first hook event.
Codex CLI defaults/notifications are tracked at `codex/.codex/config.toml`, then symlinked to `~/.codex/config.toml` by stow.
`codex/.codex/config.toml` uses Codex `notify` to call `scripts/claude-obsidian-hook.py codex-notify`, which appends human-readable turn reports to Obsidian.
Codex user behavior instructions are tracked at `codex/.codex/AGENTS.md`, symlinked to `~/.codex/AGENTS.md`, and referenced by `instructions_file` in `~/.codex/config.toml`.
`~/.codex/AGENTS.md` mirrors `claude/.claude/CLAUDE.md` so both agents follow the same workflow expectations.
Public Obsidian scaffold files are tracked in `obsidian/.knowledge/` (hub, plugin note, templates). Personal vault content stays local in `~/.knowledge` and is not tracked in git.

Obsidian vault files:

Project execution files are localized to each project (`tasks/todo.md`, `tasks/lessons.md`); the files below are vault-wide references and trackers.

- `~/.knowledge/hub.md`
- `~/.knowledge/setup/obsidian-plugins.md`
- `~/.knowledge/tasks.md`
- `~/.knowledge/projects/projects.md`
- `~/.knowledge/reading/books.md`
- `~/.knowledge/reading/articles.md`
- `~/.knowledge/learning/courses.md`
- `~/.knowledge/learning/studies.md`
- `~/.knowledge/learning/lessons.md`
- `~/.knowledge/career/achievement-inbox.md`
- `~/.knowledge/career/achievement-log.md`
- `~/.knowledge/_templates/*.md`

Auto-generated local-only files:

- `~/.knowledge/setup/claude-activity-log.md`
- `~/.knowledge/setup/codex-activity-log.md`

Initialize missing local vault files with:

```bash
make obsidian
```

Configure Obsidian plugin defaults and install the recommended community plugins with:

```bash
make obsidian
```

`make obsidian` is safe to rerun. It can repair a degraded workspace layout (for example, if Obsidian opens with empty tabs and no Files pane) by resetting to a `hub.md` + File Explorer default.
It also creates a visible `~/Knowledge` alias (if available) and registers the vault in Obsidian app config so it shows in the UI picker.
Reruns also skip re-downloading community plugins that are already installed.

Skip community plugin installation for constrained environments with:

```bash
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh
```

Skip community plugin asset downloads while preserving plugin JSON settings with:

```bash
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 ./scripts/setup-obsidian.sh
```

Re-check and re-apply versions pinned in `obsidian/community-plugin-lock.json` with:

```bash
DOTFILES_OBSIDIAN_UPDATE_PLUGINS=1 make obsidian
```

Refresh plugin versions safely by regenerating the lock file, reviewing diffs, then applying:

```bash
make obsidian-lock
# review obsidian/community-plugin-lock.json
make obsidian
```

If lock refresh hits GitHub API limits, set `GITHUB_TOKEN_FILE` to a local file
containing a token before running `make obsidian-lock`.

## Add a New Stow Package

1. Create a package directory in repo root (example: `tmux/`).
2. Place files using home-relative layout (example: `tmux/.tmux.conf`).
3. Add package name in `scripts/setup-stow.sh` `PACKAGES` array.
4. Run:

```bash
make stow
```

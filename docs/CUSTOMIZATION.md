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

If a change is personal, secret, or machine-specific, put it in the matching
local override file instead of editing the tracked dotfile directly.

Common mappings:

- Git identity, signing, or credential rewrites: `~/.gitconfig.local`
- Shell aliases, exports, PATH tweaks, and one-off functions: `~/.zshrc.local` or `~/.zshrc.local.d/*.zsh`
- npm tokens and registry auth: `~/.npmrc.local`
- SSH host overrides, identities, and host-specific options: `~/.ssh/config.local` or `~/.ssh/config.local.d/*.conf`

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

- Keep Node.js on a single major line, e.g. `node = "<major>"`.
- Keep Python on a major/minor line, e.g. `python = "<major.minor>"`.
- Keep Go, Ruby, pnpm, npm, and uv pinned to their chosen patch/minor lines via `<major.minor>` strings.
- Add new runtimes such as Java or Rust by declaring their tracks (e.g. `java = "<major>"`, `rust = "<major.minor>"`).

See [RUNTIMES.md](RUNTIMES.md) for the tracked defaults that ship with the repo.

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

It is organized into sections for Homebrew bootstrap, completions, `mise`,
plugin loading, reusable shell functions, aliases, environment variables,
security defaults, and local overrides.

Keep machine-specific shell changes in `~/.zshrc.local` or
`~/.zshrc.local.d/*.zsh` so the tracked `zsh/.zshrc` remains portable.

Notable defaults:

- `l`, `ll`, `la` use `eza`
- `cat` is aliased to `bat`
- `z` uses `zoxide`
- `brewup` is a shell function for Homebrew-only upgrades; it prompts for
  your password once up front, then runs `brew upgrade --greedy` and
  `brew cleanup`
- `dstop` and `drm` are Docker helper functions for stopping or removing all
  containers
- Docker aliases include `dc`/`dcud`/`dcub` for Compose, `dclf` for following
  Compose logs, and `drun`/`dexec` for common container workflows
- prompt configured in `starship/.config/starship.toml`

## Claude and Codex Context

Global Claude Code context and settings are tracked at `claude/.claude/CLAUDE.md` and `claude/.claude/settings.json`, then symlinked to `~/.claude/` by stow.

Codex CLI defaults are tracked at `codex/.codex/config.toml`, symlinked to `~/.codex/config.toml`. Behavior instructions are tracked at `codex/.codex/AGENTS.md`, symlinked to `~/.codex/AGENTS.md`, and referenced by `instructions_file` in the config.

To refresh both after pulling changes:

```bash
make agents
```

## Obsidian Knowledge Vault

Scaffold files (`hub.md`, plugin note, templates) are tracked in `obsidian/.knowledge/` and seeded into `~/.knowledge` on setup. Personal vault content stays local and is not tracked in git.

Vault-wide files created by setup:

- `~/.knowledge/hub.md`
- `~/.knowledge/tasks.md`
- `~/.knowledge/setup/obsidian-plugins.md`
- `~/.knowledge/projects/projects.md`
- `~/.knowledge/reading/books.md`
- `~/.knowledge/reading/articles.md`
- `~/.knowledge/learning/courses.md`
- `~/.knowledge/learning/studies.md`
- `~/.knowledge/learning/lessons.md`
- `~/.knowledge/career/achievement-log.md`
- `~/.knowledge/_templates/*.md`

To seed missing vault files, install community plugins, and register the vault with Obsidian:

```bash
make obsidian
```

`make obsidian` is safe to rerun. It repairs a degraded workspace layout (e.g. Obsidian opens with empty tabs and no Files pane), creates the `~/Knowledge` alias, and skips re-downloading plugins that are already installed.

Skip community plugin installation for constrained environments with:

```bash
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh
```

Skip community plugin asset downloads while preserving plugin JSON settings with:

```bash
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 ./scripts/obsidian.sh setup
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
3. Add package name to `scripts/stow-packages.txt`.
4. Run:

```bash
make stow
```

# Operations

All `make` commands below use `~/.dotfiles/Makefile`. Run from `~/.dotfiles`, or run `make` with `-C ~/.dotfiles` from any directory.

## Routine Commands

```bash
make setup              # Re-apply idempotent setup after config changes
make update             # Update Homebrew and mise-managed packages
make doctor             # Homebrew + mise diagnostics
make status             # Summary of key tool versions
make list               # Installed mise runtimes
make mise               # Install runtimes from ~/.mise.toml
make obsidian           # Setup Knowledge vault and apply pinned plugin assets
make obsidian-lock      # Refresh pinned Obsidian plugin lock
make obsidian-clean     # Remove unmanaged Obsidian plugin directories
```

## Runtime and Tooling Updates

```bash
cd ~
mise upgrade
mise install
mise list

node -v
npm -v
pnpm -v
python --version
uv --version
go version
ruby -v
java -version
rustc --version
cargo --version
```

To add more runtimes or tools, add them to `~/.mise.toml` and rerun `make mise`.

## Interactive Homebrew Helper

For Homebrew-only updates from an interactive `zsh` session:

```bash
source ~/.zshrc
brewup
# or target a specific formula/cask:
brewup docker-desktop
```

`brewup` is defined in `zsh/.zshrc`. It asks for your password once up front,
then runs `brew upgrade --greedy` and `brew cleanup`. Use `make update` when
you also want `mise`-managed runtimes and tools updated.

To remove a previously added runtime/tool cleanly:

```bash
# Remove it from ~/.mise.toml first
make mise
mise uninstall --all <tool>
mise prune --tools
mise list
```

For runtime version policy and track changes, see [RUNTIMES.md](RUNTIMES.md).

## Setup Refresh

After pulling dotfile changes, re-apply local setup safely:

```bash
make setup
```

`make setup` is idempotent and runs `mise`, `stow`, `obsidian`, `gnupg`, and `vscode` refresh steps.

## Obsidian Plugin Updates

`make obsidian` installs community plugins from the pinned lock file
`obsidian/community-plugin-lock.json` and verifies SHA-256 checksums before writing assets.
It also creates a visible `~/Knowledge` alias (when available) and registers that path in Obsidian app config (`obsidian.json`) so it appears in the UI vault picker.
It also enforces the conflict-free baseline by enabling core `templates` with
`_templates` as the folder (`.obsidian/templates.json`), pruning overlapping
community plugins (`templater-obsidian`, `omnisearch`) from
`.obsidian/community-plugins.json`, and removing stale plugin directories for
those pruned IDs.

To update versions:

```bash
make obsidian-lock
# review obsidian/community-plugin-lock.json
make obsidian
```

To explicitly remove plugin directories that are not present in
`obsidian/community-plugin-lock.json`:

```bash
make obsidian-clean
```

## Brewfile Lifecycle

```bash
make dump        # Rebuild Brewfile from installed packages
make brew-check  # Validate Brewfile packages are installed
make cleanup     # Remove packages not in Brewfile
```

## Backups

```bash
make backup
make backup-list
make backup-clean
make backup-clean CONFIRM=1
```

`make backup` creates a timestamped directory under `~/dotfiles-backup-<timestamp>` and copies available local files.
`make backup-list` shows backup directories/files created by setup scripts (`*.backup`, `*.bak.*`, and `~/dotfiles-backup-*`).
`make backup-clean` prompts before deleting backup artifacts.
Use `make backup-clean CONFIRM=1` for non-interactive cleanup.

## Quality Gate

```bash
make check
make smoke
```

`make check` runs:

- `make lint-shell`
- `make lint-docs`
- `./scripts/check.sh` (local-override enforcement, docs↔Makefile consistency, no absolute host paths)

`make smoke` runs mocked end-to-end setup and validates Makefile wrapper paths (`make brew-check` and `make test`) propagate optional-cask env consistently.

## Run Individual Setup Steps

```bash
make brew
make mise
make stow
make agents
make gnupg
make vscode
```

## Validate Shell Files

```bash
make validate
```

## Cleaning Local Caches

```bash
make clean
```

# Operations

## Routine Commands

```bash
make update      # Update Homebrew and mise-managed tools
make doctor      # Homebrew + mise diagnostics
make status      # Summary of key tool versions
make list        # Installed mise runtimes
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
```

`make check` runs:

- `make lint-shell`
- `make lint-docs`
- `./scripts/check-readme-make-targets.sh`
- `./scripts/check-no-absolute-host-paths.sh`

## Run Individual Setup Steps

```bash
make brew
make mise
make stow
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

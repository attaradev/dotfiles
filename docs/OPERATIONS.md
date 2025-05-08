# Operations

All `make` commands below use `~/.dotfiles/Makefile`. Run from `~/.dotfiles`, or run `make` with `-C ~/.dotfiles` from any directory.

## Routine Commands

```bash
make update      # Update Homebrew and mise-managed tools
make doctor      # Homebrew + mise diagnostics
make status      # Summary of key tool versions
make list        # Installed mise runtimes
make mise        # Install runtimes from tracked config
```

## Runtime and Tooling Updates

```bash
cd ~/.dotfiles/mise
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

Install optional runtimes:

```bash
DOTFILES_INSTALL_JAVA=1 make mise
DOTFILES_INSTALL_RUST=1 make mise
```

For runtime version policy and track changes, see [RUNTIMES.md](RUNTIMES.md).

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
- `./scripts/check-readme-make-targets.sh`
- `./scripts/check-no-absolute-host-paths.sh`

`make smoke` runs mocked end-to-end setup and validates Makefile wrapper paths (`make brew-check` and `make test`) propagate optional-cask env consistently.

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

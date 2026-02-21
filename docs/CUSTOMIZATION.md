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

Edit `mise/.mise.toml` and re-run:

```bash
make mise
```

## Git Identity and Signing

`setup.sh` writes identity and signing behavior to `~/.gitconfig.local`.

- Set `user.name` and `user.email` for your machine.
- Set `user.signingkey` to enable signing.
- Leave signing key empty to keep signing disabled.
- This repository includes personal fallback defaults in `setup.sh`; for your fork, set `DEFAULT_GIT_*` or pass `GIT_USER_*` env vars.

## Shell Aliases and Prompt

Main shell config lives at `zsh/.zshrc`.

Notable defaults:

- `l`, `ll`, `la` use `eza`
- `cat` is aliased to `bat`
- `z` uses `zoxide`
- prompt configured in `starship/.config/starship.toml`

## Add a New Stow Package

1. Create a package directory in repo root (example: `tmux/`).
2. Place files using home-relative layout (example: `tmux/.tmux.conf`).
3. Add package name in `stow_setup.sh` `PACKAGES` array.
4. Run:

```bash
make stow
```

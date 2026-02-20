# Troubleshooting

## `setup.sh` prompt errors in automation

Use non-interactive mode:

```bash
DOTFILES_NONINTERACTIVE=1 ./setup.sh
```

This disables prompt flows and sudo refresh prompting.

## `brew bundle` lock or fetch conflict

If Homebrew reports a lock conflict (another fetch/install in progress):

1. Wait for the other process to finish.
2. Re-run:

```bash
make brew
```

## VSCode extensions skipped

If `code` CLI is missing, setup skips extension install.

Fix:

1. In VSCode run: `Shell Command: Install 'code' command in PATH`
2. Re-run:

```bash
make vscode
```

## Stow conflict with existing dotfiles

If local files already exist, stow may refuse to link.

Fix:

```bash
make backup
make stow
```

## GPG signing/pinentry issues

Validate `pinentry-mac` is installed and restart agent:

```bash
brew install pinentry-mac
gpgconf --kill gpg-agent
make gnupg
```

## Icons look broken in terminal

Use `JetBrainsMono Nerd Font` in your terminal profile.

The font is installed via `Brewfile` as `font-jetbrains-mono-nerd-font`.

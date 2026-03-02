# Troubleshooting

## `make: *** No rule to make target ...`

This usually means you ran `make` outside `~/.dotfiles`.

Fix:

```bash
cd ~/.dotfiles
make brew-check

# Or run from anywhere:
(cd ~/.dotfiles && make brew-check)
```

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

## Runtime or tooling command not found

Refresh shell + reinstall managed runtimes:

```bash
source ~/.zshrc
make mise
mise list
```

If still missing, verify `~/.mise.toml` includes the expected runtime and tooling entries:

- `node`, `python`, `go`, `ruby`
- `npm`, `pnpm`, `uv`
- any additional tools you added

If a required tool is not listed, add it to `~/.mise.toml` and rerun install:

```bash
make mise
mise list
```

## Wrong runtime version is active

Run from your home directory so global `~/.mise.toml` is applied:

```bash
cd ~
mise install
mise list
```

Then verify specific tools:

```bash
node -v
npm -v
pnpm -v
python --version
uv --version
go version
ruby -v
# Additional runtimes (if added):
java -version
rustc --version
cargo --version
```

If you still see an unexpected version, reload your shell:

```bash
source ~/.zshrc
rehash
```

## `make lint-docs` fails with `No version is set for shim: markdownlint`

This usually means global shim tracks and your active runtime config drifted.

Fix:

```bash
source ~/.zshrc
make mise
mise reshim
```

Then retry:

```bash
make lint-docs
```

## Icons look broken in terminal

Use `JetBrainsMono Nerd Font` in your terminal profile.

The font is installed via `Brewfile` as `font-jetbrains-mono-nerd-font`.

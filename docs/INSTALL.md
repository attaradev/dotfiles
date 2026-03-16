# Installation

## Prerequisites

- macOS
- Xcode Command Line Tools

```bash
xcode-select --install
```

## Recommended Bootstrap (Bash)

Fast online bootstrap:

```bash
curl -fsSL https://raw.githubusercontent.com/attaradev/dotfiles/main/bootstrap.sh | bash
```

Or clone first and run locally:

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

Bootstrap will clone to `~/.dotfiles` (or pull latest if already cloned) and run `./setup.sh`.
Bootstrap is idempotent and safe to rerun; it refreshes the repo and reapplies setup.
If Homebrew is missing, `setup.sh` installs it automatically via the official installer.
All `make` targets are defined in `~/.dotfiles/Makefile`; run them from `~/.dotfiles` or run `make` with `-C ~/.dotfiles`.

## Manual Installation

```bash
git clone https://github.com/attaradev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

`make install` runs:

1. Homebrew install/check
2. `brew bundle install`
3. `scripts/tools.sh mise`
4. Git identity setup (`~/.gitconfig.local`)
5. `scripts/tools.sh stow`
6. `scripts/obsidian.sh setup` (core/community plugin config + pinned community plugin install with SHA-256 verification)
7. `scripts/tools.sh gnupg`
8. `scripts/tools.sh vscode` (if `code` CLI exists)

After pulling later dotfile changes, run `make setup` to re-apply idempotent setup tasks without running package upgrades.

Runtime and tooling versions are sourced from local `~/.mise.toml` (created from `mise/.mise.toml` template when missing):

- Core runtimes: `node = "25"`, `python = "3.14"`, `go = "1.26"`, `ruby = "4.0"`
- Package managers/tooling: `npm = "11"`, `pnpm = "10"`, `uv = "0.10"`
- Add additional runtimes as needed by adding tracks to `~/.mise.toml` (for example `java = "21"` or `rust = "1.93"`), then run `make mise`

See [RUNTIMES.md](RUNTIMES.md) for version policy and update workflows.

## Non-Interactive Installation

Use this mode for automation and CI runners.

```bash
DOTFILES_NONINTERACTIVE=1 SKIP_VSCODE_EXTENSIONS=1 ./setup.sh
```

When `DOTFILES_NONINTERACTIVE=1` is set:

- Optional cask prompts are disabled.
- Git identity prompts are disabled.
- Sudo credential refresh prompt is skipped.

You can pre-seed Git values:

```bash
DOTFILES_NONINTERACTIVE=1 \
GIT_USER_NAME="Your Name" \
GIT_USER_EMAIL="you@example.com" \
GIT_USER_SIGNINGKEY="" \
./setup.sh
```

Set `GIT_USER_SIGNINGKEY=""` to explicitly disable signing in local config.

Skip Obsidian community plugin setup when needed:

```bash
DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh
```

Skip community plugin asset downloads while still writing plugin enablement JSON:

```bash
DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 ./scripts/obsidian.sh setup
```

By default, already installed community plugins are not re-downloaded on reruns.
To re-check and re-apply versions pinned in `obsidian/community-plugin-lock.json`:

```bash
DOTFILES_OBSIDIAN_UPDATE_PLUGINS=1 make obsidian
```

To update plugin versions safely:

```bash
make obsidian-lock
# review obsidian/community-plugin-lock.json
make obsidian
```

If GitHub API limits are hit during lock refresh, set `GITHUB_TOKEN_FILE` to a
local file containing a token before running `make obsidian-lock`.

Note: this repository has personal fallback Git defaults in `setup.sh`; override with `GIT_USER_*` (or `DEFAULT_GIT_*` in your fork).

## Optional Casks

Optional GUI tools are controlled by env vars and persisted to `~/.config/dotfiles/brew-optional.env`.

- `BREW_INSTALL_ANTIGRAVITY`
- `BREW_INSTALL_VIRTUALBOX`
- `BREW_INSTALL_BRAVE_BROWSER`
- `BREW_INSTALL_VLC`
- `BREW_INSTALL_SPOTIFY`

Homebrew bundle equivalents are mirrored to `HOMEBREW_BUNDLE_INSTALL_*` automatically.

## Post-Install Verification

```bash
source ~/.zshrc
type brewup
make doctor
make status
brew list --cask obsidian
test -e ~/.codex/config.toml
test -e ~/.codex/AGENTS.md
test -e ~/.knowledge/hub.md
test -L ~/Knowledge
test -e ~/.knowledge/setup/obsidian-plugins.md
test -e ~/.knowledge/tasks.md
test -e ~/.knowledge/projects/projects.md
test -e ~/.knowledge/reading/books.md
test -e ~/.knowledge/reading/articles.md
test -e ~/.knowledge/learning/courses.md
test -e ~/.knowledge/learning/studies.md
test -e ~/.knowledge/learning/lessons.md
test -e ~/.knowledge/career/achievement-log.md
test -e ~/.knowledge/.obsidian/core-plugins.json
test -e ~/.knowledge/.obsidian/community-plugins.json
test -e ~/.knowledge/.obsidian/plugins/auto-classifier/manifest.json
test -e ~/.knowledge/.obsidian/plugins/dataview/manifest.json
test -e ~/.knowledge/.obsidian/plugins/obsidian-tasks-plugin/manifest.json
jq -e 'if type=="object" then .["file-explorer"] == true else index("file-explorer") != null end' ~/.knowledge/.obsidian/core-plugins.json
jq -e '.enableDataviewJs == true and .enableInlineDataviewJs == true' ~/.knowledge/.obsidian/plugins/dataview/data.json
jq -e '[.. | objects | select(.type? == "file-explorer")] | length > 0' ~/.knowledge/.obsidian/workspace.json
mise list
node -v
npm -v
pnpm -v
python --version
uv --version
go version
ruby -v
# Additional runtimes you added in ~/.mise.toml:
java -version
rustc --version
cargo --version
```

`brewup` is the interactive-shell helper for Homebrew-only upgrades. It asks
for your password once up front before running `brew upgrade --greedy` and
`brew cleanup`, which avoids repeated prompts for casks that need privileged
cleanup.

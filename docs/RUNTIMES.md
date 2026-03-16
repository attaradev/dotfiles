# Runtime Management

This repository manages development runtimes and language tooling with `mise`.

## Source of Truth

- Runtime versions are managed in local `~/.mise.toml`.
- `scripts/tools.sh mise` bootstraps `~/.mise.toml` from tracked template `mise/.mise.toml` only when missing.
- `scripts/tools.sh mise` syncs `[tools]` tracks from `~/.mise.toml` into `~/.config/mise/config.toml` via `mise use -g` so global shims stay aligned.
- `make mise` installs tools from `~/.mise.toml`.
- `make update` runs `mise upgrade` to move installed tools within configured tracks.

## Managed Tools and Version Policy

| Tool | Default track in template (`mise/.mise.toml`) | Policy |
| --- | --- | --- |
| Node.js | `25` | Latest patch/minor within major 25 |
| npm | `11` | Latest patch/minor within major 11 |
| pnpm | `10` | Latest patch/minor within major 10 |
| Python | `3.14` | Latest patch release within 3.14 |
| uv | `0.10` | Latest patch release within 0.10 |
| Go | `1.26` | Latest patch release within 1.26 |
| Ruby | `4.0` | Latest patch release within 4.0 |

This policy keeps tracked tools on explicit major/minor lines while allowing patch/minor updates inside each line.

## Install and Verify

```bash
make mise
mise list

node -v
npm -v
pnpm -v
python --version
uv --version
go version
ruby -v
# Additional runtimes you added (for example java/rust):
java -version
rustc --version
cargo --version
```

## Update Workflows

Upgrade installed tools within configured tracks:

```bash
cd ~
mise upgrade
mise install
mise list
```

Add tools as needed:

```bash
# 1) Add a tool track in ~/.mise.toml, for example:
#    java = "21"
#    rust = "1.93"
#
# 2) Install from local config:
make mise
mise list
```

Remove tools cleanly:

```bash
# 1) Remove the tool from ~/.mise.toml
#
# 2) Re-sync from local config:
make mise

# 3) Remove installed versions:
mise uninstall --all <tool>

# 4) Clean unused installs:
mise prune --tools --dry-run
mise prune --tools

# 5) Verify:
mise list
```

Check available upstream versions:

```bash
mise ls-remote node
mise ls-remote python
mise ls-remote go
mise ls-remote ruby
```

## Change a Track Intentionally

1. Edit `~/.mise.toml` (for example, `node = "26"`).
2. Run `make mise` (or `cd ~ && mise install`).
3. Verify versions with `mise list` and tool-specific version commands.
4. Run `make check` and `make smoke`.

## Notes

- `mise` activation is loaded from `zsh/.zshrc`.
- If commands still resolve to old versions, run `source ~/.zshrc` and open a new shell.

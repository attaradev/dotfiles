# Runtime Management

This repository manages development runtimes and language tooling with `mise`.

## Source of Truth

- Runtime versions are tracked in `mise/.mise.toml`.
- `make mise` installs tools from that file (via `scripts/setup-mise.sh`).
- `make update` runs `mise upgrade` to move installed tools within configured tracks.

## Managed Tools and Version Policy

| Tool | Track in `mise/.mise.toml` | Policy | Installed by default |
| --- | --- | --- | --- |
| Node.js | `25` | Latest patch/minor within major 25 | Yes |
| npm | `11` | Latest patch/minor within major 11 | Yes |
| pnpm | `10` | Latest patch/minor within major 10 | Yes |
| Python | `3.14` | Latest patch release within 3.14 | Yes |
| uv | `0.10` | Latest patch release within 0.10 | Yes |
| Go | `1.26` | Latest patch release within 1.26 | Yes |
| Ruby | `4.0` | Latest patch release within 4.0 | Yes |
| Java | `21` | Latest patch/minor within major 21 | No (`DOTFILES_INSTALL_JAVA=1`) |
| Rust | `1.93` | Latest patch release within 1.93 | No (`DOTFILES_INSTALL_RUST=1`) |

This policy keeps all tools on explicit major/minor tracks while allowing Java/Rust to stay optional.

## Install and Verify

```bash
cd ~/.dotfiles/mise
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

## Update Workflows

Upgrade installed tools within configured tracks:

```bash
cd ~/.dotfiles/mise
mise upgrade
mise install
mise list
```

Install optional runtimes:

```bash
DOTFILES_INSTALL_JAVA=1 make mise
DOTFILES_INSTALL_RUST=1 make mise
DOTFILES_INSTALL_JAVA=1 DOTFILES_INSTALL_RUST=1 make mise
```

Check available upstream versions:

```bash
mise ls-remote node
mise ls-remote python
mise ls-remote go
mise ls-remote ruby
mise ls-remote java
mise ls-remote rust
```

## Change a Track Intentionally

1. Edit `mise/.mise.toml` (for example, `node = "26"`).
2. Run `make mise` (or `cd ~/.dotfiles/mise && mise install`).
3. Verify versions with `mise list` and tool-specific version commands.
4. Run `make check` and `make smoke`.

## Notes

- `mise` activation is loaded from `zsh/.zshrc`.
- If commands still resolve to old versions, run `source ~/.zshrc` and open a new shell.

# Obsidian Plugin Operator Notes

Plugin installation is automated. This file is an operator note, not the source of truth.

## Source of Truth

- Plugin IDs and mappings are defined in [`scripts/setup-obsidian.sh`](../../../scripts/setup-obsidian.sh):
  - `CORE_PLUGINS`
  - `COMMUNITY_PLUGINS`
  - `community_plugin_repo()`

## Standard Commands

- `make obsidian` to configure vault plugin settings and install/update plugin files.
- `./scripts/setup-obsidian.sh` to run the plugin setup script directly.
- `DOTFILES_SETUP_OBSIDIAN_PLUGINS=0 ./setup.sh` to skip plugin installation in full setup.
- `DOTFILES_OBSIDIAN_SKIP_PLUGIN_DOWNLOADS=1 ./scripts/setup-obsidian.sh` to write plugin config JSON without downloading plugin assets.

## Baseline Expectations

- Vault path is `~/.knowledge`.
- Templates folder is `_templates` via core Templates (`.obsidian/templates.json`).
- Core Templates is the canonical templating engine; Templater is intentionally not enabled.
- Core Search is the canonical search surface; OmniSearch is intentionally not enabled.
- QuickAdd is enabled for capture and command automation; templating remains on core Templates.
- File Explorer, Search, and Quick Switcher core plugins are enabled by default.
- DataviewJS (`enableDataviewJs` and `enableInlineDataviewJs`) is enabled.
- Metadata Menu Dataview prompt is suppressed (`disableDataviewPrompt = true`).
- Core/community plugin enablement is managed via:
  - `.obsidian/core-plugins.json`
  - `.obsidian/community-plugins.json`
- Community plugin files are installed under `.obsidian/plugins/<plugin-id>/`.
- Workspace defaults to a Files pane plus `hub.md`; `scripts/setup-obsidian.sh` can reset broken empty layouts.

## Recovery Notes

- If plugin installs fail due to rate limits, export `GITHUB_TOKEN` and rerun `make obsidian`.
- If a specific plugin is corrupted, remove `.obsidian/plugins/<plugin-id>/` and rerun `make obsidian`.

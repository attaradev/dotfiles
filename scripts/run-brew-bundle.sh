#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPTIONAL_CASK_ENV_FILE="${OPTIONAL_CASK_ENV_FILE:-$HOME/.config/dotfiles/brew-optional.env}"

# shellcheck source=./optional-casks.sh
source "$ROOT_DIR/scripts/optional-casks.sh"

if [[ -f "$OPTIONAL_CASK_ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$OPTIONAL_CASK_ENV_FILE"
fi

sync_optional_cask_env_vars

exec brew bundle "$@"

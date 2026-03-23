#!/usr/bin/env bash
# Shared utility functions sourced by setup scripts.

# ---------------------------------------------------------------------------
# General utilities
# ---------------------------------------------------------------------------

# Initialize ANSI colors lazily so scripts can share consistent output helpers.
setup_output_colors() {
  if [[ "${_DOTFILES_OUTPUT_COLORS_INITIALIZED:-0}" == "1" ]]; then
    return 0
  fi

  _DOTFILES_OUTPUT_COLORS_INITIALIZED=1

  if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    RED=$'\033[38;5;203m'
    GREEN=$'\033[38;5;76m'
    YELLOW=$'\033[38;5;220m'
    BLUE=$'\033[38;5;69m'
    MAGENTA=$'\033[38;5;171m'
    CYAN=$'\033[38;5;45m'
    NC=$'\033[0m'
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
    NC=""
  fi
}

print_header() {
  setup_output_colors
  echo ""
  echo -e "${MAGENTA}============================================${NC}"
  echo -e "${MAGENTA}$1${NC}"
  echo -e "${MAGENTA}============================================${NC}"
  echo ""
}

print_success() {
  setup_output_colors
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  setup_output_colors
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  setup_output_colors
  echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
  setup_output_colors
  echo -e "${BLUE}ℹ${NC} $1"
}

# Normalise a boolean-ish string to "1" or "0".
normalize_bool() {
  local raw
  raw="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')"
  case "$raw" in
    1|y|yes|true|on) echo "1" ;;
    *) echo "0" ;;
  esac
}

# Exit with an error if a required command is not on PATH.
require_cmd() {
  local cmd=$1
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Missing required command: $cmd"
    exit 1
  fi
}

# Return the path that should be written to: if $primary is a symlink or lives
# inside the dotfiles dir, return $fallback (a local untracked copy); otherwise
# return $primary unchanged.
resolve_mutable_target() {
  local primary="$1"
  local fallback="$2"
  local dotfiles_dir="${3:-}"

  if [[ -L "$primary" ]] || [[ -n "$dotfiles_dir" && "$primary" == "$dotfiles_dir"* ]]; then
    printf '%s\n' "$fallback"
  else
    printf '%s\n' "$primary"
  fi
}

activate_homebrew_shellenv() {
  local brew_bin

  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done

  return 1
}

# Convert a symlinked file into a local regular file, preserving current
# contents so future writes stay machine-local.
materialize_local_file() {
  local file="$1"
  local tmp_file

  if [[ ! -L "$file" ]]; then
    return 1
  fi

  tmp_file="$(mktemp)"
  cat "$file" >"$tmp_file" 2>/dev/null || true
  rm -f "$file"
  mkdir -p "$(dirname "$file")"
  cp "$tmp_file" "$file"
  rm -f "$tmp_file"
}

copy_file_if_missing() {
  local target="$1"
  local source="$2"

  materialize_local_file "$target" || true

  if [[ -e "$target" ]]; then
    return 0
  fi

  if [[ -f "$source" ]]; then
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
  fi
}

replace_file_if_changed() {
  local tmp_file="$1"
  local target="$2"

  materialize_local_file "$target" || true

  mkdir -p "$(dirname "$target")"

  if [[ -f "$target" ]] && cmp -s "$tmp_file" "$target"; then
    rm -f "$tmp_file"
    return 1
  fi

  mv "$tmp_file" "$target"
}

remove_lines_matching_regex() {
  local file="$1"
  local pattern="$2"
  local tmp_file rc=0

  tmp_file="$(mktemp)"

  if grep -Ev -- "$pattern" "$file" >"$tmp_file"; then
    :
  else
    rc=$?
    if [[ "$rc" -ne 1 ]]; then
      rm -f "$tmp_file"
      return "$rc"
    fi
    : >"$tmp_file"
  fi

  mv "$tmp_file" "$file"
}

mise_extract_tool_tracks() {
  local config_path="$1"
  local in_tools=0 line tool track

  [[ -f "$config_path" ]] || return 0

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*\[tools\][[:space:]]*$ ]]; then
      in_tools=1
      continue
    fi
    if [[ $in_tools -eq 1 && "$line" =~ ^[[:space:]]*\[[^]]+\][[:space:]]*$ ]]; then
      break
    fi
    [[ $in_tools -eq 0 ]] && continue

    if [[ "$line" =~ ^[[:space:]]*\"?([A-Za-z0-9:_-]+)\"?[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      tool="${BASH_REMATCH[1]}"
      track="${BASH_REMATCH[2]}"
      printf '%s\t%s\n' "$tool" "$track"
    fi
  done < "$config_path"
}

mise_get_tool_track() {
  local config_path="$1"
  local requested_tool="$2"
  local tool track

  while IFS=$'\t' read -r tool track; do
    if [[ "$tool" == "$requested_tool" ]]; then
      printf '%s\n' "$track"
      return 0
    fi
  done < <(mise_extract_tool_tracks "$config_path")

  return 1
}

# ---------------------------------------------------------------------------
# Optional Homebrew cask management
# ---------------------------------------------------------------------------

# Metadata for optional casks. Format: "<SUFFIX>|<Label>|<Description>"
OPTIONAL_CASK_SPECS=(
  "ANTIGRAVITY|Antigravity|AI coding agent IDE"
  "UTM|UTM|Virtual machines for Mac (free, open-source)"
  "BRAVE_BROWSER|Brave Browser|Privacy-focused browser"
  "VLC|VLC|Versatile media player"
  "SPOTIFY|Spotify|Music streaming client"
)

# Load optional cask preferences from an env file, exporting only recognised
# BREW_INSTALL_* / HOMEBREW_BUNDLE_INSTALL_* keys with normalised values.
load_optional_cask_env_file() {
  local env_file="${1:-}"
  local line key value entry suffix brew_var bundle_var allowed

  [[ -n "$env_file" && -f "$env_file" ]] || return 0

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -n "$line" ]] || continue

    if [[ "$line" =~ ^export[[:space:]]+([A-Z0-9_]+)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
    elif [[ "$line" =~ ^([A-Z0-9_]+)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
    else
      continue
    fi

    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"

    allowed=0
    for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
      IFS='|' read -r suffix _ _ <<< "$entry"
      brew_var="BREW_INSTALL_${suffix}"
      bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
      if [[ "$key" == "$brew_var" || "$key" == "$bundle_var" ]]; then
        allowed=1
        break
      fi
    done

    if [[ "$allowed" == "1" ]]; then
      export "$key=$(normalize_bool "$value")"
    fi
  done < "$env_file"
}

# Sync BREW_INSTALL_* and HOMEBREW_BUNDLE_INSTALL_* pairs to a consistent
# normalised value, so both naming conventions agree.
sync_optional_cask_env_vars() {
  local entry suffix brew_var bundle_var value

  for entry in "${OPTIONAL_CASK_SPECS[@]}"; do
    IFS='|' read -r suffix _ _ <<< "$entry"
    brew_var="BREW_INSTALL_${suffix}"
    bundle_var="HOMEBREW_BUNDLE_INSTALL_${suffix}"
    value="$(normalize_bool "${!bundle_var:-${!brew_var:-0}}")"
    export "$brew_var=$value"
    export "$bundle_var=$value"
  done
}

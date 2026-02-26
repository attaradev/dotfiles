#!/bin/bash

# ============================================
# VSCode Setup Script
# Installs recommended extensions
# ============================================

set -e  # Exit on error

echo "🔧 Setting up VSCode extensions..."

# Check if VSCode CLI is available
if ! command -v code &> /dev/null; then
  echo "❌ VSCode CLI 'code' not found in PATH"
  echo "Please install VSCode or ensure 'code' is in your PATH"
  echo "In VSCode: Cmd+Shift+P -> 'Shell Command: Install code command in PATH'"
  exit 1
fi

echo "✓ VSCode CLI found: $(code --version | head -n 1)"

# Cache installed extensions once to avoid repeated CLI calls (prevents Electron/V8 flakiness)
INSTALLED_EXTS="$(code --list-extensions 2>/dev/null || true)"

# List of recommended extensions
EXTENSIONS=(
  # Python
  ms-python.python
  ms-python.vscode-pylance

  # Go
  golang.go

  # JavaScript/TypeScript
  esbenp.prettier-vscode
  dbaeumer.vscode-eslint
  ms-vscode.vscode-typescript-next

  # Git
  eamodio.gitlens
  donjayamanne.githistory
  GitHub.vscode-pull-request-github
  github.vscode-github-actions

  # Docker
  ms-azuretools.vscode-docker
  docker.docker

  # Infrastructure as Code
  hashicorp.terraform

  # Cloud
  amazonwebservices.aws-toolkit-vscode

  # Design
  figma.figma-vscode-extension

  # Utilities
  EditorConfig.EditorConfig
  christian-kohler.path-intellisense
  kisstkondoros.vscode-codemetrics
  alefragnani.project-manager

  # Theme
  PKief.material-icon-theme

  # AI/Copilot
  GitHub.copilot
  GitHub.copilot-chat
  anthropic.claude-code
  openai.chatgpt
)

# Track statistics
INSTALLED_COUNT=0
SKIPPED_COUNT=0
FAILED_COUNT=0
FAILED_EXTENSIONS=()

echo ""
echo "📦 Installing ${#EXTENSIONS[@]} extensions..."
echo ""

TLS_CA_RETRY_ENABLED=0
if [[ -z "${NODE_EXTRA_CA_CERTS:-}" && -n "${SSL_CERT_FILE:-}" && -r "${SSL_CERT_FILE:-}" ]]; then
  TLS_CA_RETRY_ENABLED=1
fi

is_extension_installed() {
  local ext_id="$1"
  local ext_id_lc

  if printf '%s\n' "$INSTALLED_EXTS" | grep -Fxqi "$ext_id"; then
    return 0
  fi

  ext_id_lc="$(printf '%s' "$ext_id" | tr '[:upper:]' '[:lower:]')"

  # VSCode 1.109+ resolves github.copilot installs to github.copilot-chat.
  if [[ "$ext_id_lc" == "github.copilot" ]] && printf '%s\n' "$INSTALLED_EXTS" | grep -Fxqi "github.copilot-chat"; then
    return 0
  fi

  return 1
}

# Install each extension using VSCode CLI
for EXT in "${EXTENSIONS[@]}"; do
  # Check if extension is already installed
  if is_extension_installed "$EXT"; then
    echo "  ⏭️  $EXT (already installed)"
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
  else
    echo "  📥 Installing $EXT..."
    if install_output="$(code --install-extension "$EXT" --force 2>&1)"; then
      echo "  ✓ $EXT installed successfully"
      INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    else
      # Capture the failure and optionally retry with NODE_EXTRA_CA_CERTS
      # when Node/Electron cannot validate an enterprise MITM certificate.
      if [[ "$TLS_CA_RETRY_ENABLED" -eq 1 && "$install_output" == *"unable to get local issuer certificate"* ]]; then
        echo "  ↻ Retrying $EXT with NODE_EXTRA_CA_CERTS from SSL_CERT_FILE..."
        if NODE_EXTRA_CA_CERTS="$SSL_CERT_FILE" code --install-extension "$EXT" --force > /dev/null 2>&1; then
          echo "  ✓ $EXT installed successfully (CA retry)"
          INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
          continue
        fi
      fi

      echo "  ❌ Failed to install $EXT"
      FAILED_COUNT=$((FAILED_COUNT + 1))
      FAILED_EXTENSIONS+=("$EXT")
    fi
  fi
done

echo ""
echo "📊 Installation Summary:"
echo "  ✓ Newly installed: $INSTALLED_COUNT"
echo "  ⏭️  Already installed: $SKIPPED_COUNT"
echo "  ❌ Failed: $FAILED_COUNT"

if [ $FAILED_COUNT -gt 0 ]; then
  echo ""
  echo "Failed extensions:"
  for EXT in "${FAILED_EXTENSIONS[@]}"; do
    echo "  - $EXT"
  done
  echo ""
  echo "You can manually install failed extensions with:"
  echo "  code --install-extension <extension-id>"
fi

echo ""
echo "✅ VSCode setup complete!"
echo ""
echo "💡 Tip: Enable Settings Sync in VSCode to sync extensions across machines:"
echo "   Cmd+Shift+P -> 'Settings Sync: Turn On'"
echo ""

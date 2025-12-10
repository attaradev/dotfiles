#!/bin/bash

# ============================================
# Main Setup Script for macOS Development Environment
# ============================================
# This script orchestrates the setup of:
# - Homebrew packages and applications (via Brewfile)
# - mise for version management (Node, Python, Ruby, etc.)
# - GNU Stow for dotfile symlink management
# - GnuPG (GPG) for secure communications and commit signing
# - VSCode extensions
# ============================================

set -e  # Exit on error

# Colors for output (auto-disable if not a TTY or NO_COLOR set)
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  RED='\033[38;5;203m'
  GREEN='\033[38;5;76m'
  YELLOW='\033[38;5;220m'
  BLUE='\033[38;5;69m'
  MAGENTA='\033[38;5;171m'
  CYAN='\033[38;5;45m'
  NC='\033[0m' # No Color
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
  NC=""
fi

# Helper functions
print_header() {
  echo ""
  echo -e "${MAGENTA}============================================${NC}"
  echo -e "${MAGENTA}$1${NC}"
  echo -e "${MAGENTA}============================================${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_note() {
  echo -e "${CYAN}ℹ${NC} $1"
}

# ============================================
# Pre-flight checks
# ============================================

print_header "Pre-flight Checks"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "This script is designed for macOS only."
  exit 1
fi

print_success "Running on macOS"

# Ensure Xcode Command Line Tools are available for git/Homebrew
if ! xcode-select -p >/dev/null 2>&1; then
  print_info "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  print_warning "Command Line Tools install has been initiated. Re-run setup after it completes."
  exit 1
fi

print_success "Xcode Command Line Tools detected"

# Keep sudo alive so Homebrew/cask installs only prompt once
if command -v sudo >/dev/null 2>&1; then
  print_info "Refreshing sudo credentials to avoid repeated prompts..."
  if sudo -v; then
    # Background keepalive until this script exits
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!
    trap '[[ -n "$SUDO_KEEPALIVE_PID" ]] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
    print_success "Sudo session refreshed"
  else
    print_warning "Could not refresh sudo credentials. You may be prompted during installs."
  fi
else
  print_warning "sudo not available. Continuing without elevated privileges."
fi

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_info "Dotfiles directory: $DOTFILES_DIR"

cd "$DOTFILES_DIR"

# ============================================
# Step 1: Install Homebrew
# ============================================

print_header "Step 1: Homebrew Installation"

if command -v brew &> /dev/null; then
  print_success "Homebrew is already installed ($(brew --version | head -n 1))"
else
  print_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  print_success "Homebrew installed successfully"
fi

# ============================================
# Step 2: Install packages from Brewfile
# ============================================

print_header "Step 2: Installing Packages from Brewfile"

if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
  print_info "Running brew bundle install..."
  brew bundle install --file="$DOTFILES_DIR/Brewfile" --verbose
  print_success "All packages installed from Brewfile"
else
  print_error "Brewfile not found at $DOTFILES_DIR/Brewfile"
  exit 1
fi

# ============================================
# Step 3: Setup mise (version manager)
# ============================================

print_header "Step 3: Setting up mise"

if [[ -x "$DOTFILES_DIR/install_mise.sh" ]]; then
  "$DOTFILES_DIR/install_mise.sh"
else
  print_warning "install_mise.sh not found or not executable, skipping..."
fi

# ============================================
# Step 4: Setup dotfiles with GNU Stow
# ============================================

print_header "Step 4: Setting up Dotfiles with GNU Stow"

if [[ -x "$DOTFILES_DIR/stow_setup.sh" ]]; then
  "$DOTFILES_DIR/stow_setup.sh"
else
  print_warning "stow_setup.sh not found or not executable, skipping..."
fi

# ============================================
# Step 5: Setup GnuPG (GPG)
# ============================================

print_header "Step 5: Setting up GnuPG"

if [[ -x "$DOTFILES_DIR/setup_gnupg.sh" ]]; then
  "$DOTFILES_DIR/setup_gnupg.sh"
else
  print_warning "setup_gnupg.sh not found or not executable, skipping..."
fi

# ============================================
# Step 6: Setup VSCode extensions
# ============================================

print_header "Step 6: Setting up VSCode Extensions"

# Allow skipping via env; otherwise auto-run if VSCode CLI is available
if [[ "${SKIP_VSCODE_EXTENSIONS:-0}" == "1" ]]; then
  print_info "Skipping VSCode extensions setup (SKIP_VSCODE_EXTENSIONS=1)"
elif ! command -v code >/dev/null 2>&1; then
  print_warning "VSCode CLI 'code' not found. Install VSCode and run: make vscode"
elif [[ -x "$DOTFILES_DIR/vscode_setup.sh" ]]; then
  "$DOTFILES_DIR/vscode_setup.sh"
else
  print_warning "vscode_setup.sh not found or not executable, skipping..."
fi

# ============================================
# Final Steps
# ============================================

print_header "Setup Complete!"

echo "Your development environment has been set up successfully!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Restart your terminal or run:"
echo "   ${GREEN}source ~/.zshrc${NC}"
echo ""
echo "2. Verify installations:"
echo "   ${GREEN}brew doctor${NC}        # Check Homebrew health"
echo "   ${GREEN}mise doctor${NC}        # Check mise health"
echo "   ${GREEN}mise list${NC}          # Show installed versions"
echo ""
echo "3. Install additional language versions with mise:"
echo "   ${GREEN}mise use node@20${NC}   # Install Node.js 20"
echo "   ${GREEN}mise use python@3.12${NC} # Install Python 3.12"
echo ""
echo "4. Explore modern CLI tools:"
echo "   ${GREEN}ls${NC}                 # Now uses 'eza' with icons"
echo "   ${GREEN}cat file.txt${NC}       # Now uses 'bat' with syntax highlighting"
echo "   ${GREEN}cd${NC}                 # Now uses 'zoxide' for smart navigation"
echo ""
echo "💡 Tips:"
echo "   - Use 'z <dir>' for smart directory jumping"
echo "   - Use 'fzf' with Ctrl+R for command history search"
echo "   - Use 'brewup' alias to update all Homebrew packages"
echo ""
echo "📖 For more information, check the README.md"
echo ""

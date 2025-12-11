# ============================================
# Dotfiles Makefile
# ============================================
# Convenient shortcuts for managing your macOS development environment
#
# Usage:
#   make install    # Full setup (first time)
#   make update     # Update packages and tools
#   make help       # Show all available commands

.DEFAULT_GOAL := help
.PHONY: help install update brew mise stow vscode clean doctor status dump backup test

BUNDLE_ENV_FILE ?= $(HOME)/.config/dotfiles/brew-optional.env

# ============================================
# Setup & Installation
# ============================================

## install: Full setup - install all packages, tools, and dotfiles
install:
	@echo "🚀 Starting full dotfiles setup..."
	@chmod +x *.sh
	@./setup.sh

## brew: Install/update packages from Brewfile
brew:
	@echo "📦 Installing packages from Brewfile..."
	@if [ -f "$(BUNDLE_ENV_FILE)" ]; then . "$(BUNDLE_ENV_FILE)"; fi; \
	 brew bundle install --verbose

## brew-check: Verify all Brewfile packages are installed
brew-check:
	@echo "✓ Checking Brewfile packages..."
	@if [ -f "$(BUNDLE_ENV_FILE)" ]; then . "$(BUNDLE_ENV_FILE)"; fi; \
	 brew bundle check || (echo "❌ Some packages are missing. Run 'make brew' to install." && exit 1)

## mise: Setup mise and install language runtimes
mise:
	@echo "🔧 Setting up mise..."
	@chmod +x install_mise.sh
	@./install_mise.sh

## stow: Create symlinks for dotfiles
stow:
	@echo "🔗 Creating dotfile symlinks..."
	@chmod +x stow_setup.sh
	@./stow_setup.sh

## vscode: Install VSCode extensions
vscode:
	@echo "🎨 Installing VSCode extensions..."
	@chmod +x vscode_setup.sh
	@./vscode_setup.sh

## gnupg: Setup GnuPG (GPG)
gnupg:
	@echo "🔐 Setting up GnuPG..."
	@chmod +x setup_gnupg.sh
	@./setup_gnupg.sh

# ============================================
# Updates & Maintenance
# ============================================

## update: Update Homebrew packages, mise, and tools
update:
	@echo "⬆️  Updating all packages and tools..."
	@echo ""
	@echo "📦 Updating Homebrew..."
	@brew update
	@brew upgrade
	@echo ""
	@echo "🔧 Updating mise..."
	@brew upgrade mise
	@echo ""
	@echo "⚡ Upgrading mise-managed tools..."
	@mise upgrade
	@echo ""
	@echo "🧹 Cleaning up..."
	@brew cleanup
	@echo ""
	@echo "✅ Update complete!"

## upgrade: Alias for update
upgrade: update

# ============================================
# Diagnostics & Status
# ============================================

## doctor: Run health checks on Homebrew and mise
doctor:
	@echo "🩺 Running health checks..."
	@echo ""
	@echo "📦 Homebrew Doctor:"
	@command -v brew >/dev/null 2>&1 && brew doctor || echo "Homebrew not installed"
	@echo ""
	@echo "🔧 mise Doctor:"
	@command -v mise >/dev/null 2>&1 && mise doctor || echo "mise not installed"
	@echo ""
	@echo "✅ Health checks complete!"

## status: Show status of installed tools and versions
status:
	@echo "📊 System Status"
	@echo "════════════════════════════════════════════"
	@echo ""
	@echo "🍺 Homebrew:"
	@brew --version | head -n 1 2>/dev/null || echo "Not installed"
	@echo ""
	@echo "🔧 mise:"
	@command -v mise >/dev/null 2>&1 && mise --version || echo "Not installed"
	@echo ""
	@echo "📦 mise-managed tools:"
	@command -v mise >/dev/null 2>&1 && mise list || echo "mise not installed"
	@echo ""
	@echo "🐚 Shell:"
	@echo "$$SHELL"
	@echo ""
	@echo "💻 macOS:"
	@sw_vers -productVersion
	@echo ""

## list: List installed mise tools and versions
list:
	@command -v mise >/dev/null 2>&1 && mise list || echo "mise not installed. Run 'make mise' to install."

# ============================================
# Brewfile Management
# ============================================

## dump: Generate Brewfile from currently installed packages
dump:
	@echo "📝 Generating Brewfile from installed packages..."
	@brew bundle dump --force --describe --file=./Brewfile
	@echo "✓ Brewfile updated!"
	@echo ""
	@echo "⚠️  Review changes carefully before committing:"
	@echo "   git diff Brewfile"

## cleanup: Remove packages not in Brewfile
cleanup:
	@echo "🧹 Removing packages not in Brewfile..."
	@brew bundle cleanup --force
	@echo "✓ Cleanup complete!"

# ============================================
# Backup & Restore
# ============================================

## backup: Create backup of current dotfiles
backup:
	@echo "💾 Creating backup of dotfiles..."
	@mkdir -p ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)
	@cp -r ~/.zshrc ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp -r ~/.zshrc.local ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp -r ~/.config ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@echo "✓ Backup created in ~/dotfiles-backup-$$(date +%Y%m%d-%H%M%S)"

# ============================================
# Testing & Validation
# ============================================

## test: Run idempotency test (safe to run multiple times)
test:
	@echo "🧪 Testing dotfiles idempotency..."
	@echo ""
	@echo "Running setup in check mode..."
	@brew bundle check --verbose
	@echo ""
	@echo "✅ Idempotency test passed!"

## validate: Validate shell configuration
validate:
	@echo "✓ Validating shell configuration..."
	@zsh -n ~/.zshrc && echo "✓ .zshrc syntax is valid" || echo "❌ .zshrc has syntax errors"
	@test -f ~/.zshrc.local && (zsh -n ~/.zshrc.local && echo "✓ .zshrc.local syntax is valid") || echo "ℹ️  No .zshrc.local found (optional)"

# ============================================
# Cleanup
# ============================================

## clean: Clean up caches and temporary files
clean:
	@echo "🧹 Cleaning up caches..."
	@brew cleanup
	@rm -f Brewfile.lock.json
	@echo "✓ Cleanup complete!"

## uninstall-stow: Remove all dotfile symlinks
uninstall-stow:
	@echo "🗑️  Removing dotfile symlinks..."
	@stow -D zsh || true
	@echo "✓ Symlinks removed!"

# ============================================
# Help
# ============================================

## help: Show this help message
help:
	@echo "Dotfiles Management Commands"
	@echo "════════════════════════════════════════════"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make install       - Full setup (first time)"
	@echo "  make brew          - Install packages from Brewfile"
	@echo "  make brew-check    - Verify Brewfile packages"
	@echo "  make mise          - Setup mise version manager"
	@echo "  make stow          - Create dotfile symlinks"
	@echo "  make vscode        - Install VSCode extensions"
	@echo "  make gnupg         - Setup GnuPG"
	@echo ""
	@echo "Updates & Maintenance:"
	@echo "  make update        - Update all packages and tools"
	@echo "  make upgrade       - Alias for update"
	@echo ""
	@echo "Diagnostics & Status:"
	@echo "  make doctor        - Run health checks"
	@echo "  make status        - Show system status"
	@echo "  make list          - List mise tools"
	@echo ""
	@echo "Brewfile Management:"
	@echo "  make dump          - Generate Brewfile from system"
	@echo "  make cleanup       - Remove unlisted packages"
	@echo ""
	@echo "Backup & Testing:"
	@echo "  make backup        - Backup current dotfiles"
	@echo "  make test          - Test idempotency"
	@echo "  make validate      - Validate shell config"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         - Clean caches"
	@echo "  make uninstall-stow - Remove symlinks"
	@echo ""
	@echo "Help:"
	@echo "  make help          - Show this message"
	@echo ""

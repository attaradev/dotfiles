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
.PHONY: help install update upgrade brew brew-check mise stow vscode gnupg clean doctor status list dump cleanup backup backup-list backup-clean test smoke validate uninstall-stow lint-shell lint-docs check

BUNDLE_ENV_FILE ?= $(HOME)/.config/dotfiles/brew-optional.env
MARKDOWNLINT ?= markdownlint
BREW_BUNDLE_WITH_OPTIONALS = OPTIONAL_CASK_ENV_FILE="$(BUNDLE_ENV_FILE)" ./scripts/run-brew-bundle.sh
BACKUP_ARTIFACTS = \
	$(HOME)/dotfiles-backup-* \
	$(HOME)/.zshrc.backup \
	$(HOME)/.gitconfig.backup \
	$(HOME)/.npmrc.backup \
	$(HOME)/.mise.toml.backup \
	$(HOME)/.ssh/config.backup \
	$(HOME)/.gnupg/gpg-agent.conf.backup \
	$(HOME)/.gnupg/gpg.conf.backup \
	$(HOME)/.gnupg/gpg-agent.conf.bak.* \
	$(HOME)/.gnupg/gpg.conf.bak.*

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
	@$(BREW_BUNDLE_WITH_OPTIONALS) install --verbose

## brew-check: Verify all Brewfile packages are installed
brew-check:
	@echo "✓ Checking Brewfile packages..."
	@$(BREW_BUNDLE_WITH_OPTIONALS) check || (echo "❌ Some packages are missing. Run 'make brew' to install." && exit 1)

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
	@if command -v brew >/dev/null 2>&1; then \
		brew doctor; \
	else \
		echo "Homebrew not installed"; \
	fi
	@echo ""
	@echo "🔧 mise Doctor:"
	@if command -v mise >/dev/null 2>&1; then \
		mise doctor; \
	else \
		echo "mise not installed"; \
	fi
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
	@if command -v mise >/dev/null 2>&1; then \
		mise --version; \
	else \
		echo "Not installed"; \
	fi
	@echo ""
	@echo "📦 mise-managed tools:"
	@if command -v mise >/dev/null 2>&1; then \
		mise list; \
	else \
		echo "mise not installed"; \
	fi
	@echo ""
	@echo "🐚 Shell:"
	@echo "$$SHELL"
	@echo ""
	@echo "💻 macOS:"
	@sw_vers -productVersion
	@echo ""

## list: List installed mise tools and versions
list:
	@if command -v mise >/dev/null 2>&1; then \
		mise list; \
	else \
		echo "mise not installed. Run 'make mise' to install."; \
		exit 1; \
	fi

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
	@$(BREW_BUNDLE_WITH_OPTIONALS) cleanup --force --file=./Brewfile
	@echo "✓ Cleanup complete!"

# ============================================
# Backup & Restore
# ============================================

## backup: Create backup of current dotfiles
backup:
	@echo "💾 Creating backup of dotfiles..."
	@timestamp=$$(date +%Y%m%d-%H%M%S); \
	backup_dir="$$HOME/dotfiles-backup-$$timestamp"; \
	mkdir -p "$$backup_dir"; \
	cp -r "$$HOME/.zshrc" "$$backup_dir/" 2>/dev/null || true; \
	cp -r "$$HOME/.zshrc.local" "$$backup_dir/" 2>/dev/null || true; \
	cp -r "$$HOME/.config" "$$backup_dir/" 2>/dev/null || true; \
	echo "✓ Backup created in $$backup_dir"

## backup-list: Show backup files and directories created by dotfiles scripts
backup-list:
	@echo "📋 Backup artifacts:"
	@found=0; \
	for path in $(BACKUP_ARTIFACTS); do \
		if [ -e "$$path" ]; then \
			found=1; \
			if [ -d "$$path" ]; then \
				echo "  [dir]  $$path"; \
			else \
				echo "  [file] $$path"; \
			fi; \
		fi; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "  (none found)"; \
	fi

## backup-clean: Remove backup files/directories (prompts unless CONFIRM=1)
backup-clean:
	@if [ "$${CONFIRM:-0}" != "1" ]; then \
		if [ -t 0 ]; then \
			printf "⚠️  Delete all backup artifacts? [y/N] "; \
			read -r answer; \
			case "$$answer" in \
				[Yy]|[Yy][Ee][Ss]) ;; \
				*) echo "ℹ️  Backup cleanup cancelled."; exit 0 ;; \
			esac; \
		else \
			echo "❌ Non-interactive shell detected. Run: make backup-clean CONFIRM=1"; \
			exit 1; \
		fi; \
	fi
	@echo "🧹 Removing backup artifacts..."
	@removed=0; \
	for path in $(BACKUP_ARTIFACTS); do \
		if [ -e "$$path" ]; then \
			rm -rf "$$path"; \
			echo "  removed $$path"; \
			removed=1; \
		fi; \
	done; \
	if [ "$$removed" -eq 0 ]; then \
		echo "ℹ️  No backup artifacts found."; \
	else \
		echo "✓ Backup artifacts removed"; \
	fi

# ============================================
# Testing & Validation
# ============================================

## test: Run idempotency test (safe to run multiple times)
test:
	@echo "🧪 Testing dotfiles idempotency..."
	@echo ""
	@echo "Running setup in check mode..."
	@$(BREW_BUNDLE_WITH_OPTIONALS) check --verbose
	@echo ""
	@echo "✅ Idempotency test passed!"

## smoke: Run mocked end-to-end setup + Makefile smoke checks
smoke:
	@bash ./scripts/ci-smoke-setup.sh

## validate: Validate shell configuration
validate:
	@echo "✓ Validating shell configuration..."
	@zsh -n ~/.zshrc
	@echo "✓ .zshrc syntax is valid"
	@if [ -f ~/.zshrc.local ]; then \
		zsh -n ~/.zshrc.local; \
		echo "✓ .zshrc.local syntax is valid"; \
	else \
		echo "ℹ️  No .zshrc.local found (optional)"; \
	fi

## lint-shell: Validate shell syntax in scripts and zsh config
lint-shell:
	@echo "🔎 Linting shell scripts..."
	@for file in $$(find . -maxdepth 1 -type f -name '*.sh' | sort); do \
		bash -n "$$file"; \
	done
	@if [ -d "./scripts" ]; then \
		for file in $$(find ./scripts -type f -name '*.sh' | sort); do \
			bash -n "$$file"; \
		done; \
	fi
	@command -v zsh >/dev/null 2>&1 || (echo "❌ zsh not found; required for zsh syntax check." && exit 1)
	@zsh -n zsh/.zshrc
	@echo "✓ Shell syntax checks passed"

## lint-docs: Validate Markdown documentation formatting
lint-docs:
	@echo "📝 Linting Markdown docs..."
	@command -v $(MARKDOWNLINT) >/dev/null 2>&1 || (echo "❌ markdownlint not found. Install with 'npm install -g markdownlint-cli'." && exit 1)
	@docs=$$(find . -maxdepth 2 -type f -name '*.md' | sort); \
	$(MARKDOWNLINT) $$docs
	@echo "✓ Markdown lint checks passed"

## check: Run local quality gate used by CI
check: lint-shell lint-docs
	@echo "🧪 Running repository quality checks..."
	@./scripts/check-readme-make-targets.sh
	@./scripts/check-no-absolute-host-paths.sh
	@echo "✅ All checks passed!"

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
	@echo "  make backup-list   - Show backup files/directories"
	@echo "  make backup-clean  - Prompt to delete backups (or use CONFIRM=1)"
	@echo "  make test          - Test idempotency"
	@echo "  make smoke         - Run mocked smoke checks"
	@echo "  make validate      - Validate shell config"
	@echo "  make lint-shell    - Lint shell scripts"
	@echo "  make lint-docs     - Lint markdown docs"
	@echo "  make check         - Run all quality checks"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         - Clean caches"
	@echo "  make uninstall-stow - Remove symlinks"
	@echo ""
	@echo "Help:"
	@echo "  make help          - Show this message"
	@echo ""

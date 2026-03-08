# ============================================
# Dotfiles Makefile
# ============================================
# Convenient shortcuts for managing your macOS development environment
#
# Usage:
#   make install    # Full setup (first time)
#   make update     # Update Homebrew and mise-managed packages
#   make help       # Show all available commands

.DEFAULT_GOAL := help
.PHONY: help install setup update upgrade brew brew-check mise stow agents obsidian obsidian-lock obsidian-clean vscode gnupg clean doctor status list dump cleanup backup backup-list backup-clean test smoke validate uninstall-stow lint-shell lint-docs check

BUNDLE_ENV_FILE ?= $(HOME)/.config/dotfiles/brew-optional.env
MARKDOWNLINT ?= markdownlint
BREW_BUNDLE_WITH_OPTIONALS = OPTIONAL_CASK_ENV_FILE="$(BUNDLE_ENV_FILE)" ./scripts/run-brew-bundle.sh
STOW_PACKAGES = zsh git npm starship ssh gpg claude codex
BACKUP_ARTIFACTS = \
	$(HOME)/dotfiles-backup-* \
	$(HOME)/.zshrc.backup \
	$(HOME)/.gitconfig.backup \
	$(HOME)/.npmrc.backup \
	$(HOME)/.mise.toml.backup \
	$(HOME)/.ssh/config.backup \
	$(HOME)/.claude/CLAUDE.md.backup \
	$(HOME)/.claude/settings.json.backup \
	$(HOME)/.codex/AGENTS.md.backup \
	$(HOME)/.codex/config.toml.backup \
	$(HOME)/.knowledge.backup.* \
	$(HOME)/.knowledge/hub.md.backup \
	$(HOME)/.knowledge/tasks.md.backup \
	$(HOME)/.knowledge/projects/projects.md.backup \
	$(HOME)/.knowledge/reading/books.md.backup \
	$(HOME)/.knowledge/reading/articles.md.backup \
	$(HOME)/.knowledge/learning/courses.md.backup \
	$(HOME)/.knowledge/learning/studies.md.backup \
	$(HOME)/.knowledge/learning/lessons.md.backup \
	$(HOME)/.knowledge/career/achievement-log.md.backup \
	$(HOME)/.knowledge/setup/obsidian-plugins.md.backup \
	$(HOME)/.knowledge/_templates/*.md.backup \
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

## setup: Re-apply idempotent dotfiles setup after pulling changes
setup:
	@echo "🔁 Re-applying idempotent setup tasks..."
	@$(MAKE) --no-print-directory mise
	@$(MAKE) --no-print-directory stow
	@$(MAKE) --no-print-directory obsidian
	@$(MAKE) --no-print-directory gnupg
	@if command -v code >/dev/null 2>&1; then \
		$(MAKE) --no-print-directory vscode; \
	else \
		echo "⚠️  VSCode CLI 'code' not found. Skipping extensions refresh."; \
	fi
	@echo "✅ Setup refresh complete!"

## brew: Install/update packages from Brewfile
brew:
	@echo "📦 Installing packages from Brewfile..."
	@$(BREW_BUNDLE_WITH_OPTIONALS) install --verbose

## brew-check: Verify all Brewfile packages are installed
brew-check:
	@echo "✓ Checking Brewfile packages..."
	@$(BREW_BUNDLE_WITH_OPTIONALS) check --no-upgrade || (echo "❌ Some packages are missing. Run 'make brew' to install." && exit 1)

## mise: Setup mise and install language runtimes
mise:
	@echo "🔧 Setting up mise..."
	@bash ./scripts/setup-mise.sh

## stow: Create symlinks for dotfiles
stow:
	@echo "🔗 Creating dotfile symlinks..."
	@bash ./scripts/setup-stow.sh

## agents: Refresh Claude/Codex configs
agents:
	@echo "🤖 Refreshing Claude/Codex configs..."
	@bash ./scripts/setup-stow.sh claude codex

## obsidian: Setup Knowledge vault and install/update Obsidian plugins
obsidian:
	@echo "🧠 Setting up Knowledge vault and Obsidian plugins..."
	@bash ./scripts/setup-obsidian.sh

## obsidian-lock: Refresh pinned Obsidian plugin lock file with latest release hashes
obsidian-lock:
	@echo "🔒 Refreshing pinned Obsidian plugin lock file..."
	@bash ./scripts/refresh-obsidian-plugin-lock.sh

## obsidian-clean: Remove unmanaged Obsidian community plugin directories
obsidian-clean:
	@echo "🧹 Cleaning unmanaged Obsidian plugins..."
	@bash ./scripts/cleanup-obsidian-plugins.sh

## vscode: Install VSCode extensions
vscode:
	@echo "🎨 Installing VSCode extensions..."
	@bash ./scripts/setup-vscode.sh

## gnupg: Setup GnuPG (GPG)
gnupg:
	@echo "🔐 Setting up GnuPG..."
	@bash ./scripts/setup-gnupg.sh

# ============================================
# Updates & Maintenance
# ============================================

## update: Update Homebrew and mise-managed packages
update:
	@echo "⬆️  Updating package managers and managed packages..."
	@echo ""
	@echo "📦 Updating Homebrew..."
	@brew update
	@brew upgrade
	@echo ""
	@echo "🔧 Updating mise..."
	@brew upgrade mise
	@echo ""
	@echo "⚡ Upgrading mise-managed tools..."
	@mise upgrade --exclude npm
	@if mise current npm >/dev/null 2>&1; then \
		echo "📦 Upgrading npm via npm backend..."; \
		mise upgrade npm:npm; \
	else \
		echo "ℹ️  npm is not managed by mise in current config; skipping npm backend upgrade."; \
	fi
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
	@docs=$$(find . -maxdepth 2 \( -path './.agent' -o -path './.claude' \) -prune -o -type f -name '*.md' -print | sort); \
	if command -v $(MARKDOWNLINT) >/dev/null 2>&1 && $(MARKDOWNLINT) --version >/dev/null 2>&1; then \
		$(MARKDOWNLINT) $$docs; \
	elif command -v mise >/dev/null 2>&1; then \
		echo "ℹ️  Falling back to 'mise x node -- npx --yes markdownlint-cli'."; \
		mise x node -- npx --yes markdownlint-cli $$docs; \
	else \
		echo "❌ markdownlint is unavailable and mise fallback is not installed."; \
		echo "   Install with 'npm install -g markdownlint-cli' or run 'make mise'."; \
		exit 1; \
	fi
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
	@for package in $(STOW_PACKAGES); do \
		stow -D "$$package" --target="$(HOME)" || true; \
	done
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
	@echo "  make install       	- Full setup (first time)"
	@echo "  make setup         	- Re-apply idempotent setup after config changes"
	@echo "  make brew          	- Install packages from Brewfile"
	@echo "  make brew-check    	- Verify Brewfile packages"
	@echo "  make mise          	- Setup mise version manager"
	@echo "  make stow          	- Create dotfile symlinks"
	@echo "  make agents        	- Refresh Claude/Codex configs"
	@echo "  make obsidian      	- Configure Obsidian vault + plugins"
	@echo "  make obsidian-lock 	- Refresh pinned Obsidian plugin lock"
	@echo "  make obsidian-clean	- Remove unmanaged Obsidian plugin dirs"
	@echo "  make vscode        	- Install VSCode extensions"
	@echo "  make gnupg         	- Setup GnuPG"
	@echo ""
	@echo "Updates & Maintenance:"
	@echo "  make update        	- Update Homebrew and mise-managed packages"
	@echo "  make upgrade       	- Alias for update"
	@echo ""
	@echo "Diagnostics & Status:"
	@echo "  make doctor        	- Run health checks"
	@echo "  make status        	- Show system status"
	@echo "  make list          	- List mise tools"
	@echo ""
	@echo "Brewfile Management:"
	@echo "  make dump          	- Generate Brewfile from system"
	@echo "  make cleanup       	- Remove unlisted packages"
	@echo ""
	@echo "Backup & Testing:"
	@echo "  make backup        	- Backup current dotfiles"
	@echo "  make backup-list   	- Show backup files/directories"
	@echo "  make backup-clean  	- Prompt to delete backups (or use CONFIRM=1)"
	@echo "  make test          	- Test idempotency"
	@echo "  make smoke         	- Run mocked smoke checks"
	@echo "  make validate      	- Validate shell config"
	@echo "  make lint-shell    	- Lint shell scripts"
	@echo "  make lint-docs     	- Lint markdown docs"
	@echo "  make check         	- Run all quality checks"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         	- Clean caches"
	@echo "  make uninstall-stow 	- Remove symlinks"
	@echo ""
	@echo "Help:"
	@echo "  make help          	- Show this message"
	@echo ""

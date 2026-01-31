# ============================================
# Brewfile - Declarative Package Management
# ============================================
#
# My essential development tools and applications for macOS.
# Organized by category for easy maintenance and understanding.
#
# Usage:
#   brew bundle install              # Install all packages
#   brew bundle check                # Verify all packages are installed
#   brew bundle cleanup              # Remove packages not in Brewfile
#   brew bundle dump --force         # Regenerate from current system (use with caution)
#
# Note: Language runtimes (Node.js, Python, Go, Ruby, pnpm) are managed via mise,
#       not Homebrew. See install_mise.sh for runtime management.
# Optional casks are gated by environment variables (see Installation Notes).

# ============================================
# Homebrew Taps
# ============================================
tap "hashicorp/tap"

def optional_enabled?(key)
  value = ENV["HOMEBREW_BUNDLE_INSTALL_#{key}"] || ENV["BREW_INSTALL_#{key}"]
  value.to_s == "1"
end

# ============================================
# Version Control & Collaboration
# ============================================

brew "gh"                           # GitHub CLI - Official GitHub command-line tool
brew "git-flow"                     # Git extensions for Vincent Driessen's branching model

# ============================================
# Security & Encryption
# ============================================

brew "gnupg"                        # GNU Privacy Guard - Encryption and signing tool
brew "pinentry-mac"                 # Native macOS passphrase entry dialog for GnuPG
brew "mkcert"                       # Simple zero-config tool for locally-trusted development certificates
brew "git-crypt"                    # Transparent file encryption in git repositories
brew "age"                          # Simple, modern, and secure file encryption tool
brew "ssh-audit"                    # SSH server & client security auditing
brew "lynis"                        # Security auditing tool for Unix-based systems
brew "trivy"                        # Vulnerability scanner for containers and IaC
brew "gitleaks"                     # Scan git repos for secrets and credentials
brew "ykman"                        # YubiKey Manager CLI for configuring hardware keys

# ============================================
# Version Management
# ============================================

brew "mise"                         # Unified version manager for Node.js, Python, Go, Ruby, etc.
                                    # Replaces nvm, pyenv, rbenv, goenv with a single fast tool
                                    # Configure via: install_mise.sh

# ============================================
# Cloud & Infrastructure
# ============================================

# AWS
brew "awscli"                       # AWS Command Line Interface

# Terraform
brew "hashicorp/tap/terraform"      # Infrastructure as Code tool

# Kubernetes
brew "kubectl"                      # Kubernetes command-line tool
brew "helm"                         # Kubernetes package manager
brew "eksctl"                       # CLI for creating Kubernetes clusters on AWS
brew "minikube"                     # Run Kubernetes clusters locally
brew "kind"                         # Kubernetes IN Docker - local clusters for testing
brew "k3d"                          # Create and manage k3s clusters in Docker
brew "tilt"                         # Local development environment orchestration tool

# ============================================
# Databases & Data Tools
# ============================================

brew "libpq"                        # PostgreSQL C API library (for psql CLI)

# ============================================
# Modern CLI Tools
# ============================================
# Enhanced replacements for standard Unix tools with better UX

# File & Directory Navigation
brew "eza"                          # Modern 'ls' with colors, icons, and Git integration
brew "fd"                           # Fast, user-friendly 'find' alternative
brew "zoxide"                       # Smarter 'cd' that learns your habits

# File Viewing & Search
brew "bat"                          # 'cat' clone with syntax highlighting and Git integration
brew "ripgrep"                      # Ultra-fast 'grep' alternative, respects .gitignore
brew "fzf"                          # Command-line fuzzy finder (Ctrl+R for history)

# Data Processing & Documentation
brew "jq"                           # Lightweight JSON processor
brew "tlrc"                         # Maintained TLDR client (tldr deprecated upstream)

# Presentation
brew "slides"                       # Terminal-based presentations using Markdown

# ============================================
# Shell & Terminal
# ============================================

brew "starship"                     # Minimal, fast, customizable cross-shell prompt
brew "tmux"                         # Terminal multiplexer
brew "zsh-autosuggestions"          # Fish-like autosuggestions for zsh
brew "zsh-syntax-highlighting"      # Real-time syntax highlighting for zsh

# ============================================
# System Libraries
# ============================================
# Note: Most system libraries are installed automatically as dependencies.
# Only list libraries you explicitly need for development.

brew "openssl@3"                    # Cryptography and SSL/TLS toolkit
brew "readline"                     # Library for command-line editing
brew "libyaml"                      # YAML parser/headers required for Ruby psych extension
brew "pkg-config"                   # Manage compile and link flags for libraries

# ============================================
# Dotfile Management
# ============================================

brew "stow"                         # Symlink farm manager for organizing dotfiles

# ============================================
# GUI Applications
# ============================================

# --- Development Tools ---
cask "visual-studio-code"           # Powerful, extensible code editor
cask "claude-code"                  # AI-powered coding assistant with CLI integration
cask "codex"                        # AI-powered coding assistant
cask "antigravity" if optional_enabled?("ANTIGRAVITY")    # AI coding agent IDE
cask "postman"                      # API development and testing platform
cask "postgres-unofficial"          # PostgreSQL database (Postgres.app) - supports multiple versions

# --- Containers & Virtualization ---
cask "docker-desktop"               # Containerization platform (includes Docker CLI and daemon)
cask "virtualbox" if optional_enabled?("VIRTUALBOX")      # Full VM hypervisor for running multiple OS environments

# --- Development Utilities ---
cask "ngrok"                        # Secure tunnels to localhost (general HTTP/HTTPS tunneling)
cask "jetbrains-toolbox"            # JetBrains Toolbox to manage JetBrains IDEs
cask "termius"                      # Cross-platform SSH client and terminal manager

# --- Fonts ---
cask "font-jetbrains-mono-nerd-font" # Patched Nerd Font so terminal icons render correctly

# --- Web Browsers ---
cask "brave-browser" if optional_enabled?("BRAVE_BROWSER") # Privacy-focused browser with built-in ad blocking
cask "google-chrome"                # Popular web browser with extensive DevTools

# --- Communication & Productivity ---
cask "slack"                        # Team communication and collaboration
cask "zoom"                         # Video conferencing and virtual meetings

# --- Media & Entertainment ---
cask "spotify" if optional_enabled?("SPOTIFY")            # Music streaming service
cask "vlc" if optional_enabled?("VLC")                    # Versatile media player supporting all formats

# ============================================
# Installation Notes
# ============================================
#
# After running 'brew bundle install':
#
# 1. Configure mise:
#    ./install_mise.sh
#
# 2. Setup dotfiles with GNU Stow:
#    ./stow_setup.sh
#
# 3. Configure GnuPG:
#    ./setup_gnupg.sh
#
# 4. Install VSCode extensions (optional):
#    ./vscode_setup.sh
#
# Optional casks (skipped by default; setup.sh will prompt, or set env var to install):
#   HOMEBREW_BUNDLE_INSTALL_ANTIGRAVITY=1 brew bundle install
#   HOMEBREW_BUNDLE_INSTALL_VIRTUALBOX=1 brew bundle install
#   HOMEBREW_BUNDLE_INSTALL_BRAVE_BROWSER=1 brew bundle install
#   HOMEBREW_BUNDLE_INSTALL_VLC=1 brew bundle install
#   HOMEBREW_BUNDLE_INSTALL_SPOTIFY=1 brew bundle install
#
# Or run everything at once:
#    make install
#

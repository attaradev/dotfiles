# Brewfile - Declarative package management for Homebrew
#
# This Brewfile defines my essential development tools and applications for macOS.
#
# Usage:
#   brew bundle install              # Install all packages
#   brew bundle check                # Verify all packages are installed
#   brew bundle cleanup              # Remove packages not in Brewfile
#   brew bundle dump --force         # Regenerate from current system (use with caution)

# Taps
tap "homebrew/bundle"
tap "homebrew/cask"
tap "hashicorp/tap"

# ============================================
# Core Development Tools
# ============================================

# GitHub CLI - Official GitHub command-line tool
brew "gh"

# GNU Privacy Guard - Encryption and signing tool
brew "gnupg"

# Pinentry for macOS - Native passphrase entry dialog for GnuPG
brew "pinentry-mac"

# Version management (unified tool for all languages)
# Note: Use mise to manage Node.js, Python, Go, Ruby, and their package managers
brew "mise"

# Infrastructure as Code
brew "hashicorp/tap/terraform"

# AWS Command Line Interface
brew "awscli"

# Kubernetes command-line tool
brew "kubectl"

# Simple command-line tool for creating Kubernetes clusters on AWS
brew "eksctl"

# Kubernetes package manager
brew "helm"

# Run local Kubernetes clusters
brew "minikube"

# Kubernetes IN Docker - local clusters for testing
brew "kind"

# PostgreSQL C API library
brew "libpq"

# ============================================
# Modern CLI Replacements
# ============================================

# Modern replacement for 'ls' with colors and icons
brew "eza"

# Clone of cat with syntax highlighting
brew "bat"

# Simple, fast alternative to 'find'
brew "fd"

# Search tool like grep and The Silver Searcher
brew "ripgrep"

# Command-line fuzzy finder
brew "fzf"

# Smarter cd command inspired by z and autojump
brew "zoxide"

# Simplified and community-driven man pages
brew "tldr"

# Lightweight and flexible command-line JSON processor
brew "jq"

# Terminal-based presentations using Markdown
brew "slides"

# ============================================
# Shell & Terminal
# ============================================

# Cross-shell prompt written in Rust
brew "starship"

# Terminal multiplexer
brew "tmux"

# Fish-like autosuggestions for zsh
brew "zsh-autosuggestions"

# Fish shell-like syntax highlighting for zsh
brew "zsh-syntax-highlighting"

# ============================================
# System Libraries & Dependencies
# ============================================
# Note: Most system libraries are installed automatically as dependencies.
# Only list libraries you explicitly need for development.

# OpenSSL for secure communications
brew "openssl@3"

# Readline for interactive command line editing
brew "readline"

# ============================================
# GNU Stow - Symlink farm manager for dotfiles
# ============================================
brew "stow"

# ============================================
# Development Utilities
# ============================================

# Extensions to git for managing releases
brew "git-flow"

# Simple zero-config tool for making locally-trusted development certificates
brew "mkcert"

# ============================================
# GUI Applications
# ============================================

# --- Development Tools ---

# Visual Studio Code - Code editor
cask "visual-studio-code"

# API development and testing tool
cask "postman"

# PostgreSQL database (postgres.app)
cask "postgres-unofficial"

# --- Containers & Virtualization ---

# Docker Desktop - Containerization platform
cask "docker-desktop"

# VirtualBox - Virtual machine hypervisor
cask "virtualbox"

# --- Development Utilities ---

# ngrok - Secure tunnels to localhost
cask "ngrok"

# --- Web Browsers ---

# Brave Browser - Privacy-focused web browser
cask "brave-browser"

# Google Chrome web browser
cask "google-chrome"

# --- Communication & Productivity ---

# Team communication and collaboration
cask "slack"

# Video conferencing
cask "zoom"

# --- Media & Entertainment ---

# Music streaming service
cask "spotify"

# Media player
cask "vlc"

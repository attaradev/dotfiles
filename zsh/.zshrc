# ============================================
# ZSH Configuration
# ============================================

# Performance: disable auto-update checks
DISABLE_AUTO_UPDATE="true"

# ============================================
# Homebrew Setup
# ============================================
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================
# History Configuration
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
# Robust OMZ-style history prefix search on arrows with fallbacks; avoid autosuggest wrapping errors
autoload -Uz history-beginning-search-backward-end history-beginning-search-forward-end \
  history-beginning-search-backward history-beginning-search-forward 2>/dev/null
if zle -l | grep -q '^history-beginning-search-backward-end$'; then
  zle -N history-beginning-search-backward-end
  zle -N history-beginning-search-forward-end
  _hist_up_widget=history-beginning-search-backward-end
  _hist_down_widget=history-beginning-search-forward-end
else
  autoload -Uz history-beginning-search-backward history-beginning-search-forward
  zle -N history-beginning-search-backward
  zle -N history-beginning-search-forward
  _hist_up_widget=history-beginning-search-backward
  _hist_down_widget=history-beginning-search-forward
fi
bindkey '^[[A' $_hist_up_widget   # up arrow
bindkey '^[[B' $_hist_down_widget # down arrow
bindkey '^[OA' $_hist_up_widget   # up arrow (alternate)
bindkey '^[OB' $_hist_down_widget # down arrow (alternate)

# ============================================
# ZSH Options
# ============================================
setopt AUTO_CD              # cd by typing directory name
setopt CORRECT              # command correction
setopt COMPLETE_IN_WORD     # complete from both ends of a word
setopt ALWAYS_TO_END        # move cursor to end if word had one match

# ============================================
# Completion System
# ============================================
autoload -Uz compinit
# Only check compinit once a day for performance
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ============================================
# mise (Unified version manager)
# ============================================
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"

  # Setup pnpm path if installed via mise
  export PNPM_HOME="$HOME/.local/share/mise/installs/pnpm/latest/bin"
  if [[ -d "$PNPM_HOME" ]]; then
    export PATH="$PNPM_HOME:$PATH"
  fi
fi

# ============================================
# Zoxide (Smart cd)
# ============================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# ============================================
# FZF (Fuzzy finder)
# ============================================
if command -v fzf &> /dev/null; then
  # Set up fzf key bindings
  eval "$(fzf --zsh)"

  # Use fd instead of find for fzf
  if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ============================================
# ZSH Plugins (via Homebrew)
# ============================================

# Fast syntax highlighting (loaded via Homebrew)
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Fish-like autosuggestions (loaded via Homebrew)
if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # Performance: async suggestions
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  # Suggest from history only
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# ============================================
# Aliases
# ============================================

# Modern CLI replacements
if command -v eza &> /dev/null; then
  alias l='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias tree='eza --tree --icons'
fi

if command -v bat &> /dev/null; then
  alias cat='bat'
fi

if command -v fd &> /dev/null; then
  alias f='fd'
fi

# Starship
if command -v starship &> /dev/null; then
  alias ss='starship'
fi

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gpl='git pull'
alias gst='git stash'
alias gsta='git stash apply'
alias gcl='git clone'
alias gsw='git switch'


# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Utility
alias reload='source ~/.zshrc'
alias zshconfig='code ~/.zshrc'
alias dotfiles='cd ~/.dotfiles'

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewdump='brew bundle dump --force --describe --file=~/.dotfiles/Brewfile'

# pnpm (preferred over npm)
alias pn='pnpm'
alias pni='pnpm install'
alias pna='pnpm add'
alias pnd='pnpm add -D'
alias pnr='pnpm remove'
alias pnx='pnpm dlx'
alias pnu='pnpm update'
alias pnb='pnpm build'
alias pndev='pnpm dev'
alias pnstart='pnpm start'
alias pntest='pnpm test'

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias dprune='docker system prune -a'
alias dbuild='docker build -t'
alias dexec='docker exec -it'
alias dlogs='docker logs'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcdv='docker compose down -v'

# VSCode
alias c='code .'

# ============================================
# Environment Variables
# ============================================

# Editor
export EDITOR='code'
export VISUAL='code'

# Better colors for ls
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# GPG TTY (for signing commits)
export GPG_TTY=$(tty)

# ============================================
# Security Enhancements
# ============================================

# Prevent accidental file overwrites
setopt NO_CLOBBER

# Warn about background jobs on exit
setopt CHECK_JOBS

# Don't save commands that start with space to history (for sensitive commands)
setopt HIST_IGNORE_SPACE

# Security: Strict umask (files: 644, dirs: 755)
umask 022

# Security: Limit core dump size to 0
ulimit -c 0

# Security: Clear sensitive environment variables on exit
trap 'unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY NPM_TOKEN' EXIT

# Security: SSH agent socket permissions
if [ -S "$SSH_AUTH_SOCK" ]; then
  chmod 600 "$SSH_AUTH_SOCK" 2>/dev/null || true
fi

# Security: Verify SSH host keys
export SSH_ASKPASS_REQUIRE=prefer

# ============================================
# Starship Prompt (must be at the end)
# ============================================
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================
# Local customizations (not version controlled)
# ============================================
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

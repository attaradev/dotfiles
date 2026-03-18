# Loaded by all zsh shells (interactive, non-interactive, login, scripts).
# Keep this file minimal — only settings that must be visible everywhere.

# Docker Desktop detects completions via a non-interactive zsh that reads only
# ~/.zshenv, not ~/.zshrc. Declaring the completion path here satisfies that
# check while ~/.zshrc handles the full interactive setup.
fpath=("${HOME:A}/.docker/completions" $fpath)

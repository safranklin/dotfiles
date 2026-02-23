#!/bin/zsh

# ═══════════════════════════════════════════
#       ENVIRONMENT BOOTSTRAP (.zshenv)
# ═══════════════════════════════════════════
# Loaded before .zshrc — sets up PATH fundamentals
# so that brew, go, etc. are available everywhere.

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

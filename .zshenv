#!/bin/zsh

# ═══════════════════════════════════════════
#       ENVIRONMENT BOOTSTRAP (.zshenv)
# ═══════════════════════════════════════════
# Loaded before .zshrc — sets up PATH fundamentals
# so that brew, go, etc. are available everywhere.

# Homebrew (different install paths per platform)
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f /opt/homebrew/bin/brew ]]; then
   eval "$(/opt/homebrew/bin/brew shellenv)"
fi

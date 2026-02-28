#!/bin/zsh

# ═══════════════════════════════════════════
#         Application specific settings
# ═══════════════════════════════════════════

# SSH_AUTH_SOCK is set in .zshenv (needs to be available to non-interactive shells)
# The WSL socat bridge is started in .zshrc on first interactive shell

# ─────────────────────────────────────────────
# Application-Specific Settings
# ─────────────────────────────────────────────

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# ─────────────────────────────────────────────
# Environment Defaults
# ─────────────────────────────────────────────

export EDITOR="code"
export LESS="--RAW-CONTROL-CHARS --mouse"

if [[ $PLATFORM == macos ]]; then
   export BROWSER="open"
elif [[ $PLATFORM == wsl ]]; then
   export BROWSER="wslview"
else
   export BROWSER="xdg-open"
fi

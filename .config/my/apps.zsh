#!/bin/zsh

# ═══════════════════════════════════════════
#         Application specific settings
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# SSH Agent Configuration
# ─────────────────────────────────────────────

# WSL agent is set up in .zshrc (needs to be available before plugins load)
if [[ $PLATFORM == macos ]]; then
   # macOS: Bitwarden SSH agent
   export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
fi

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

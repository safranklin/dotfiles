#!/bin/zsh

# ═══════════════════════════════════════════
#         Application specific settings
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# SSH Agent Configuration (bitwarden desktop app)
# ─────────────────────────────────────────────
export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock

# ─────────────────────────────────────────────
# Application-Specific Settings
# ─────────────────────────────────────────────

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Add application-specific environment variables here
# export EDITOR="code"
# export BROWSER="open"

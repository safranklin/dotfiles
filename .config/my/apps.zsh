#!/bin/zsh

# ═══════════════════════════════════════════
#         Application specific settings
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# SSH Agent Configuration
# ─────────────────────────────────────────────

# WSL: Bridge to Windows OpenSSH agent via npiperelay
[[ -f ~/scripts/agent-bridge.sh ]] && source ~/scripts/agent-bridge.sh

# macOS Bitwarden (disabled on WSL)
# export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock

# ─────────────────────────────────────────────
# Application-Specific Settings
# ─────────────────────────────────────────────

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Add application-specific environment variables here
# export EDITOR="code"
# export BROWSER="open"

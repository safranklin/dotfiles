#!/bin/zsh

# ═══════════════════════════════════════════
#         Application specific settings
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# SSH Agent Configuration
# ─────────────────────────────────────────────

if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
   # WSL: Bridge to Windows OpenSSH agent via npiperelay
   [[ -f ~/scripts/agent-bridge.sh ]] && source ~/scripts/agent-bridge.sh
elif [[ "$OSTYPE" == darwin* ]]; then
   # macOS: Bitwarden SSH agent
   export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
fi

# ─────────────────────────────────────────────
# Application-Specific Settings
# ─────────────────────────────────────────────

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Add application-specific environment variables here
# export EDITOR="code"
# export BROWSER="open"

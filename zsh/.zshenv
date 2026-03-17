#!/bin/zsh

# ═══════════════════════════════════════════
#       ENVIRONMENT BOOTSTRAP (.zshenv)
# ═══════════════════════════════════════════
# Loaded before .zshrc for ALL shell invocations
# (interactive, non-interactive, scripts, subshells).

# Homebrew (different install paths per platform)
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f /opt/homebrew/bin/brew ]]; then
   eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# SSH agent socket — must be set here so non-interactive shells
# (git signing from editors, CI tools, etc.) can find the agent.
if [[ -n "$WSL_DISTRO_NAME" ]]; then
   export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
elif [[ "$OSTYPE" == darwin* ]]; then
   export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
fi

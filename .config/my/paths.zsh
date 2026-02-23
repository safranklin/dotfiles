#!/bin/zsh

# ═══════════════════════════════════════════
#            PATH CONFIGURATION
# ═══════════════════════════════════════════
# Add commonly used directories to $PATH, help applications
# find configuration files, and set up non-sensitive environment variables.
# Order matters - earlier entries take precedence

# ─────────────────────────────────────────────
# Language Runtime Paths
# ─────────────────────────────────────────────

# Python unversioned symlinks (python, pip, python-config)
# Homebrew Python provides unversioned symlinks pointing to python3
if [[ -n "$BREW_PREFIX" ]]; then
   export PATH="$BREW_PREFIX/opt/python/libexec/bin:$PATH"
fi

# Go
export PATH=$PATH:/usr/local/go/bin
if command -v go &>/dev/null; then
   export PATH=$PATH:$(go env GOPATH)/bin
fi

# Rust (via Homebrew rustup)
if [[ -n "$BREW_PREFIX" ]]; then
   export PATH="$BREW_PREFIX/opt/rustup/bin:$PATH"
fi

# ─────────────────────────────────────────────
# Package Managers & Runtime Tools
# ─────────────────────────────────────────────

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# UV / pipx
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────
# GPU / ML (WSL only)
# ─────────────────────────────────────────────

if [[ -d /usr/local/cuda ]]; then
   export CUDA_HOME=$(readlink -f /usr/local/cuda)
   export PATH="$CUDA_HOME/bin:$PATH"
fi

# ─────────────────────────────────────────────
# User-Specific Binaries
# ─────────────────────────────────────────────

# Personal scripts and executables
# This should typically be last to allow override of system tools
export PATH=$HOME/bin:$PATH

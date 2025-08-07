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
export PATH=$(brew --prefix python)/libexec/bin:$PATH

# ─────────────────────────────────────────────
# Programming Language Environments
# ─────────────────────────────────────────────

# Cargo/Rust, Go, Node.js, Python, Ruby, etc.

# ─────────────────────────────────────────────
# Package Managers & Runtime Tools
# ─────────────────────────────────────────────
# Bun, UV, etc.

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# UV
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────
# Mobile Development SDKs
# ─────────────────────────────────────────────

# Android SDK and development tools
# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/platform-tools

# ─────────────────────────────────────────────
# AI & Machine Learning Tools
# ─────────────────────────────────────────────

# LM Studio CLI for local language models
# export PATH="$PATH:$HOME/.lmstudio/bin"

# ─────────────────────────────────────────────
# Cloud Platform SDKs
# ─────────────────────────────────────────────

# Google Cloud SDK, AWS CLI, Azure CLI, etc.

# ─────────────────────────────────────────────
# User-Specific Binaries
# ─────────────────────────────────────────────

# Custom user scripts and binaries

# Personal scripts and executables
# This should typically be last to allow override of system tools
export PATH=$HOME/bin:$PATH
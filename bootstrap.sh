#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════
#         DOTFILES BOOTSTRAP SCRIPT
# ═══════════════════════════════════════════
# Prerequisite: Homebrew must be installed manually first.
#   macOS/Linux: https://brew.sh
# Usage: curl the script or clone the repo, then run:
#   bash bootstrap.sh

DOTFILES_REPO="git@github.com:safranklin/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
GITHUB_USER="safranklin"
GIT_EMAIL="37414077+safranklin@users.noreply.github.com"

# ─────────────────────────────────────────────
# Platform Detection
# ─────────────────────────────────────────────

detect_platform() {
   if [[ "$OSTYPE" == darwin* ]]; then
      echo "macos"
   elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
      echo "wsl"
   else
      echo "linux"
   fi
}

PLATFORM=$(detect_platform)
echo "Detected platform: $PLATFORM"

# ─────────────────────────────────────────────
# Package Installation
# ─────────────────────────────────────────────

install_packages() {
   if ! command -v brew &>/dev/null; then
      echo "Error: Homebrew is required but not found."
      echo "Install it first: https://brew.sh"
      exit 1
   fi

   echo "Installing packages via Homebrew..."

   local packages=(
      zsh
      starship
      eza
      bat
      fd
      ripgrep
      dust
      procs
      htop
      git-delta
      zsh-completions
      zsh-syntax-highlighting
      zsh-autosuggestions
   )

   if [[ "$PLATFORM" == "wsl" ]]; then
      packages+=(wslu)
   fi

   brew install "${packages[@]}"
}

# ─────────────────────────────────────────────
# Default Shell
# ─────────────────────────────────────────────

set_default_shell() {
   local brew_zsh
   brew_zsh="$(brew --prefix)/bin/zsh"

   if [[ ! -x "$brew_zsh" ]]; then
      echo "Warning: Homebrew zsh not found at $brew_zsh, skipping shell change."
      return
   fi

   if ! grep -qF "$brew_zsh" /etc/shells; then
      echo "Adding $brew_zsh to /etc/shells (requires sudo)..."
      echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
   fi

   if [[ "$SHELL" != "$brew_zsh" ]]; then
      echo "Changing default shell to $brew_zsh..."
      chsh -s "$brew_zsh"
   else
      echo "Default shell is already $brew_zsh."
   fi
}

# ─────────────────────────────────────────────
# Dotfiles Checkout
# ─────────────────────────────────────────────

checkout_dotfiles() {
   if [[ -d "$DOTFILES_DIR" ]]; then
      echo "Dotfiles directory already exists at $DOTFILES_DIR, skipping clone."
      return
   fi

   echo "Cloning dotfiles bare repo..."
   git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

   local dotfile_config="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

   echo "Checking out dotfiles..."
   if ! $dotfile_config checkout 2>/dev/null; then
      echo "Conflict with existing files — backing up..."
      $dotfile_config checkout 2>&1 \
         | grep -E "^\s+" \
         | awk '{print $1}' \
         | while read -r file; do
              mkdir -p "$(dirname "$HOME/$file.bak")"
              mv "$HOME/$file" "$HOME/$file.bak"
           done
      $dotfile_config checkout
   fi

   $dotfile_config config --local status.showUntrackedFiles no
   echo "Dotfiles checked out successfully."
}

# ─────────────────────────────────────────────
# Git SSH Signing
# ─────────────────────────────────────────────

setup_signing() {
   echo "Fetching SSH public key from GitHub..."
   local pubkey
   pubkey=$(curl -sf "https://github.com/${GITHUB_USER}.keys" | head -1)

   if [[ -z "$pubkey" ]]; then
      echo "Warning: Could not fetch public key from GitHub. Skipping signing setup."
      return
   fi

   echo "Setting git signing key..."
   git config --global user.signingkey "$pubkey"

   echo "Writing allowed_signers..."
   mkdir -p "$HOME/.ssh"
   echo "${GIT_EMAIL} ${pubkey}" > "$HOME/.ssh/allowed_signers"

   echo "SSH commit signing configured."
}

# ─────────────────────────────────────────────
# Post-Install
# ─────────────────────────────────────────────

print_post_install() {
   echo ""
   echo "══════════════════════════════════════"
   echo "  Bootstrap complete!"
   echo "══════════════════════════════════════"
   echo ""
   echo "Remaining manual steps:"
   echo "  1. Install a Nerd Font (e.g., BerkeleyMono Nerd Font)"
   echo "     https://www.nerdfonts.com/font-downloads"
   echo "  2. Restart your terminal or run: exec zsh"
   echo ""
}

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

install_packages
set_default_shell
checkout_dotfiles
setup_signing
print_post_install

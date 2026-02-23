# Dotfiles

Bare git repo for managing config files across machines. Supports **macOS** and **WSL2/Linux**.

## Quick Start

### Prerequisites

1. Install [Homebrew](https://brew.sh)
2. Install a [Nerd Font](https://www.nerdfonts.com/font-downloads) — I use BerkeleyMono, personally patched with Nerd Font icons and ligatures

### Bootstrap

```bash
git clone git@github.com:safranklin/dotfiles.git ~/dotfiles-bootstrap
bash ~/dotfiles-bootstrap/bootstrap.sh
```

This will:
- Install all dependencies via Homebrew
- Set Homebrew zsh as default shell
- Clone the bare dotfiles repo and checkout config files
- Configure SSH commit signing (fetches public key from GitHub)

## Manual Setup

If you prefer not to use the bootstrap script:

```bash
git clone --bare git@github.com:safranklin/dotfiles.git $HOME/dotfiles
alias dotfile-config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfile-config checkout
dotfile-config config --local status.showUntrackedFiles no
```

If checkout conflicts with existing files, back them up first:

```bash
dotfile-config checkout 2>&1 | grep -E "^\s+" | xargs -I{} mv {} {}.bak
dotfile-config checkout
```

## Dependencies

All installed via `brew install`:

| Tool | Replaces | Purpose |
|------|----------|---------|
| zsh | — | Shell (Homebrew version) |
| starship | — | Cross-shell prompt |
| eza | ls | File listing with git integration |
| bat | cat | Syntax-highlighted file viewer |
| fd | find | Fast file finder |
| ripgrep | grep | Fast recursive search |
| dust | du | Disk usage analyzer |
| procs | ps | Process viewer |
| htop | top | Interactive process viewer |
| git-delta | diff | Improved git diff pager |
| zsh-completions | — | Additional completions |
| zsh-syntax-highlighting | — | Command syntax highlighting |
| zsh-autosuggestions | — | Fish-like autosuggestions |
| wslu | — | WSL utilities (WSL only) |

## Managing dotfiles

```bash
dotfile-config add <file>
dotfile-config commit -m "type(scope): description"
dotfile-config push
```

## What's tracked

### Shell
- `.zshrc` — shell entry point (history, options, completions, plugins)
- `.zshenv` — Homebrew bootstrap (loaded before .zshrc)
- `.config/my/` — modular config: aliases, functions, paths, app settings

### Git
- `.gitconfig` — core settings, SSH signing, delta pager, aliases

### Terminal
- `.config/ghostty/` — Ghostty terminal config
- `.config/my/ghostty/` — Ghostty themes and shaders
- `.config/my/starship.toml` — prompt configuration

### Agent
- `.claude/CLAUDE.md` — Claude Code instructions
- `.claude/settings.json` — Claude Code plugins and hooks
- `.agent/AGENT.md` — cross-tool agent config

## SSH Commit Signing

Commits are signed with an SSH key. The bootstrap script fetches the public key from `github.com/safranklin.keys` and configures `~/.gitconfig` and `~/.ssh/allowed_signers` automatically. Signed commits show a "Verified" badge on GitHub.

## Platform Support

- **macOS**: Full support (open, ifconfig, Bitwarden SSH agent)
- **WSL2**: Full support (wslview, ip, Windows SSH agent bridge via npiperelay)
- **Linux**: Basic support (xdg-open, ip)

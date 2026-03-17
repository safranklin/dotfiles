# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each subdirectory is a stow package — running `stow <package>` from this repo symlinks its contents into `$HOME`.

## Structure

```
~/dotfiles/
├── zsh/        .zshenv, .zshrc, .config/zsh/*.zsh, starship.toml
├── git/        .gitconfig, .gitignore_global
├── ghostty/    .config/ghostty/config, theme.conf, shaders/
├── tmux/       .tmux.conf, .config/tmux/uptime.sh
└── claude/     .claude/CLAUDE.md, .claude/rules/*.md, .agent/AGENT.md
```

## Bootstrap

On a fresh machine:

```bash
# 1. Install Homebrew first: https://brew.sh
# 2. Run bootstrap
bash <(curl -fsSL https://raw.githubusercontent.com/safranklin/dotfiles/main/bootstrap.sh)
```

`bootstrap.sh` installs Homebrew packages (including `stow`), sets zsh as the default shell, installs zsh-defer, clones this repo to `~/dotfiles`, runs `stow */`, and configures SSH commit signing from your GitHub public key.

## Daily use

```bash
# Edit a file — it's a real file in ~/dotfiles
code ~/dotfiles/zsh/.config/my/aliases.zsh

# Commit the change
cd ~/dotfiles
git add zsh/.config/my/aliases.zsh
git commit -m "feat(zsh): ..."
git push

# Or use the alias
alias dotfile-config='git -C $HOME/dotfiles'
dotfile-config commit -m "..."

# After adding a new file to a package, re-stow it
cd ~/dotfiles && stow zsh
```

## Claude Code

The `claude/` package manages user-level [Claude Code](https://code.claude.com/docs/en/features-overview) config:

- **`CLAUDE.md`** — personal instruction file loaded at the start of every session. Communication style only; topic rules live separately.
- **`rules/`** — modular rules files. `python.md` is path-scoped to `*.py` files so it only loads when working on Python. Machine-specific rules (work workflows, etc.) live in `~/.claude/rules/` locally and are not tracked here.

## Platforms

Tested on macOS and WSL2/Ubuntu. Platform-specific behavior is gated on `$PLATFORM` (macos/wsl/linux), set in `.zshrc`.

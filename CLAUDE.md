# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Normal git repo at `~/dotfiles/` managing config files via GNU Stow. Each subdirectory is a stow package that mirrors the `$HOME` structure — `stow <package>` symlinks its contents into `$HOME`.

```bash
# Manage dotfiles from the repo
cd ~/dotfiles
git status
git add <file>
git commit -m "type(scope): description"
git push

# Or use the alias (defined in zsh/.config/zsh/aliases.zsh)
alias dotfile-config='git -C $HOME/dotfiles'

dotfile-config status
dotfile-config add <file>
dotfile-config commit -m "type(scope): description"
dotfile-config push

# Re-stow after adding new files
cd ~/dotfiles && stow <package>   # stow one package
cd ~/dotfiles && stow */          # stow all packages
```

## Architecture

### Stow Packages

| Package | Contents |
|---------|----------|
| `zsh/` | `.zshenv`, `.zshrc`, `.config/zsh/*.zsh`, `starship.toml` |
| `git/` | `.gitconfig`, `.gitignore_global` |
| `ghostty/` | `.config/ghostty/config`, `theme.conf`, `shaders/` |
| `tmux/` | `.tmux.conf`, `.config/tmux/uptime.sh` |
| `claude/` | `.claude/CLAUDE.md`, `.claude/rules/*.md`, `.claude/settings.json`, `.agent/AGENT.md` |

Each package directory mirrors `$HOME`. Running `stow <package>` from `~/dotfiles` creates symlinks in `$HOME` pointing back into the repo.

### Shell Startup Order

1. **`.zshenv`** — Loaded for ALL shell types. Only does Homebrew init and SSH agent socket setup. Keep this minimal.
2. **`.zshrc`** — Interactive shells only. Two-phase loading:
   - **Eager** (before first prompt): `$PLATFORM` detection (macos/wsl/linux), history, shell options, starship prompt
   - **Deferred** (after first prompt, via `zsh-defer`): completions, plugins, all `~/.config/zsh/*.zsh` files

### Modular Config (`zsh/.config/zsh/`)

Each concern lives in its own file, loaded deferred:

| File | Contents |
|------|----------|
| `env.zsh` | Environment variables (secrets go in `*.local.zsh`, gitignored) |
| `apps.zsh` | App-specific setup: zoxide, editor, browser, LESS |
| `functions.zsh` | Shell functions (navigation, git helpers, system info) |
| `aliases.zsh` | All aliases including modern CLI replacements (eza, bat, fd, rg) |
| `paths.zsh` | PATH additions for language runtimes (Go, Rust, Python, Node) |
| `starship.toml` | Prompt theme (Gruvbox dark palette) |

**`*.local.zsh`** files are gitignored and `.claudeignore`d — use these for machine-specific overrides and secrets. This is the right place for API keys, tokens, and work-specific env vars:

```zsh
# ~/.config/zsh/env.local.zsh — never committed, never read by Claude
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export NODE_AUTH_TOKEN="..."
```

### Platform Abstraction

`$PLATFORM` is set in `.zshrc` (macos/wsl/linux). Platform-specific behavior is gated on this variable throughout the config files (SSH agent, browser, IP detection, CUDA paths).

### Bootstrap

`bootstrap.sh` is idempotent. It installs Homebrew packages (including `stow`), sets up zsh-defer, clones the repo, runs `stow */`, and configures SSH commit signing from GitHub public keys.

### Claude Code Config (`claude/.claude/`)

`CLAUDE.md` is the personal user-level instruction file — loaded at the start of every Claude Code session. It contains only communication style preferences; topic-specific rules live in `rules/`.

`rules/` contains modular instruction files loaded alongside `CLAUDE.md`:

| File | Scope | Contents |
|------|-------|----------|
| `git.md` | All sessions | Commit hygiene, conventional commits, PR workflow |
| `work-tracking.md` | All sessions | Issue tracking, plan mode |
| `code-quality.md` | All sessions | Function design, error handling, principles, security |
| `python.md` | `*.py` files only | uv toolchain, src/ layout, type hints, modern Python |
| `ozmo.md` | All sessions | Ozmo domain model, V1↔V2 naming, Device/App conflation, domain map |

Rules in `~/.claude/rules/` that are not tracked in this repo (machine-local) can extend these for machine-specific workflows. See [Claude Code docs — Store instructions and memories](https://code.claude.com/docs/en/features-overview).

## ⚠️ Caution for AI Agents

**These are live system config files.** Every file in this repo is symlinked directly into `$HOME` and takes effect immediately — there is no staging or preview step.

- **Never run `stow`, `rm`, or file-moving commands without explicit user confirmation.** A wrong `stow` invocation can break shell startup, SSH signing, or terminal config instantly.
- **Never read or commit secrets.** `*.local.zsh` files and `~/.aws/` are gitignored and `.claudeignore`d. Do not read, print, or suggest changes to these files.
- **`~/.aws/` is off-limits.** AWS credentials live there. Never touch it.
- **Test shell changes carefully.** A syntax error in `.zshrc` breaks every new shell. Validate with `zsh -n <file>` before saving.
- **`stow --simulate` before `stow`.** Always dry-run first when re-stowing to catch conflicts.

## Key Conventions

- **Deferred loading is intentional.** Anything sourced via `zsh-defer` won't be available in non-interactive shells or during prompt render. Only put interactive-shell concerns in the `*.zsh` files.
- **Modern CLI tools are aliased over defaults** (eza→ls, bat→cat, etc.) but originals remain accessible via full path.
- **Ghostty config** lives at `ghostty/.config/ghostty/config`, with `theme.conf` for font/appearance and `shaders/` for GLSL shaders.
- **Git config** (`.gitconfig`) uses SSH signing, delta pager, histogram diffs, rebase-on-pull, and rerere.
- **Global gitignore** is `.gitignore_global` (referenced by `core.excludesFile` in `.gitconfig`).

# Dotfiles

Bare git repo for managing config files across machines.

## Setup (new machine)

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

## Managing dotfiles

```bash
# Stage a change
dotfile-config add <file>
dotfile-config commit -m "type(scope): description"
dotfile-config push

# Pull updates
dotfile-config pull

# Check status
dotfile-config status
```

## What's tracked

### Claude Code (`~/.claude/`)
- `CLAUDE.md` — global agent instructions (primary config)
- `settings.json` — plugins and hooks configuration

### Agent (`~/.agent/`)
- `AGENT.md` — symlink to `~/.claude/CLAUDE.md` for cross-tool compatibility

### Shell
- `.zshrc` — shell entry point
- `.config/my/` — aliases, functions, paths, app settings

### Terminal
- `.config/ghostty/` — Ghostty terminal config
- `.config/my/ghostty/` — Ghostty themes and shaders
- `.config/my/starship.toml` — prompt configuration

## Adding new files

1. Edit the file in its normal location
2. `dotfile-config add <path>`
3. `dotfile-config commit -m "feat(scope): what and why"`
4. `dotfile-config push`

## For coding agents

If you're an agent managing these dotfiles:
- Use `dotfile-config` (not plain `git`) for all operations — it's an alias for `git --git-dir=$HOME/dotfiles/ --work-tree=$HOME`
- Only track config files, never secrets (`.credentials.json`, `.env`, etc.)
- Conventional commits: `type(scope): description`
- After editing any tracked file, stage and commit the change
- `CLAUDE.md` is the primary agent config; `AGENT.md` symlinks to it

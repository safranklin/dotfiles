#!/bin/zsh

# ═══════════════════════════════════════════
#              SHELL ALIASES
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# File System & Navigation
# ─────────────────────────────────────────────

# eza (modern ls alternative) with flexible argument handling
if [ "$(command -v eza)" ]; then
   unalias -m 'ls' 2>/dev/null
   unalias -m 'll' 2>/dev/null
   
   # Clean ls that accepts any arguments
   alias ls='eza --header --smart-group --git --long --no-permissions --no-user --icons=auto --group-directories-first --sort=extension --time-style=long-iso --hyperlink'
   
   # Convenient shortcuts for common patterns
   alias ll='eza --header --smart-group --git --long --all'
   alias lt='eza --header --smart-group --tree --level=2 --git --long --icons'
   alias lta='eza --header --smart-group --tree --level=2 --git --long --icons --all'
fi

# ─────────────────────────────────────────────
# Quick System Utilities
# ─────────────────────────────────────────────

alias clr="clear"                    # Clear terminal screen
alias source.reload="source ~/.zshrc"  # Reload zsh configuration

# Platform-aware aliases
if [[ "$OSTYPE" == darwin* ]]; then
   alias o="open ."
   alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
   alias o="wslview ."
   alias myip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1"
else
   alias o="xdg-open ."
   alias myip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1"
fi

# ─────────────────────────────────────────────
# Git Workflow
# ─────────────────────────────────────────────

alias git.log='git log --oneline --graph --decorate'

# ─────────────────────────────────────────────
# Project Navigation
# ─────────────────────────────────────────────

alias go.dev='cd ~/Developer'
alias go.ozmo='cd ~/Developer/Ozmo'

# ─────────────────────────────────────────────
# Modern CLI Tool Replacements
# ─────────────────────────────────────────────

# Replace top with htop (better process viewer)
if [ -x "$(command -v htop)" ]; then
   alias top='htop'
fi

# fd (find alternative) - keep original fd available
if [ -x "$(command -v fd)" ]; then
   alias fda='fd -IH'  # show hidden and ignored files
   alias fdf='fd -t f' # files only
   alias fdd='fd -t d' # directories only
fi

# ripgrep (grep alternative) - keep both available
if [ -x "$(command -v rg)" ]; then
   alias rga='rg -uuu'     # search everything including hidden/ignored
   alias rgg='rg --hidden' # search hidden files but respect .gitignore
   # Don't override grep - keep both available
fi

# Replace du with dust (disk usage analyzer)
if [ -x "$(command -v dust)" ]; then
   alias du='dust'
fi

# Replace ps with procs (process viewer)
if [ -x "$(command -v procs)" ]; then
   alias ps='procs'
fi

# ─────────────────────────────────────────────
# Docker Management
# ─────────────────────────────────────────────

alias docker.clean='docker system prune -f'
alias docker.cleancontainer='docker ps -a -q | xargs -r docker rm'
alias docker.cleanimage='docker images --filter dangling=true -q | xargs -r docker rmi'
alias docker.logs='docker logs -f'

# ─────────────────────────────────────────────
# Dotfile Management
# ─────────────────────────────────────────────

alias dotfile-config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
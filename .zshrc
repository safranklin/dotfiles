#!/bin/zsh

# ═══════════════════════════════════════════
#       SHELL INITIALIZATION & PLUGINS
# ═══════════════════════════════════════════

# Cache brew prefix once — avoids repeated forks throughout config
if type brew &>/dev/null; then
   BREW_PREFIX=$(brew --prefix)
fi

# Detect platform once — used by all config files
if [[ "$OSTYPE" == darwin* ]]; then
   PLATFORM=macos
elif [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
   PLATFORM=wsl
else
   PLATFORM=linux
fi

# ─────────────────────────────────────────────
# History
# ─────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # share across sessions
setopt HIST_IGNORE_DUPS       # skip consecutive dupes
setopt HIST_IGNORE_ALL_DUPS   # remove older dupes from history
setopt HIST_IGNORE_SPACE      # don't record commands starting with space
setopt HIST_REDUCE_BLANKS     # trim extra whitespace
setopt HIST_VERIFY            # expand history before executing
setopt EXTENDED_HISTORY       # save timestamps
setopt INC_APPEND_HISTORY     # write immediately, don't wait for exit
setopt APPEND_HISTORY         # append, don't overwrite

# ─────────────────────────────────────────────
# Shell Options
# ─────────────────────────────────────────────

setopt AUTO_CD                # cd by typing a directory name
setopt AUTO_PUSHD             # push directories onto the stack
setopt PUSHD_IGNORE_DUPS      # no dupes on the dir stack
setopt PUSHD_SILENT           # don't print the stack after pushd/popd
setopt CORRECT                # offer correction for mistyped commands
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shell
setopt NO_BEEP                # silence
setopt GLOB_DOTS              # include dotfiles in glob
setopt EXTENDED_GLOB          # (#,~,^) glob operators

# ─────────────────────────────────────────────
# Prompt Configuration
# ─────────────────────────────────────────────

# Starship - cross-shell prompt with git integration
if type starship &>/dev/null; then
   export STARSHIP_CONFIG=$HOME/.config/my/starship.toml
   eval "$(starship init zsh)"
fi

# ─────────────────────────────────────────────
# Completion System Setup
# ─────────────────────────────────────────────

# Homebrew completions and zsh-completions
if [[ -n "$BREW_PREFIX" ]]; then
   FPATH=$BREW_PREFIX/share/zsh/site-functions:$FPATH
   FPATH=$BREW_PREFIX/share/zsh-completions:$FPATH
fi

# Docker CLI completions (macOS Docker Desktop)
if [[ $PLATFORM == macos && -d "$HOME/.docker/completions" ]]; then
   fpath=($HOME/.docker/completions $fpath)
fi

autoload -Uz compinit
compinit

# ─────────────────────────────────────────────
# Enhanced Tab Completion
# ─────────────────────────────────────────────

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colored completion menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Enable menu selection for completions
zstyle ':completion:*' menu select

# Bind Shift+Tab (reverse menu selection)
bindkey '^[[Z' reverse-menu-complete

# Cache completions for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# Group matches and describe groups
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# ─────────────────────────────────────────────
# Shell Enhancement Plugins
# ─────────────────────────────────────────────

# Syntax highlighting for commands as you type
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
   source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Command autosuggestions based on history and completions
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
   # Use both history and completion engine for suggestions
   export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
   source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
   
   # Enhanced history search with up/down arrows
   autoload -U history-search-end
   zle -N history-beginning-search-backward-end history-search-end
   zle -N history-beginning-search-forward-end history-search-end
   bindkey "^[[A" history-beginning-search-backward-end
   bindkey "^[[B" history-beginning-search-forward-end
fi

# ─────────────────────────────────────────────
# SSH Agent (WSL only — Bitwarden via Windows npiperelay)
# ─────────────────────────────────────────────

if [[ $PLATFORM == wsl ]]; then
   # SSH_AUTH_SOCK is set in .zshenv; start the bridge if it's not running
   if ! ss -a 2>/dev/null | grep -q "$SSH_AUTH_SOCK"; then
      _win_home=$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")
      rm -f "$SSH_AUTH_SOCK"
      setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
         EXEC:"${_win_home}/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork \
         &>/dev/null
      unset _win_home
   fi
fi

# ─────────────────────────────────────────────
# Custom Configuration Files
# ─────────────────────────────────────────────

# Load modular configuration files
[[ -f ~/.config/my/env.zsh ]] && source ~/.config/my/env.zsh			# Environment variables
[[ -f ~/.config/my/apps.zsh ]] && source ~/.config/my/apps.zsh			# Application specific settings
[[ -f ~/.config/my/functions.zsh ]] && source ~/.config/my/functions.zsh	# Custom functions
[[ -f ~/.config/my/aliases.zsh ]] && source ~/.config/my/aliases.zsh		# Command aliases
[[ -f ~/.config/my/paths.zsh ]] && source ~/.config/my/paths.zsh		# PATH modifications

# Local overrides (gitignored — machine-specific config like work aliases)
for f in ~/.config/my/*.local.zsh(N); do source "$f"; done

# Keep newline at end of file

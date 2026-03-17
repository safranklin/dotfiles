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
elif [[ -n "$WSL_DISTRO_NAME" ]]; then
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
# Prompt Configuration (eager — must render immediately)
# ─────────────────────────────────────────────

if type starship &>/dev/null; then
   export STARSHIP_CONFIG=$HOME/.config/zsh/starship.toml
   eval "$(starship init zsh)"
fi

# ─────────────────────────────────────────────
# Deferred Loading (runs after first prompt)
# ─────────────────────────────────────────────

# zsh-defer: https://github.com/romkatv/zsh-defer
# Defers non-critical init to after the prompt renders for faster perceived startup.
# Falls back to eager loading if not installed.
if [[ -f ~/.config/zsh/zsh-defer/zsh-defer.plugin.zsh ]]; then
   source ~/.config/zsh/zsh-defer/zsh-defer.plugin.zsh
   alias defer='zsh-defer'
else
   alias defer=''
fi

# ─────────────────────────────────────────────
# Completion System
# ─────────────────────────────────────────────

# FPATH must be set before compinit
if [[ -n "$BREW_PREFIX" ]]; then
   FPATH=$BREW_PREFIX/share/zsh/site-functions:$FPATH
   FPATH=$BREW_PREFIX/share/zsh-completions:$FPATH
fi

if [[ $PLATFORM == macos && -d "$HOME/.docker/completions" ]]; then
   fpath=($HOME/.docker/completions $fpath)
fi

defer autoload -Uz compinit
defer compinit

# ─────────────────────────────────────────────
# Enhanced Tab Completion
# ─────────────────────────────────────────────

defer zstyle ':completion:*' matcher-list \
   'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
defer zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
defer zstyle ':completion:*' menu select
defer bindkey '^[[Z' reverse-menu-complete
defer zstyle ':completion:*' use-cache on
defer zstyle ':completion:*' cache-path '"$HOME/.zcompcache"'
defer zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
defer zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
defer zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
defer zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# ─────────────────────────────────────────────
# Shell Enhancement Plugins
# ─────────────────────────────────────────────

# Syntax highlighting
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
   defer source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Autosuggestions + tab accept + history search
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
   export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
   defer source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

   defer -c '
      _accept_or_complete() {
         if [[ -n "$POSTDISPLAY" ]]; then
            zle autosuggest-accept
         else
            zle expand-or-complete
         fi
      }
      zle -N _accept_or_complete
      bindkey "\t" _accept_or_complete
   '

   defer autoload -U history-search-end
   defer -c '
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end
      bindkey "^[[A" history-beginning-search-backward-end
      bindkey "^[[B" history-beginning-search-forward-end
   '
fi

# ─────────────────────────────────────────────
# SSH Agent (WSL only — Bitwarden via Windows npiperelay)
# ─────────────────────────────────────────────

if [[ $PLATFORM == wsl ]]; then
   defer -c '
      if ! ss -a 2>/dev/null | grep -q "$SSH_AUTH_SOCK"; then
         _win_home=$(wslpath "$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d "\r")")
         rm -f "$SSH_AUTH_SOCK"
         setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
            EXEC:"${_win_home}/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork \
            &>/dev/null
         unset _win_home
      fi
   '
fi

# ─────────────────────────────────────────────
# Custom Configuration Files
# ─────────────────────────────────────────────

[[ -f ~/.config/zsh/env.zsh ]] && defer source ~/.config/zsh/env.zsh
[[ -f ~/.config/zsh/apps.zsh ]] && defer source ~/.config/zsh/apps.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && defer source ~/.config/zsh/functions.zsh
[[ -f ~/.config/zsh/aliases.zsh ]] && defer source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/paths.zsh ]] && defer source ~/.config/zsh/paths.zsh

# Local overrides (gitignored — machine-specific config like work aliases)
for f in ~/.config/zsh/*.local.zsh(N); do defer source "$f"; done

# Keep newline at end of file

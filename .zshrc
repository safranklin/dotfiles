#!/bin/zsh

# ═══════════════════════════════════════════
#       SHELL INITIALIZATION & PLUGINS
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# Prompt Configuration
# ─────────────────────────────────────────────

# Starship - cross-shell prompt with git integration
if type starship &>/dev/null; then
   eval "$(starship init zsh)"
   export STARSHIP_CONFIG=$HOME/.config/my/starship.toml
fi

# ─────────────────────────────────────────────
# Completion System Setup
# ─────────────────────────────────────────────

# Homebrew completions and zsh-completions
if type brew &>/dev/null; then
   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
   FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

   autoload -Uz compinit
   compinit
fi

# ─────────────────────────────────────────────
# Enhanced Tab Completion
# ─────────────────────────────────────────────

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colored completion menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Enable menu selection for completions
zstyle ':completion:*' menu select

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
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
   source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Command autosuggestions based on history and completions
if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
   # Use both history and completion engine for suggestions
   export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
   source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
   
   # Enhanced history search with up/down arrows
   autoload -U history-search-end
   zle -N history-beginning-search-backward-end history-search-end
   zle -N history-beginning-search-forward-end history-search-end
   bindkey "^[[A" history-beginning-search-backward-end
   bindkey "^[[B" history-beginning-search-forward-end
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
[[ -f ~/.config/my/management.zsh ]] && source ~/.config/my/management.zsh	# Dotfile management modifications

# Keep newline at end of file


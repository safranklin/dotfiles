#!/bin/bash
# Restore original tmux window name on Claude Code session end

[ -z "$TMUX" ] && exit 0

state_file="$HOME/.claude/hooks/.tmux-original-name"
if [ -f "$state_file" ]; then
  tmux rename-window "$(cat "$state_file")"
  rm "$state_file"
fi

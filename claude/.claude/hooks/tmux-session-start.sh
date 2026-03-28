#!/bin/bash
# Rename tmux window on Claude Code session start
# Priority: customTitle → directory name (slug is always auto-generated)

[ -z "$TMUX" ] && exit 0

input=$(cat)

# Save current window name for restore on exit (only if not already saved)
state_file="$HOME/.claude/hooks/.tmux-original-name"
[ ! -f "$state_file" ] && tmux display-message -p "#{window_name}" > "$state_file"

# Try customTitle from transcript (user-set session name via /rename)
transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
session_name=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  session_name=$(grep '"customTitle"' "$transcript" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null)
fi

# Fall back to project directory name
if [ -z "$session_name" ]; then
  cwd=$(echo "$input" | jq -r '.cwd // empty' 2>/dev/null)
  session_name=$(basename "${cwd:-unknown}")
fi

tmux rename-window "claude:${session_name}"

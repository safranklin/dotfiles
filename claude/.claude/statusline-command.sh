#!/bin/bash
# Claude Code statusline — Gruvbox Dark pill-style segments
# Requires: Nerd Font, jq

input=$(cat)

# ── Update tmux window title (runs on every statusline refresh) ──
if [ -n "$TMUX" ]; then
  transcript=$(echo "$input" | jq -r '.transcript_path // empty')
  tmux_title=""
  if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    tmux_title=$(grep '"customTitle"' "$transcript" 2>/dev/null | tail -1 | jq -r '.customTitle // empty' 2>/dev/null)
  fi
  if [ -z "$tmux_title" ]; then
    _cwd=$(echo "$input" | jq -r '.cwd // empty')
    tmux_title=$(basename "${_cwd:-unknown}")
  fi
  tmux rename-window "claude:${tmux_title}" 2>/dev/null
fi

# ── Extract values ──
cwd=$(echo "$input" | jq -r '.cwd // empty')
model=$(echo "$input" | jq -r 'if .model | type == "object" then (.model.display_name // .model.id // empty) elif .model then .model else empty end')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_5h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# ── ANSI helpers ──
RST='\033[0m'
BOLD='\033[1m'

# ── Gruvbox Dark palette (256-color) ──
FG0='\033[1;38;5;230m'
BG_ORANGE='\033[48;5;166m';  FG_ORANGE='\033[38;5;166m'
BG_YELLOW='\033[48;5;172m';  FG_YELLOW='\033[38;5;172m'
BG_AQUA='\033[48;5;71m';     FG_AQUA='\033[38;5;71m'
BG_BLUE='\033[48;5;66m';     FG_BLUE='\033[38;5;66m'
BG_BG1='\033[48;5;237m';     FG_BG1='\033[38;5;237m'
BG_BG3='\033[48;5;59m';      FG_BG3='\033[38;5;59m'
FG_GREEN='\033[38;5;106m'
FG_PURPLE='\033[38;5;132m'
FG_RED='\033[38;5;124m'

# ── Pill helpers ──
pill() {
  local bg="$1" fg="$2" content="$3"
  printf '%b' "${fg}${RST}${bg}${FG0} ${content} ${RST}${fg}${RST}"
}

pill2() {
  local bg1="$1" fg1="$2" c1="$3" bg2="$4" fg2="$5" c2="$6"
  printf '%b' "${fg1}${RST}${bg1}${FG0} ${c1} ${fg1}${bg2}${RST}${bg2}${FG0} ${c2} ${RST}${fg2}${RST}"
}

# ── Build a bar gauge: bar <used_pct> <bar_len> <used_color> <free_color> ──
bar() {
  local pct="$1" len="${2:-10}" uc="$3" fc="$4"
  local filled=$(( (pct * len + 50) / 100 ))
  [ "$filled" -gt "$len" ] && filled="$len"
  [ "$filled" -lt 0 ] && filled=0
  local empty=$(( len - filled ))
  # Pre-built block strings (0-10 chars each)
  local F=("" "█" "██" "███" "████" "█████" "██████" "███████" "████████" "█████████" "██████████")
  local E=("" "░" "░░" "░░░" "░░░░" "░░░░░" "░░░░░░" "░░░░░░░" "░░░░░░░░" "░░░░░░░░░" "░░░░░░░░░░")
  printf '%b' "${uc}${F[$filled]}${fc}${E[$empty]}"
}

# Color for a percentage (low=green, mid=yellow, high=orange, crit=red)
_pct_color() {
  if [ "$1" -lt 25 ]; then printf '%b' "${FG_GREEN}"
  elif [ "$1" -lt 50 ]; then printf '%b' "${FG_YELLOW}"
  elif [ "$1" -lt 75 ]; then printf '%b' "${FG_ORANGE}"
  else printf '%b' "${FG_RED}"; fi
}

out=""

# ── Pill: Directory + Git (yellow | aqua) ──
if [ -n "$cwd" ]; then
  dir_name=$(basename "$cwd")
  parent=$(dirname "$cwd")
  parent_name=$(basename "$parent")
  if [ "$parent_name" = "/" ] || [ "$parent" = "$HOME" ]; then
    dir_display="$dir_name"
  else
    dir_display="…/${parent_name}/${dir_name}"
  fi
else
  dir_display="~"
fi

git_info=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  git_stat=""
  porcelain=$(git -C "$cwd" status --porcelain 2>/dev/null)
  if [ -n "$porcelain" ]; then
    mod=$(echo "$porcelain" | grep -c "^ M")
    unt=$(echo "$porcelain" | grep -c "^??")
    stg=$(echo "$porcelain" | grep -c "^[MARCD] ")
    [ "$mod" -gt 0 ] && git_stat="${git_stat} !${mod}"
    [ "$unt" -gt 0 ] && git_stat="${git_stat} ?${unt}"
    [ "$stg" -gt 0 ] && git_stat="${git_stat} +${stg}"
  fi
  git_info="${branch}${git_stat}"
fi

if [ -n "$git_info" ]; then
  out="${out}$(pill2 "${BG_YELLOW}" "${FG_YELLOW}" " ${dir_display}" "${BG_AQUA}" "${FG_AQUA}" " ${git_info}")"
else
  out="${out}$(pill "${BG_YELLOW}" "${FG_YELLOW}" " ${dir_display}")"
fi

# ── Pill: Model (blue) ──
if [ -n "$model" ]; then
  out="${out} $(pill "${BG_BLUE}" "${FG_BLUE}" "󰚩 ${model}")"
fi

# ── Pill: Context window (bg3) ──
if [ -n "$used_pct" ] && [ -n "$remaining_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct" 2>/dev/null)
  free_int=$(printf "%.0f" "$remaining_pct" 2>/dev/null)

  if [ "$free_int" -gt 60 ]; then free_color="${FG_AQUA}"
  elif [ "$free_int" -gt 40 ]; then free_color="${FG_YELLOW}"
  elif [ "$free_int" -gt 20 ]; then free_color="${FG_ORANGE}"
  else free_color="${FG_RED}"; fi

  ctx_bar=$(bar "$used_int" 10 "${FG_PURPLE}" "$free_color")

  token_label=""
  if [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ]; then
    used_tokens=$(( ctx_size * used_int / 100 ))
    used_k=$(( (used_tokens + 500) / 1000 ))
    if [ "$ctx_size" -ge 1000000 ]; then
      total_m=$(( ctx_size / 1000000 ))
      token_label=" ${used_k}k/${total_m}M"
    else
      total_k=$(( ctx_size / 1000 ))
      token_label=" ${used_k}k/${total_k}k"
    fi
  fi

  out="${out} $(pill "${BG_BG3}" "${FG_BG3}" "󰧑 ${ctx_bar}${FG0}${token_label} (${used_int}%)")"
fi

# ── Pill: Usage limits (bg1) ──
if [ -n "$rl_5h" ]; then
  rl_5h_int=$(printf "%.0f" "$rl_5h" 2>/dev/null)
  rl_7d_int=$(printf "%.0f" "$rl_7d" 2>/dev/null)

  c5=$(_pct_color "$rl_5h_int")
  bar5=$(bar "$rl_5h_int" 5 "$c5" "${FG_BG3}")

  rl_content=" ${FG0}5h ${bar5}${BOLD} ${c5}${rl_5h_int}%${RST}${BG_BG1}"

  if [ -n "$rl_7d" ]; then
    c7=$(_pct_color "$rl_7d_int")
    bar7=$(bar "$rl_7d_int" 5 "$c7" "${FG_BG3}")
    rl_content="${rl_content}  ${FG0}7d ${bar7}${BOLD} ${c7}${rl_7d_int}%${RST}${BG_BG1}"
  fi

  reset_label=""
  if [ -n "$rl_5h_reset" ] && [ "$rl_5h_reset" != "null" ]; then
    now=$(date +%s)
    remaining=$(( rl_5h_reset - now ))
    if [ "$remaining" -gt 0 ]; then
      hrs=$(( remaining / 3600 ))
      mins=$(( (remaining % 3600) / 60 ))
      if [ "$hrs" -gt 0 ]; then
        reset_label="  ${FG0}resets: ${hrs}h${mins}m"
      else
        reset_label="  ${FG0}resets: ${mins}m"
      fi
    fi
  fi

  out="${out} ${FG_BG1}${RST}${BG_BG1} ${rl_content}${reset_label} ${RST}${FG_BG1}${RST}"
fi

printf '%b' "${out}"

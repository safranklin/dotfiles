#!/bin/zsh

# ═══════════════════════════════════════════
#           CUSTOM FUNCTIONS
# ═══════════════════════════════════════════

# ─────────────────────────────────────────────
# File System Search & Navigation
# ─────────────────────────────────────────────

# Find files by name (case-insensitive)
# Usage: f "pattern" [additional find options]
function f() { 
   find . -iname "*$1*" ${@:2} 
}

# Recursively search file contents with grep
# Usage: r "search_term" [additional grep options]
function r() { 
   grep "$1" ${@:2} -R . 
}

# Create directory and navigate into it
# Usage: mkcd "directory_name"
function mkcd() { 
   mkdir -p "$@" && cd "$_" 
}

# ─────────────────────────────────────────────
# Enhanced File Listing
# ─────────────────────────────────────────────

# Advanced ls with octal permissions display
# Shows file permissions in both symbolic and octal format
function cll() {
   local ls_cmd="ls -Alh --color"
   [[ "$OSTYPE" == darwin* ]] && ls_cmd="ls -AlhG"
   eval "$ls_cmd" "$@" | awk '{
      k=0;
      for(i=0;i<=8;i++) k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));
      if(k) printf(" %0o ",k);
      print
   }' | cut -c 1-5,21-
}

# ─────────────────────────────────────────────
# Git Operations
# ─────────────────────────────────────────────

# Clean up local branches whose remotes are gone
# Fetches latest remote info and deletes local branches tracking deleted remotes
# Usage: git-clean-gone
function git-clean-gone() {
    echo "Fetching remote branches..."
    git fetch -p
    
    local branches_with_gone_remote=$(
        git for-each-ref --format '%(refname) %(upstream:track)' refs/heads |
        awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
    )
    
    if [[ -z "$branches_with_gone_remote" ]]; then
        echo "No branches with deleted remotes found."
        return 0
    fi
    
    echo "Found branches with deleted remotes:"
    echo "$branches_with_gone_remote" | sed 's/^/  - /'
    
    for branch in ${(f)branches_with_gone_remote}; do
        echo "Deleting branch: $branch"
        git branch -D "$branch"
    done
    
    echo "Cleanup complete."
}

# ─────────────────────────────────────────────
# Network & System Information
# ─────────────────────────────────────────────

# Get VPN IP address (looks for 100.x.x.x range)
# Usage: get-ip-vpn
function get-ip-vpn() {
   echo "Getting VPN IP..."
   local myip
   if [[ "$OSTYPE" == darwin* ]]; then
      myip=$(ifconfig | rg -e '\b100\.' | awk '{print $2; exit}')
   else
      myip=$(ip -4 addr show | rg -e '\b100\.' | awk '{print $2; exit}' | cut -d/ -f1)
   fi
   echo "$myip"
}

# Get public IP address using multiple methods
# Tries DNS then CloudFlare as a fallback
# Usage: get-ip-public
function get-ip-public() {
    echo "Getting public IP..."
    
    # Method 1: DNS (fastest, most reliable)
    local dns_ip=$(dig +short +timeout=3 myip.opendns.com @resolver1.opendns.com 2>/dev/null)
    if [[ $dns_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "$dns_ip"
        return
    fi
    
    # Method 2: CloudFlare trace
    local cf_ip=$(curl -s --max-time 3 https://1.1.1.1/cdn-cgi/trace 2>/dev/null | grep 'ip=' | cut -d'=' -f2)
    if [[ $cf_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo "$cf_ip"
        return
    fi
    
    echo "Failed to retrieve public IP"
}
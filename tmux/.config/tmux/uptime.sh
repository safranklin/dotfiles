#!/bin/sh
boot=$(sysctl -n kern.boottime | awk -F'[ ,]+' '{print $4}')
now=$(date +%s)
t=$((now - boot))
d=$((t / 86400))
h=$(((t / 3600) % 24))
m=$(((t / 60) % 60))
out=""
[ "$d" -gt 0 ] && out="${d}d "
[ "$h" -gt 0 ] && out="${out}${h}h "
printf "%s" "${out}${m}m"

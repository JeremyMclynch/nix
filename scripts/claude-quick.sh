#!/usr/bin/env bash

cache_file=~/.cache/wofi/claude-cache
mkdir -p "$(dirname "$cache_file")"
touch "$cache_file"


# Get input from user
input=$(echo "$cache_file" | wofi --dmenu --prompt "Ask Claude:" --width 800 --height 200 --cache-file ~/.cache/wofi/claude-cache)

# Check if user provided input (didn't cancel)
if [ -n "$input" ]; then
    # Execute your command with the input
    grep -qxF "$input" "$cache_file" || echo "$input" >> "$cache_file"

    foot -e --title='rebuild' ~/nix/scripts/claude-prompt.sh "$input"
fi




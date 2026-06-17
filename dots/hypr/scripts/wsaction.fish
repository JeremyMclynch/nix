#!/usr/bin/env fish

# Switch to / move a window to a workspace, scoped to the current workspace
# "group" (blocks of 10). Under Hyprland 0.55+ Lua configs, `hyprctl dispatch`
# parses its argument as Lua, so dispatchers must be passed as hl.dsp.* calls.

if test "$argv[1]" = '-g'
    set group
    set -e argv[1]
end

if test (count $argv) -ne 2
    echo 'Wrong number of arguments. Usage: ./wsaction.fish [-g] <dispatcher> <workspace>'
    exit 1
end

set -l active_ws (hyprctl activeworkspace -j | jq -r '.id')

set -l target
if set -q group
    # Move to group
    set target (math "($argv[2] - 1) * 10 + $active_ws % 10")
else
    # Move to ws in group
    set target (math "floor(($active_ws - 1) / 10) * 10 + $argv[2]")
end

switch $argv[1]
    case workspace
        hyprctl dispatch "hl.dsp.focus({ workspace = \"$target\" })"
    case movetoworkspace
        hyprctl dispatch "hl.dsp.window.move({ workspace = \"$target\" })"
    case '*'
        hyprctl dispatch "hl.dsp.$argv[1]({ workspace = \"$target\" })"
end

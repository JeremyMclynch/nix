-- Hyprland Lua configuration (0.55+), converted from the legacy hyprlang
-- .conf files. This is a parallel config: it is NOT loaded while named
-- ".new". To activate, rename this file to `hyprland.lua` — Hyprland prefers
-- hyprland.lua over hyprland.conf when both are present. To revert, rename it
-- back (or delete it) and Hyprland falls back to hyprland.conf.
--
-- The configuration is split into modules under lua/, each converted from the
-- matching .conf file. They are required here in the same order the old
-- hyprland.conf sourced them.

require("lua.env")
require("lua.monitors")
-- Desktop HDR monitors (DP-1/DP-2). Runtime file at ~/.config/hypr/hdr-current.lua,
-- toggled by scripts/hdr-lua.sh. pcall so a missing file (e.g. on the laptop)
-- doesn't break the config.
pcall(require, "hdr-current")
require("lua.general")
require("lua.input")
require("lua.misc")
require("lua.animations")
require("lua.decoration")
require("lua.group")
require("lua.gestures")
require("lua.execs")
require("lua.rules")
require("lua.binds")

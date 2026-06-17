-- Hyprland Lua configuration (0.55+).
--
-- The configuration is split into modules under lua/, required here in the
-- order Hyprland should apply them.

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

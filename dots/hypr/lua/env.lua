-- Environment variables + xwayland (from hyprland/env.conf and the top of
-- the old hyprland.conf).

local vars = require("lua.variables")

-- Themes
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XCURSOR_THEME", vars.cursorTheme)
hl.env("XCURSOR_SIZE", tostring(vars.cursorSize))

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Others
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Host-specific: the ROG Zephyrus laptop's GPU won't start Hyprland under
-- aquamarine's atomic modesetting, so it needs AQ_NO_ATOMIC=1. The dotfiles
-- are symlinked identically to every host, so detect the machine at runtime
-- via /etc/hostname (set declaratively to "nixos-rog" in that host's config).
local function hostname()
    local f = io.open("/etc/hostname", "r")
    if not f then return "" end
    local name = f:read("l") or ""
    f:close()
    return name
end

if hostname() == "nixos-rog" then
    hl.env("AQ_NO_ATOMIC", "1")
    hl.env("WLR_NO_HARDWARE_CURSORS", "1")
end

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})

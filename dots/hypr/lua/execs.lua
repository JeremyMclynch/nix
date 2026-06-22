-- Autostart (from hyprland/execs-noctalia.conf + the exec-once lines at the
-- bottom of the old hyprland.conf). All run once on Hyprland start.

local vars = require("lua.variables")

hl.on("hyprland.start", function()
    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto delete trash 30 days old
    hl.exec_cmd("trash-empty 30")

    -- Cursors
    hl.exec_cmd("hyprctl setcursor " .. vars.cursorTheme .. " " .. vars.cursorSize)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. vars.cursorTheme .. "'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. vars.cursorSize)

    -- Location provider and night light
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
    hl.exec_cmd("sleep 1 && gammastep")

    -- Forward bluetooth media commands to MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Shell + tray
    hl.exec_cmd("noctalia -d")
    hl.exec_cmd("nm-applet --indicator")

    -- Idle daemon. Kill any leftover instance first: exec-launched hypridle from
    -- a previous session can survive relogins/soft-reboots, and a second daemon
    -- that doesn't own the org.freedesktop.ScreenSaver dbus name will keep
    -- counting down and lock the screen even while Firefox/etc. inhibit idle.
    hl.exec_cmd("pkill -x hypridle; sleep 0.5; hypridle")
end)

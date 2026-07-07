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

    -- Tray (the shell, noctalia, is started together with hypridle below so
    -- their D-Bus startup order is deterministic -- see the comment there).
    hl.exec_cmd("nm-applet --indicator")

    -- Idle daemon + shell, launched in a STRICT order.
    --
    -- hypridle and noctalia both try to own the org.freedesktop.ScreenSaver
    -- D-Bus name, and whoever grabs it first keeps it: hypridle cannot take it
    -- back (it logs "Another service is already providing the ...ScreenSaver
    -- interface"), while noctalia falls back gracefully to plain logind
    -- idle-inhibit monitoring when it loses the race. That name is exactly
    -- where Firefox/mpv/etc. send their "media is playing" idle inhibit, so
    -- hypridle MUST own it -- otherwise the inhibit dies at noctalia and the
    -- lock screen fires while watching a video.
    --
    -- So: kill any leftovers (an exec-launched daemon can survive relogins/
    -- soft-reboots), start hypridle, wait until it has claimed the D-Bus name,
    -- and only THEN start noctalia.
    hl.exec_cmd(
        "pkill -x hypridle; pkill -x noctalia; sleep 0.5; " ..
        "hypridle & " ..
        "for _ in $(seq 1 50); do " ..
            "busctl --user call org.freedesktop.DBus /org/freedesktop/DBus " ..
            "org.freedesktop.DBus GetNameOwner s org.freedesktop.ScreenSaver " ..
            ">/dev/null 2>&1 && break; " ..
            "sleep 0.1; " ..
        "done; " ..
        "exec noctalia -d"
    )
end)

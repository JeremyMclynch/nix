-- Keybinds (from hyprland/keybinds-noctalia.conf).
--
-- All binds live in a "global" submap that is entered on startup, exactly
-- like the legacy config (`exec = hyprctl dispatch submap global`).
-- Every $variable the old config referenced is dereferenced to its literal
-- value here, so this file depends on nothing external.

local wsaction = "~/.config/hypr/scripts/wsaction.fish"

hl.define_submap("global", function()
    -- ## Shell keybinds
    -- Launcher
    hl.bind("SUPER + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

    -- Misc
    hl.bind("SUPER + X", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
    hl.bind("SUPER + S", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
    hl.bind("SUPER + I", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
    hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))
    hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprctl keyword device[ven_2c2f:00-2c2f:002b-touchpad]:enabled false | hyprctl keyword device[ven_2c2f:00-2c2f:002b-touchpad]:enabled true"), { locked = true })
    hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("foot -e --title='btop' btop"))
    hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("/home/jeremy/nix/scripts/wofi.sh"))
    hl.bind("ALT + Space", hl.dsp.exec_cmd("/home/jeremy/nix/scripts/claude-quick.sh"))

    -- Brightness
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up"),   { locked = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true })
    hl.bind("SUPER + XF86MonBrightnessUp",   hl.dsp.dpms({ action = "on" }),  { locked = true })
    hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.dpms({ action = "off" }), { locked = true })

    -- Media
    hl.bind("CTRL + SUPER + Space", hl.dsp.exec_cmd("noctalia msg media toggle"),   { locked = true })
    hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("noctalia msg media toggle"),   { locked = true })
    hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("noctalia msg media toggle"),   { locked = true })
    hl.bind("CTRL + SUPER + Equal", hl.dsp.exec_cmd("noctalia msg media next"),     { locked = true })
    hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("noctalia msg media next"),     { locked = true })
    hl.bind("CTRL + SUPER + Minus", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
    hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true })
    hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("noctalia msg media stop"),     { locked = true })
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pavucontrol-qt"))

    -- Kill/restart
    hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { release = true })

    -- Go to / move to workspace #  (key 0 maps to workspace 10)
    for i = 1, 10 do
        local key = i % 10
        hl.bind("SUPER + " .. key,              hl.dsp.exec_cmd(wsaction .. " workspace " .. i))
        hl.bind("CTRL + SUPER + " .. key,       hl.dsp.exec_cmd(wsaction .. " -g workspace " .. i))
        hl.bind("SUPER + SHIFT + " .. key,      hl.dsp.exec_cmd(wsaction .. " movetoworkspace " .. i))
        hl.bind("CTRL + SUPER + ALT + " .. key, hl.dsp.exec_cmd(wsaction .. " -g movetoworkspace " .. i))
    end

    -- Go to workspace -1/+1
    hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
    hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "+1" }))
    hl.bind("CTRL + SUPER + left",  hl.dsp.focus({ workspace = "-1" }), { repeating = true })
    hl.bind("CTRL + SUPER + right", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
    hl.bind("SUPER + Page_Up",   hl.dsp.focus({ workspace = "-1" }), { repeating = true })
    hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
    -- Go to workspace group -1/+1
    hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "-10" }))
    hl.bind("CTRL + SUPER + mouse_up",   hl.dsp.focus({ workspace = "+10" }))

    -- Move window to workspace -1/+1
    hl.bind("SUPER + ALT + Page_Up",   hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
    hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
    hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
    hl.bind("SUPER + ALT + mouse_up",   hl.dsp.window.move({ workspace = "+1" }))
    hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
    hl.bind("CTRL + SUPER + SHIFT + left",  hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
    -- Move window to/from special workspace
    hl.bind("CTRL + SUPER + SHIFT + up",   hl.dsp.window.move({ workspace = "special:special" }))
    hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
    hl.bind("SUPER + ALT + S",             hl.dsp.window.move({ workspace = "special:special" }))

    -- Window groups
    hl.bind("ALT + Tab",         hl.dsp.window.cycle_next({ next = true }), { repeating = true })
    hl.bind("SHIFT + ALT + Tab", hl.dsp.window.cycle_next({ prev = true }), { repeating = true })
    hl.bind("CTRL + ALT + Tab",       hl.dsp.group.next(), { repeating = true })
    hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
    hl.bind("SUPER + Comma", hl.dsp.group.toggle())
    hl.bind("SUPER + U",     hl.dsp.window.move({ out_of_group = true }))
    hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active({ action = "toggle" }))

    -- Window actions
    hl.bind("SUPER + left",  hl.dsp.focus({ direction = "l" }))
    hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
    hl.bind("SUPER + up",    hl.dsp.focus({ direction = "u" }))
    hl.bind("SUPER + down",  hl.dsp.focus({ direction = "d" }))
    hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
    hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
    hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
    hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
    hl.bind("SUPER + Minus", hl.dsp.layout("splitratio -0.1"), { repeating = true })
    hl.bind("SUPER + Equal", hl.dsp.layout("splitratio 0.1"),  { repeating = true })
    hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind("SUPER + Z",         hl.dsp.window.drag(),   { mouse = true })
    hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
    hl.bind("CTRL + SUPER + ALT + Backslash", function()
        local m = hl.get_active_monitor(); if not m then return end
        hl.dispatch(hl.dsp.window.resize({ x = math.floor(m.width * 55 / 100), y = math.floor(m.height * 70 / 100) }))
    end)
    hl.bind("CTRL + SUPER + ALT + Backslash", hl.dsp.window.center())
    hl.bind("SUPER + P", hl.dsp.window.pin())
    hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })) -- Fullscreen with borders
    hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
    hl.bind("SUPER + W", hl.dsp.window.close())
    hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))

    -- Apps
    hl.bind("SUPER + return",         hl.dsp.exec_cmd("app2unit -- foot"))
    hl.bind("SUPER + SHIFT + return", hl.dsp.exec_cmd("app2unit -- foot -T foot-float"))
    hl.bind("SUPER + B", hl.dsp.exec_cmd("app2unit -- firefox"))
    hl.bind("SUPER + C", hl.dsp.exec_cmd("app2unit -- codium"))
    hl.bind("SUPER + G", hl.dsp.exec_cmd("app2unit -- github-desktop"))
    hl.bind("SUPER + E", hl.dsp.exec_cmd("app2unit -- nautilus"))
    hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("app2unit -- nemo"))
    hl.bind("CTRL + ALT + Escape", hl.dsp.exec_cmd("app2unit -- qps"))
    hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd("app2unit -- pavucontrol-qt"))

    -- Utilities
    hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a")) -- Colour picker

    -- Volume
    hl.bind("XF86AudioMute",     hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
    hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),   { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })

    -- Sleep
    hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"))

    -- Clipboard and emoji picker
    hl.bind("SUPER + V",      hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
    hl.bind("SUPER + Period", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo"))
    hl.bind("CTRL + SHIFT + ALT + V", hl.dsp.exec_cmd([[sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"]]), { locked = true }) -- Alternate paste

    -- Testing
    hl.bind("SUPER + ALT + f12", hl.dsp.exec_cmd([[notify-send -u low -i dialog-information-symbolic 'Test notification' "Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!" -a 'Shell' -A "Test1=I got it!" -A "Test2=Another action"]]), { locked = true })
end)

-- Enter the global submap on startup (mirrors `exec = hyprctl dispatch submap global`)
hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.submap("global"))
end)

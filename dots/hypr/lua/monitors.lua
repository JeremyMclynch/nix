-- Monitors (the monitorv2 blocks from the old hyprland.conf).

-- Laptop default fallback
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.monitor({ output = "eDP-1", mode = "2880x1800@120", position = "0x0",     scale = 1.6 })
hl.monitor({ output = "DP-4",  mode = "3840x2160",     position = "-1920x0", scale = 2 })
hl.monitor({ output = "DP-6",  mode = "3840x2160",     position = "0x-1080", scale = 2 })

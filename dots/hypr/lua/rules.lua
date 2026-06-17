-- Window / workspace / layer rules (from hyprland/rules-noctalia.conf).

local vars = require("lua.variables")

-- ######## Window rules ########

hl.window_rule({ match = { fullscreen = 0 }, opacity = vars.windowOpacity .. " override" })

-- Native transparency / want opaque
hl.window_rule({ match = { class = "foot|equibop|org\\.quickshell|imv|swappy" }, opaque = true })
-- Center all floating windows (not xwayland, because of popups)
hl.window_rule({ match = { float = 1, xwayland = 0 }, center = true })

-- Float
hl.window_rule({ match = { class = "guifetch" }, float = true }) -- FlafyDev/guifetch
hl.window_rule({ match = { class = "yad" }, float = true })
hl.window_rule({ match = { class = "zenity" }, float = true })
hl.window_rule({ match = { class = "wev" }, float = true })
hl.window_rule({ match = { class = "org\\.gnome\\.FileRoller" }, float = true })
hl.window_rule({ match = { class = "file-roller" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "com\\.github\\.GradienceTeam\\.Gradience" }, float = true })
hl.window_rule({ match = { class = "feh" }, float = true })
hl.window_rule({ match = { class = "imv" }, float = true })
hl.window_rule({ match = { class = "system-config-printer" }, float = true })
hl.window_rule({ match = { class = "org\\.quickshell" }, float = true })
hl.window_rule({ match = { title = "MATLAB\\ R2025b" }, float = false })
hl.window_rule({ match = { initial_title = "MATLAB" }, float = false })

-- Float, resize and center
hl.window_rule({
    match  = { class = "foot", title = "nmtui|btop|foot-float|rebuild" },
    float  = true,
    size   = "60% 70%",
    center = true,
})
hl.window_rule({
    match  = { title = "Volume\\ Control|Remmina\\ Remote\\ Desktop\\ Client|All\\ Files|WinBoat|winboat" },
    float  = true,
    size   = "60% 70%",
    center = true,
})
hl.window_rule({
    match  = { class = "nm-openconnect-auth-dialog|matplotlib" },
    float  = true,
    size   = "60% 70%",
    center = true,
})
hl.window_rule({
    match  = { class = "org\\.gnome\\.Nautilus|org.gnome.Loupe|nemo" },
    float  = true,
    size   = "70% 80%",
    center = true,
})
hl.window_rule({
    match  = { class = "pavucontrol-qt|yad-icon-browser|mpv" },
    float  = true,
    size   = "60% 70%",
    center = true,
})
hl.window_rule({
    match  = { class = "nwg-look" },
    float  = true,
    size   = "50% 60%",
    center = true,
})

-- Dialogs
hl.window_rule({ match = { title = "(Select|Open)( a)? (File|Folder)(s)?" }, float = true })
hl.window_rule({ match = { title = "File (Operation|Upload)( Progress)?" }, float = true })
hl.window_rule({ match = { title = ".* Properties" }, float = true })
hl.window_rule({ match = { title = "Export Image as PNG" }, float = true })
hl.window_rule({ match = { title = "GIMP Crash Debug" }, float = true })
hl.window_rule({ match = { title = "Save As" }, float = true })
hl.window_rule({ match = { title = "Library" }, float = true })

-- Picture in picture (resize and move done via script)
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "100%-w-2% 100%-w-3%", -- Initial move so it doesn't shoot across the screen
    keep_aspect_ratio = true,
    float             = true,
    pin               = true,
})

-- Steam
hl.window_rule({ match = { class = "steam" }, rounding = 10 })
hl.window_rule({ match = { class = "steam", title = "Friends List|Steam Settings" }, float = true })
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, immediate = true })          -- Allow tearing for steam games
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, idle_inhibit = "always" })   -- Always idle inhibit while playing

-- ATLauncher console
hl.window_rule({ match = { class = "com-atlauncher-App", title = "ATLauncher Console" }, float = true })

-- Autodesk Fusion 360
hl.window_rule({ match = { class = "fusion360\\.exe", title = "Fusion360|(Marking Menu)" }, no_blur = true })

-- Ugh xwayland popups
hl.window_rule({ match = { xwayland = 1, title = "win[0-9]+" }, no_dim = true })
hl.window_rule({ match = { xwayland = 1, title = "win[0-9]+" }, no_shadow = true })
hl.window_rule({ match = { xwayland = 1, title = "win[0-9]+" }, rounding = 10 })

-- ######## Workspace rules ########
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = vars.singleWindowGapsOut })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = vars.singleWindowGapsOut })

-- ######## Layer rules ########
hl.layer_rule({ match = { namespace = "hyprpicker" },    animation = "fade" }) -- Colour picker out animation
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" }) -- wlogout
hl.layer_rule({ match = { namespace = "selection" },     animation = "fade" }) -- slurp
hl.layer_rule({ match = { namespace = "wayfreeze" },     animation = "fade" })

-- Launcher
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%", blur = true })

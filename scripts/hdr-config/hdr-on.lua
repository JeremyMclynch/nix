-- Desktop monitors with HDR enabled.
-- Copied to ~/.config/hypr/hdr-current.lua by scripts/hdr-lua.sh and loaded
-- via `require("hdr-current")` from the Hyprland Lua config.

hl.monitor({
    output              = "DP-1",
    mode                = "2560x1440@240",
    position            = "0x0",
    scale               = 1,
    bitdepth            = 10,
    supports_hdr        = 1,
    supports_wide_color = 1,
    sdr_min_luminance   = 0.005,
    sdr_max_luminance   = 400,
    cm                  = "hdr",
})

hl.monitor({
    output              = "DP-2",
    mode                = "2560x1440@180",
    position            = "2560x0",
    scale               = 1,
    bitdepth            = 10,
    supports_hdr        = 1,
    supports_wide_color = 1,
    sdr_min_luminance   = 0.005,
    sdr_max_luminance   = 400,
    cm                  = "hdr",
})

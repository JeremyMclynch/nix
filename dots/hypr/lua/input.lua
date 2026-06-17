-- Input, binds, cursor + per-device touchpad toggle (from hyprland/input.conf).

local vars = require("lua.variables")

hl.config({
    input = {
        kb_layout          = "us",
        numlock_by_default = false,
        repeat_delay       = 250,
        repeat_rate        = 35,

        focus_on_close = 1,

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = vars.touchpadDisableTyping,
            clickfinger_behavior = true,
            tap_to_click         = false,
            scroll_factor        = vars.touchpadScrollFactor,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },

    cursor = {
        hotspot_padding = 1,
        no_warps        = true,
    },
})

hl.device({ name = "ven_2c2f:00-2c2f:002b-touchpad", enabled = true })

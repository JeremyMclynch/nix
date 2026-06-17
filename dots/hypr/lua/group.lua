-- Window groups + groupbar (from hyprland/group.conf).

local c    = require("lua.colors")
local vars = require("lua.variables")

hl.config({
    group = {
        col = {
            border_active        = vars.activeWindowBorderColour,
            border_inactive      = vars.inactiveWindowBorderColour,
            border_locked_active = vars.activeWindowBorderColour,
            border_locked_inactive = vars.inactiveWindowBorderColour,
        },

        groupbar = {
            font_family               = "JetBrains Mono NF",
            font_size                 = 15,
            gradients                 = true,
            gradient_round_only_edges = false,
            gradient_rounding         = 5,
            height                    = 25,
            indicator_height          = 0,
            gaps_in                   = 3,
            gaps_out                  = 3,

            text_color = "rgb(" .. c.onPrimary .. ")",
            col = {
                active         = "rgba(" .. c.primary .. "d4)",
                inactive       = "rgba(" .. c.outline .. "d4)",
                locked_active  = "rgba(" .. c.primary .. "d4)",
                locked_inactive = "rgba(" .. c.secondary .. "d4)",
            },
        },
    },
})

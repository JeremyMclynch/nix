-- Shared styling values (converted from variables.conf).
-- Only the values still referenced by other modules are kept here; the
-- keybind aliases ($kb*) and app names from variables.conf are inlined
-- directly into lua/binds.lua instead.

local c = require("lua.colors")

return {
    -- Gaps
    workspaceGaps       = 20,
    windowGapsIn        = 10,
    windowGapsOut       = 10,
    singleWindowGapsOut = 10,

    -- Window border
    windowBorderSize           = 3,
    activeWindowBorderColour   = "rgba(" .. c.primary .. "e6)",
    inactiveWindowBorderColour = "rgba(" .. c.onSurfaceVariant .. "11)",

    -- Blur
    blurEnabled      = true,
    blurSpecialWs    = false,
    blurPopups       = true,
    blurInputMethods = true,
    blurSize         = 8,
    blurPasses       = 2,
    blurXray         = false,

    -- Shadow
    shadowEnabled     = true,
    shadowRange       = 20,
    shadowRenderPower = 3,
    shadowColour      = "rgba(" .. c.surface .. "d4)",

    -- Window styling
    windowOpacity  = 0.95,
    windowRounding = 10,

    -- Touchpad
    touchpadDisableTyping = true,
    touchpadScrollFactor  = 0.3,

    -- Gestures
    workspaceSwipeFingers = 4,
    gestureFingers        = 3,
    gestureFingersMore    = 4,

    -- Cursor
    cursorTheme = "Adwaita",
    cursorSize  = 24,
}

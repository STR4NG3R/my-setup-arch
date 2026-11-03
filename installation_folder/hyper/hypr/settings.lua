-- ═══════════════════════════════════════════════
-- settings.lua
-- Ajustes generales: xwayland, input, general, decoration,
-- animaciones y layout dwindle.
-- Uso: require("settings").apply()
-- ═══════════════════════════════════════════════

local M = {}

function M.apply()
    -- XWAYLAND
    hl.config({
        xwayland = {
            force_zero_scaling = true,
            enabled = true,
        },
    })

    -- INPUT
    hl.config({
        input = {
            kb_layout = "us",
            follow_mouse = 1,
            sensitivity = 0,
        },
    })

    -- GENERAL
    hl.config({
        general = {
            border_size = 0,
            gaps_in = 0,
            gaps_out = 0,
            layout = "dwindle",
        },
    })

    -- DECORATION (modern, edge-to-edge)
    hl.config({
        decoration = {
            rounding = 0,
            active_opacity = 1.0,
            inactive_opacity = 0.92,
            fullscreen_opacity = 1.0,

            blur = {
                enabled = true,
                size = 8,
                passes = 3,
                noise = 0.015,
                contrast = 1.1,
                brightness = 0.9,
                vibrancy = 0.17,
                new_optimizations = true,
            },

            -- Sombra (descomenta si la quieres):
            -- shadow = { enabled = true, range = 18, render_power = 3, color = 0x55000000 },
        },
    })

    -- ANIMATIONS
    hl.config({ animations = { enabled = true } })

    hl.curve("smooth", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })

    hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "smooth" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smooth", style = "popin 80%" })
    hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smooth", style = "slide" })

    -- DWINDLE
    hl.config({ dwindle = { preserve_split = true } })
end

return M

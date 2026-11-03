-- ═══════════════════════════════════════════════
-- keybinds.lua
-- Atajos del sistema, ventanas, workspaces, multimedia y capturas.
-- Los lanzadores de aplicaciones por categoría viven en apps.lua.
-- Uso: require("keybinds").setup({ mod = "SUPER", term = "kitty" })
-- ═══════════════════════════════════════════════

local M = {}

function M.setup(opts)
    local mod = opts.mod
    local term = opts.term
    local monitors = opts.monitors

    -- ── Ventanas ───────────────────────────────────────────────
    hl.bind(mod .. " + Q", hl.dsp.window.close())
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(term))
    hl.bind(mod .. " + G", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

    -- ── Lanzadores rápidos / utilidades ────────────────────────
    hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd('fuzzel --launch-prefix=""'))
    hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
    hl.bind(mod .. " + M", hl.dsp.exec_cmd("~/.config/scripts/move_screen.sh"))
    hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("~/.config/scripts/window_switcher.sh"))
    hl.bind(mod .. " + C", hl.dsp.exec_cmd("~/.config/hypr/lock.sh"))

    -- ── Ratón ──────────────────────────────────────────────────
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind(mod .. " + mouse:274", hl.dsp.window.center(), { mouse = true })

    -- ── Focus HJKL ─────────────────────────────────────────────
    hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
    hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
    hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
    hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

    -- ── Mover ventana HJKL ─────────────────────────────────────
    hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
    hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
    hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
    hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

    -- ── Workspaces relativos al monitor activo (ver monitors.lua) ──
    -- SUPER + <tecla>         -> cambia al "workspace N" del monitor del cursor
    -- SUPER + SHIFT + <tecla> -> mueve la ventana a ese workspace
    local workspaces = {
        { key = "A", id = 1 },
        { key = "S", id = 2 },
        { key = "D", id = 3 },
        { key = "F", id = 4 },
        { key = "U", id = 5 },
        { key = "I", id = 6 },
        { key = "O", id = 7 },
        { key = "P", id = 8 },
    }
    monitors.bind_workspaces(mod, workspaces)

    -- Mover entre monitores (descomenta si lo usas):
    -- hl.bind(mod .. " + CTRL + H", hl.dsp.window.move({ monitor = "l" }))
    -- hl.bind(mod .. " + CTRL + L", hl.dsp.window.move({ monitor = "r" }))

    -- ── Audio ──────────────────────────────────────────────────
    hl.bind(
        "XF86AudioRaiseVolume",
        hl.dsp.exec_cmd("~/.config/waybar/scripts/pavolume.sh --up"),
        { locked = true, repeating = true }
    )
    hl.bind(
        "XF86AudioLowerVolume",
        hl.dsp.exec_cmd("~/.config/waybar/scripts/pavolume.sh --down"),
        { locked = true, repeating = true }
    )
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/waybar/scripts/pavolume.sh --togmute"), { locked = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

    -- ── Reproducción multimedia (playerctl) ────────────────────
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

    -- ── Brillo (light + OSD) ───────────────────────────────────
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/scripts/brightness-osd.sh up"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/scripts/brightness-osd.sh down"), { locked = true, repeating = true })

    -- ── Capturas ───────────────────────────────────────────────
    hl.bind(
        "Print",
        hl.dsp.exec_cmd(
            [[grim - | wl-copy && notify-send "Captura de pantalla" "Pantalla completa copiada al portapapeles"]]
        )
    )
    hl.bind(
        mod .. " + SHIFT + Print",
        hl.dsp.exec_cmd(
            [[grim -g "$(slurp)" - | wl-copy && notify-send "Captura de pantalla" "Zona seleccionada copiada al portapapeles"]]
        )
    )
    hl.bind(
        mod .. " + Print",
        hl.dsp.exec_cmd(
            [[grim -g "$(slurp)" ~/Imágenes/Captura_$(date +'%Y%m%d_%H%M%S').png && notify-send "Captura de pantalla" "Guardada en ~/Imágenes"]]
        )
    )

    -- ── OCR: seleccionar zona y copiar su texto al portapapeles ──
    hl.bind(mod .. " + SHIFT + 0", hl.dsp.exec_cmd("~/.config/scripts/ocr-clipboard.sh"))
end

return M

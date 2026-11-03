-- ═══════════════════════════════════════════════
-- apps.lua
-- Lanzadores de aplicaciones organizados por CATEGORÍA.
--
-- Modificador dedicado: SUPER + ALT + <tecla>
-- (elegido para no chocar con los binds de workspaces SUPER+A..P
--  ni con el focus/mover de SUPER / SUPER+SHIFT).
--
-- Edita la tabla `categories` para añadir/quitar apps. Cada entrada:
--   { key = "<tecla>", cmd = "<comando>", desc = "descripción" }
--
-- Uso: en hyprland.lua ->  require("apps").setup("SUPER")
-- ═══════════════════════════════════════════════

local M = {}

-- Submodificador para TODOS los lanzadores de apps.
-- Cámbialo aquí si quieres otra combinación (p.ej. "SUPER + CTRL").
local LAUNCH_MOD_SUFFIX = "ALT"

-- ── Catálogo de apps por categoría ─────────────────────────────
-- Las categorías son solo para organizar visualmente; no afectan
-- al binding. Comenta las apps que no tengas instaladas.
local categories = {
    ["Terminal / Shell"] = {
        { key = "RETURN", cmd = "kitty",                 desc = "Terminal (kitty)" },
    },

    ["Navegadores"] = {
        { key = "B",      cmd = "firefox",               desc = "Firefox" },
        -- { key = "SHIFT + B", cmd = "chromium",         desc = "Chromium" },
    },

    ["Archivos"] = {
        { key = "E",      cmd = "thunar",                desc = "Gestor de archivos (Thunar)" },
    },

    ["Editores / IDE"] = {
        { key = "C",      cmd = "code",                  desc = "VS Code" },
        -- { key = "SHIFT + C", cmd = "lvim",             desc = "LunarVim (en terminal)" },
    },

    ["Multimedia"] = {
        -- { key = "M",   cmd = "spotify",               desc = "Spotify" },
        -- { key = "P",   cmd = "mpv",                   desc = "Reproductor (mpv)" },
    },

    ["Utilidades"] = {
        { key = "D",      cmd = "dbeaver",               desc = "DBeaver" },
        -- { key = "G",   cmd = "gimp",                  desc = "GIMP" },
    },

    ["Comunicación"] = {
        -- { key = "T",   cmd = "telegram-desktop",      desc = "Telegram" },
        -- { key = "W",   cmd = "whatsapp-for-linux",    desc = "WhatsApp" },
    },
}

--- Registra todos los binds de apps.
---@param mod string  modificador base (ej. "SUPER")
function M.setup(mod)
    local launch_mod = mod .. " + " .. LAUNCH_MOD_SUFFIX
    for _category, apps in pairs(categories) do
        for _, app in ipairs(apps) do
            hl.bind(
                launch_mod .. " + " .. app.key,
                hl.dsp.exec_cmd(app.cmd),
                { description = app.desc }
            )
        end
    end
end

--- Devuelve el catálogo (por si otro módulo quiere mostrar un menú/cheatsheet).
function M.get_categories()
    return categories
end

return M

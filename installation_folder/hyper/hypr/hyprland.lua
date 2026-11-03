-- ═══════════════════════════════════════════════
-- hyprland.lua  —  punto de entrada (orquestador)
--
-- La configuración está dividida en módulos dentro de ~/.config/hypr:
--   • settings.lua   -> xwayland, input, general, decoration, anims, dwindle
--   • monitors.lua   -> workspaces por monitor + rebalanceo dinámico
--   • keybinds.lua   -> atajos de sistema/ventanas/workspaces/media/capturas
--   • apps.lua       -> lanzadores de apps por CATEGORÍA (SUPER + ALT + tecla)
--   • rules.lua      -> window rules (incluye fix de "ventana que cubre todo")
--   • autostart.lua  -> procesos al iniciar la sesión
-- ═══════════════════════════════════════════════

local mod = "SUPER"
local term = "kitty"

-- Monitor (auto detect)
hl.monitor({ mode = "preferred", position = "auto", scale = 1, output = "," })

-- ── Workspaces por monitor (debe cargarse antes de los keybinds) ──
local monitors = require("monitors")
monitors.apply_workspace_rules() -- asigna ws 1..9 / 11..19 / 21..29 por monitor
monitors.watch_monitor_changes() -- reaplica al conectar/desconectar monitores

-- ── Ajustes generales ──────────────────────────────────────────
require("settings").apply()

-- ── Atajos de teclado ──────────────────────────────────────────
require("keybinds").setup({ mod = mod, term = term, monitors = monitors })

-- ── Lanzadores de apps por categoría (SUPER + ALT + tecla) ─────
require("apps").setup(mod)

-- ── Reglas de ventana ──────────────────────────────────────────
require("rules").apply()

-- ── Autostart ──────────────────────────────────────────────────
require("autostart").setup()

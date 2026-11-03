-- ═══════════════════════════════════════════════
-- rules.lua
-- Reglas de ventana (window rules).
-- Uso: require("rules").apply()
-- ═══════════════════════════════════════════════

local M = {}

function M.apply()
    -- ── Fix: evitar que las ventanas "cubran" todo al abrir ─────
    -- Algunas apps (incluidas terminales) piden maximizarse al abrir,
    -- lo que hace que tapen el resto de pantallas. Ignoramos esas
    -- peticiones de maximizar para TODAS las apps. (Recomendado por
    -- la documentación de Hyprland.)
    hl.window_rule({
        name = "suppress-maximize",
        match = { class = ".*" },
        suppress_event = "maximize",
    })

    -- ── Apps ancladas a un workspace fijo ──────────────────────
    -- Chrome siempre se abre en el workspace del NAVEGADOR (ws 1,
    -- el "SUPER + A" del monitor izquierdo / base del esquema).
    -- Si prefieres el navegador en el monitor derecho, cambia "1"
    -- por "11" (ver numeración en monitors.lua).
    hl.window_rule({
        name = "chrome-al-navegador",
        match = { class = "^(google-chrome|Google-chrome|google-chrome-stable)$" },
        workspace = "1",
    })

    -- Otras apps ancladas a su workspace (índice local, monitor base):
    --   kitty   -> ws 2 (SUPER + S)
    --   VS Code -> ws 3 (SUPER + D)
    --   Thunar  -> ws 4 (SUPER + F)
    --   DBeaver -> ws 7 (SUPER + O)
    hl.window_rule({
        name = "kitty-al-ws2",
        match = { class = "^(kitty)$" },
        workspace = "2",
    })
    hl.window_rule({
        name = "vscode-al-ws3",
        match = { class = "^(code|Code|code-oss|code-url-handler|VSCodium)$" },
        workspace = "3",
    })
    hl.window_rule({
        name = "thunar-al-ws4",
        match = { class = "^(thunar|org.xfce.thunar|Thunar)$" },
        workspace = "4",
    })
    hl.window_rule({
        name = "dbeaver-al-ws7",
        match = { class = "^(dbeaver|DBeaver|io.dbeaver.DBeaver)$" },
        workspace = "7",
    })

    -- Si el problema persiste SOLO con la terminal, descomenta esto
    -- para forzarla a abrir en modo mosaico normal (no flotante,
    -- no fullscreen) en una posición predecible:
    -- hl.window_rule({
    --     name  = "kitty-tiled",
    --     match = { class = "^(kitty)$" },
    --     float = false,
    --     fullscreen = false,
    -- })

    -- O, si prefieres que la terminal sea FLOTANTE y centrada
    -- (estilo dropdown), descomenta esto en su lugar:
    -- hl.window_rule({
    --     name  = "kitty-floating",
    --     match = { class = "^(kitty)$" },
    --     float = true,
    --     center = true,
    --     size = "1000 600",
    -- })

    -- ── Diálogos como FLOTANTES CENTRADOS ──────────────────────
    -- Hace flotar (y centrar) los diálogos típicos que, de otro modo,
    -- Hyprland colocaría en mosaico creando una ventana molesta:
    -- Imprimir, Guardar como, Abrir archivo, Exportar, Preferencias…
    -- Se filtra por TÍTULO (independiente de la app) para cubrir los
    -- diálogos de Chrome/Firefox/GTK/Qt de una sola vez.
    hl.window_rule({
        name = "dialogos-por-titulo",
        match = {
            title = "^(.*[Ii]mprimir.*|.*[Pp]rint.*|[Gg]uardar.*|.*[Ss]ave.*[Aa]s.*|"
                .. "[Aa]brir.*|.*[Oo]pen.*[Ff]ile.*|[Ee]xportar.*|.*[Ee]xport.*|"
                .. ".*[Pp]references.*|[Pp]referencias.*|[Cc]onfirmar.*|.*[Pp]rogreso.*)$",
        },
        float = true,
        center = true,
    })

    -- Diálogos GTK/portales (Guardar/Abrir nativos de GTK y Flatpak).
    hl.window_rule({
        name = "dialogos-gtk-portal",
        match = { class = "^(xdg-desktop-portal-.*|org.freedesktop.portal.*)$" },
        float = true,
        center = true,
    })

    -- Ventanas que se declaran a sí mismas como diálogo modal
    -- (muchas apps GTK/Qt y XWayland lo hacen). role/modal.
    hl.window_rule({
        name = "dialogos-modales",
        match = { title = "^(Open|Save|Save As|Save File|Print|Export|Choose.*)$" },
        float = true,
        center = true,
    })

    -- ── Popups flotantes de Thunar ─────────────────────────────
    hl.window_rule({
        name = "popups-thunar",
        match = {
            class = "^(thunar|org.xfce.thunar)$",
            title = "^(Abrir archivo|Guardar archivo|Confirmar|.*[Pp]rogreso.*)$",
        },
        float = true,
        center = true,
    })

    -- ── Compresores / extractores (file-roller, xarchiver, ark…) ──
    -- Flotantes y centrados en vez de crear una ventana en mosaico.
    hl.window_rule({
        name = "compresores",
        match = {
            class = "^(file-roller|org.gnome.FileRoller|xarchiver|ark|engrampa|org.kde.ark)$",
        },
        float = true,
        center = true,
        size = "800 600",
    })

    -- ── Otros diálogos comunes que molestan en mosaico ─────────
    -- Selectores de color, autenticación (polkit), calculadora, etc.
    hl.window_rule({
        name = "misc-flotantes",
        match = {
            class = "^(org.gnome.Calculator|galculator|blueberry.py|nm-connection-editor|"
                .. "polkit-gnome-authentication-agent-1|pavucontrol|org.pulseaudio.pavucontrol)$",
        },
        float = true,
        center = true,
    })
end

return M

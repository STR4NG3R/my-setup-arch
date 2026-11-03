-- ═══════════════════════════════════════════════
-- autostart.lua
-- Procesos que arrancan junto con Hyprland.
-- Uso: require("autostart").setup()
-- ═══════════════════════════════════════════════

local M = {}

-- Lista de comandos a ejecutar al iniciar la sesión.
-- Comenta/añade según necesites.
local programs = {
    "hyprctl setcursor Bibata-Modern-Classic 24",
    "gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic",
    "gsettings set org.gnome.desktop.interface cursor-size 24",
    "waybar",
    "swaync",
    "nm-applet",
    "udiskie",
    "blueberry-tray",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "hypridle",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
}

function M.setup()
    hl.on("hyprland.start", function()
        for _, cmd in ipairs(programs) do
            hl.exec_cmd(cmd)
        end
    end)
end

return M

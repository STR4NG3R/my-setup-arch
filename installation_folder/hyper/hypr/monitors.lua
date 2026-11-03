-- ═══════════════════════════════════════════════
-- monitors.lua
-- Distribución de workspaces por monitor + rebalanceo dinámico.
--
-- Lógica de numeración:
--   Los monitores se ordenan por posición (X, luego Y), de izquierda
--   a derecha. A cada monitor se le asigna un "base" de workspaces:
--
--       base(monitor) = index * GAP        (index empieza en 0)
--
--   El workspace real para la tecla local `n` (1..PER_MONITOR) es:
--
--       workspace = base + n
--
--   Con GAP = 10:
--     Monitor 0 (izquierda) -> ws 1..9   (base 0)
--     Monitor 1 (centro)    -> ws 11..19 (base 10)
--     Monitor 2 (derecha)   -> ws 21..29 (base 20)
--
--   Los keybinds de workspace son RELATIVOS al monitor bajo el cursor:
--   SUPER+A siempre va al "workspace 1" del monitor en el que estás.
--
-- Rebalanceo dinámico:
--   • Al DESCONECTAR un monitor: sus workspaces con ventanas se mueven
--     al monitor vecino (el de la izquierda si existe, si no el de la
--     derecha). Luego se reaplican las reglas de numeración.
--   • Al CONECTAR un monitor: solo se reaplican las reglas. El monitor
--     nuevo queda "limpio" (con su workspace default vacío) para que
--     tú muevas manualmente lo que quieras.
-- ═══════════════════════════════════════════════

local M = {}

-- ── Configuración ──────────────────────────────
local GAP = 10         -- separación entre bases de cada monitor
local PER_MONITOR = 9  -- cuántos workspaces usables por monitor (1..9)

M.GAP = GAP
M.PER_MONITOR = PER_MONITOR

-- ── Utilidades ─────────────────────────────────

--- Devuelve los monitores habilitados, ordenados por posición (X, luego Y).
---@return table[]  lista de monitores con al menos campos name, x, y
local function sorted_monitors()
    local mons = hl.get_monitors() or {}
    local list = {}
    for _, m in ipairs(mons) do
        -- ignoramos monitores deshabilitados/sin nombre para la numeración
        if m and m.name and m.name ~= "" and m.disabled ~= true then
            table.insert(list, m)
        end
    end
    table.sort(list, function(a, b)
        if a.x ~= b.x then
            return a.x < b.x
        end
        return a.y < b.y
    end)
    return list
end

--- base de workspaces para un índice de monitor (0-based).
---@param index integer
---@return integer
local function base_for_index(index)
    return index * GAP
end

--- Conjunto de todos los workspaces "gestionados" por este esquema,
--- hasta `slots` monitores. Sirve para limpiar reglas huérfanas.
---@param slots integer
---@return table<integer, boolean>
local function managed_workspace_set(slots)
    local set = {}
    for i = 0, slots - 1 do
        local base = base_for_index(i)
        for n = 1, PER_MONITOR do
            set[base + n] = true
        end
    end
    return set
end

--- Dado un nombre de monitor, devuelve su base. nil si no se encuentra.
---@param name string
---@return integer|nil
function M.base_for_monitor(name)
    local list = sorted_monitors()
    for i, m in ipairs(list) do
        if m.name == name then
            return base_for_index(i - 1) -- i es 1-based, index es 0-based
        end
    end
    return nil
end

--- Monitor actualmente activo (bajo el cursor, con fallback al enfocado).
---@return table|nil
local function active_monitor()
    local m = hl.get_monitor_at_cursor()
    if m then
        return m
    end
    return hl.get_active_monitor()
end

--- Calcula el workspace absoluto para la tecla local `n` en el monitor activo.
---@param n integer  número local 1..PER_MONITOR
---@return integer
function M.local_workspace(n)
    local base = 0
    local mon = active_monitor()
    if mon then
        local b = M.base_for_monitor(mon.name)
        if b ~= nil then
            base = b
        end
    end
    return base + n
end

--- Devuelve el monitor vecino de `ref` entre los monitores actuales.
--- Prioriza el vecino de la IZQUIERDA (menor X); si no hay, toma el de la
--- derecha. `ref` puede ser un objeto monitor o un nombre.
---@param ref table|string
---@return table|nil  monitor vecino, o nil si no hay otro monitor
local function neighbor_of(ref)
    local ref_name, ref_x, ref_y
    if type(ref) == "table" then
        ref_name = ref.name
        ref_x = ref.x
        ref_y = ref.y
    else
        ref_name = ref
    end

    local list = sorted_monitors()
    -- quitar el monitor de referencia de la lista de candidatos
    local others = {}
    for _, m in ipairs(list) do
        if m.name ~= ref_name then
            table.insert(others, m)
        end
    end
    if #others == 0 then
        return nil
    end

    -- Si conocemos la X de referencia, elegir el más cercano por la izquierda.
    if type(ref_x) == "number" then
        local left_best, right_best
        for _, m in ipairs(others) do
            if m.x <= ref_x then
                if not left_best or m.x > left_best.x then
                    left_best = m
                end
            else
                if not right_best or m.x < right_best.x then
                    right_best = m
                end
            end
        end
        return left_best or right_best
    end

    -- Sin X conocida: devolver el primero (más a la izquierda).
    return others[1]
end

-- ── Asignación de workspaces a monitores ───────

--- Crea las workspace_rules que anclan cada rango de workspaces a su monitor.
--- También migra workspaces con ventanas que hayan quedado fuera del esquema
--- actual (p. ej. rangos de un monitor desconectado) al primer monitor.
--- Se puede llamar de nuevo cuando cambian los monitores.
function M.apply_workspace_rules()
    local list = sorted_monitors()
    if #list == 0 then
        return
    end

    -- 1) Reasignar cada rango al monitor que le corresponde por posición.
    for i, m in ipairs(list) do
        local base = base_for_index(i - 1)
        for n = 1, PER_MONITOR do
            local ws = base + n
            hl.workspace_rule({
                workspace  = tostring(ws),
                monitor    = m.name,
                -- el primer workspace de cada monitor es el default
                default    = (n == 1) or nil,
                -- mantenemos persistente el primero para que el monitor
                -- siempre tenga su workspace "de inicio"
                persistent = (n == 1) or nil,
            })
        end
    end

    -- 2) Rescatar workspaces con ventanas que pertenecen a rangos de
    --    monitores que ya no existen (índices >= #list). Esos workspaces
    --    quedarían huérfanos; los movemos al primer monitor para no perder
    --    las ventanas de vista.
    local managed = managed_workspace_set(#list)
    local first_mon = list[1]
    local wss = hl.get_workspaces() or {}
    for _, w in ipairs(wss) do
        local id = w.id
        local win_count = w.windows or 0
        -- solo workspaces numéricos normales (id > 0), fuera del esquema
        -- actual y con ventanas abiertas
        if type(id) == "number" and id > 0 and win_count > 0 and not managed[id] then
            hl.dispatch(hl.dsp.workspace.move({
                workspace = tostring(id),
                monitor   = first_mon.name,
            }))
        end
    end
end

-- ── Rebalanceo al desconectar un monitor ───────

--- Mueve al monitor vecino todos los workspaces (con ventanas) que vivían
--- en el monitor `removed`. Debe llamarse cuando se desconecta un monitor.
---@param removed table|string  monitor removido (objeto del evento) o nombre
function M.rebalance_removed(removed)
    local removed_name = (type(removed) == "table") and removed.name or removed
    if not removed_name then
        return
    end

    local target = neighbor_of(removed)
    if not target then
        -- No queda otro monitor; nada que rebalancear.
        return
    end

    -- Mover los workspaces que todavía apuntan al monitor removido y que
    -- tengan ventanas. Nota: según el estado, Hyprland puede ya haber
    -- reubicado algunos; movemos explícitamente al vecino elegido.
    local wss = hl.get_workspaces() or {}
    for _, w in ipairs(wss) do
        local mon_name
        if type(w.monitor) == "table" then
            mon_name = w.monitor.name
        else
            mon_name = w.monitor
        end
        local win_count = w.windows or 0
        local id = w.id
        if type(id) == "number" and id > 0 and win_count > 0 and mon_name == removed_name then
            hl.dispatch(hl.dsp.workspace.move({
                workspace = tostring(id),
                monitor   = target.name,
            }))
        end
    end
end

-- ── Keybinds relativos al monitor activo ───────

--- Registra los binds de workspace usando un mapa tecla->número local.
--- SUPER + <tecla> cambia TODOS los monitores a su "workspace N" local
--- al mismo tiempo (monitor 0 -> N, monitor 1 -> GAP+N, etc.), dejando el
--- foco en el monitor que estaba activo.
---@param mod string              modificador (ej. "SUPER")
---@param keymap table            lista de { key = "A", id = 1 }
function M.bind_workspaces(mod, keymap)
    for _, ws in ipairs(keymap) do
        local n = ws.id

        -- Cambiar el workspace N en TODOS los monitores a la vez.
        hl.bind(mod .. " + " .. ws.key, function()
            local list = sorted_monitors()
            if #list == 0 then
                return
            end

            -- Monitor que debe conservar el foco (bajo cursor o activo).
            local focus_mon = active_monitor()
            local focus_name = focus_mon and focus_mon.name or nil

            -- 1) Cambiar primero todos los monitores EXCEPTO el enfocado,
            --    para que el foco termine en el monitor correcto.
            local focus_target = nil
            for i, m in ipairs(list) do
                local base = base_for_index(i - 1)
                local target = base + n
                if m.name == focus_name then
                    focus_target = target
                else
                    hl.dispatch(hl.dsp.focus({ workspace = tostring(target) }))
                end
            end

            -- 2) Finalmente, enfocar el workspace del monitor activo
            --    (si lo conocemos), dejando ahí el foco.
            if focus_target then
                hl.dispatch(hl.dsp.focus({ workspace = tostring(focus_target) }))
            end
        end)

        -- Mover ventana al workspace N del monitor activo (relativo).
        hl.bind(mod .. " + SHIFT + " .. ws.key, function()
            hl.dispatch(hl.dsp.window.move({ workspace = tostring(M.local_workspace(n)) }))
        end)
    end
end

-- ── Reaccionar a cambios de monitores en caliente ──

--- Reaplica las reglas cuando se conecta/desconecta un monitor.
---  • added   -> solo reaplica reglas (monitor nuevo queda limpio)
---  • removed -> mueve sus workspaces al vecino y luego reaplica reglas
function M.watch_monitor_changes()
    hl.on("monitor.added", function(_mon)
        -- El monitor nuevo queda limpio; solo recalculamos la numeración.
        M.apply_workspace_rules()
    end)

    hl.on("monitor.removed", function(mon)
        -- 1) Rescatar las ventanas del monitor que se fue al vecino.
        M.rebalance_removed(mon)
        -- 2) Recalcular la numeración con los monitores restantes.
        M.apply_workspace_rules()
    end)
end

return M

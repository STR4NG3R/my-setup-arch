#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# window_switcher.sh
# Muestra todas las ventanas abiertas en wofi (con icono de la app).
# Al seleccionar una, salta a su workspace/monitor y la enfoca.
# ──────────────────────────────────────────────────────────────

set -euo pipefail

# ── Directorios estándar ───────────────────────────────────────
DESKTOP_DIRS=(
    "$HOME/.local/share/applications"
    /usr/share/applications
    /usr/local/share/applications
)
ICON_DIRS=(
    "$HOME/.local/share/icons"
    /usr/share/icons
    /usr/share/pixmaps
)
# Tamaños preferidos (de mayor a menor) para iconos rasterizados.
ICON_SIZES=(256x256 128x128 96x96 64x64 48x48 scalable 32x32 24x24 16x16)
# Temas preferidos (en orden). Se prueban primero; luego cualquier otro
# tema presente como último recurso. Evita que iconos de accesibilidad
# (HighContrast) ganen por orden alfabético.
PREFERRED_THEMES=(hicolor Adwaita AdwaitaLegacy elementary)
# Subcarpetas de categoría dentro de cada tamaño donde buscar el icono.
ICON_CATEGORIES=(apps mimetypes categories devices places)
FALLBACK_ICON="application-x-executable"

# ── Cache de resolución clase -> ruta de icono ─────────────────
declare -A ICON_CACHE

# Busca el nombre de icono (campo Icon=) en el .desktop cuyo nombre
# o StartupWMClass coincida con la clase de ventana.
icon_name_for_class() {
    local class="$1"
    local lc_class="${class,,}"
    local f name

    for dir in "${DESKTOP_DIRS[@]}"; do
        [[ -d "$dir" ]] || continue
        # 1) coincidencia directa por nombre de archivo (clase.desktop)
        for f in "$dir/$class.desktop" "$dir/$lc_class.desktop"; do
            if [[ -f "$f" ]]; then
                name="$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)"
                [[ -n "$name" ]] && { printf '%s' "$name"; return 0; }
            fi
        done
    done

    # 2) coincidencia por StartupWMClass dentro de los .desktop
    for dir in "${DESKTOP_DIRS[@]}"; do
        [[ -d "$dir" ]] || continue
        f="$(grep -il "^StartupWMClass=$class$" "$dir"/*.desktop 2>/dev/null | head -1 || true)"
        if [[ -n "$f" ]]; then
            name="$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)"
            [[ -n "$name" ]] && { printf '%s' "$name"; return 0; }
        fi
    done

    # 3) sin .desktop: usar la propia clase como nombre de icono
    printf '%s' "$lc_class"
}

# Dado un nombre de icono, devuelve la ruta absoluta de un archivo real.
# Acepta rutas absolutas directamente.
resolve_icon_path() {
    local icon="$1"

    # Ya es una ruta absoluta existente.
    if [[ "$icon" == /* && -f "$icon" ]]; then
        printf '%s' "$icon"; return 0
    fi

    # Quitar extensión SOLO si es una de imagen conocida (no partir
    # nombres con puntos como org.xfce.thunar).
    local base="$icon"
    case "$icon" in
        *.png|*.svg|*.xpm) base="${icon%.*}" ;;
    esac

    local dir size ext cat hit theme

    # Construye la lista de temas: preferidos existentes + el resto.
    local -a themes=()
    for t in "${PREFERRED_THEMES[@]}"; do
        themes+=("$t")
    done

    for dir in "${ICON_DIRS[@]}"; do
        [[ -d "$dir" ]] || continue

        # pixmaps: planos, sin subcarpetas de tamaño/categoría
        if [[ "$dir" == */pixmaps ]]; then
            for ext in png svg xpm; do
                [[ -f "$dir/$base.$ext" ]] && { printf '%s' "$dir/$base.$ext"; return 0; }
            done
            continue
        fi

        # Orden de temas: preferidos primero, luego los demás presentes.
        local -a theme_order=()
        for t in "${themes[@]}"; do
            [[ -d "$dir/$t" ]] && theme_order+=("$t")
        done
        for d in "$dir"/*/; do
            local tname; tname="$(basename "$d")"
            local skip=0
            for t in "${theme_order[@]}"; do [[ "$t" == "$tname" ]] && skip=1; done
            [[ $skip -eq 0 ]] && theme_order+=("$tname")
        done

        # temas de iconos: <tema>/<size>/<categoria>/<icono>.<ext>
        for theme in "${theme_order[@]}"; do
            for size in "${ICON_SIZES[@]}"; do
                for cat in "${ICON_CATEGORIES[@]}"; do
                    for ext in png svg; do
                        hit="$dir/$theme/$size/$cat/$base.$ext"
                        [[ -f "$hit" ]] && { printf '%s' "$hit"; return 0; }
                    done
                done
            done
            # algunos temas (elementary) usan <tema>/<categoria>/<size>/...
            for cat in "${ICON_CATEGORIES[@]} mimes"; do
                for size in 128 64 48 256 32 24 16; do
                    for ext in svg png; do
                        hit="$dir/$theme/$cat/$size/$base.$ext"
                        [[ -f "$hit" ]] && { printf '%s' "$hit"; return 0; }
                    done
                done
            done
        done
    done

    return 1
}

# Devuelve (con cache) la ruta de icono para una clase de ventana.
icon_for_class() {
    local class="$1"
    if [[ -n "${ICON_CACHE[$class]:-}" ]]; then
        printf '%s' "${ICON_CACHE[$class]}"; return 0
    fi
    local name path
    name="$(icon_name_for_class "$class")"
    if path="$(resolve_icon_path "$name")"; then
        :
    else
        path="$(resolve_icon_path "$FALLBACK_ICON" || true)"
    fi
    ICON_CACHE[$class]="$path"
    printf '%s' "$path"
}

# ── Construir el menú ──────────────────────────────────────────
clients_json="$(hyprctl clients -j)"

# Lista cruda: cada línea => ws<TAB>class<TAB>title<TAB>address
raw="$(printf '%s' "$clients_json" | jq -r '
  sort_by(.workspace.id)
  | .[]
  | select(.mapped == true)
  | "\(.workspace.id)\t\(.class)\t\(.title)\t\(.address)"
')"

if [[ -z "$raw" ]]; then
    notify-send "Window switcher" "No hay ventanas abiertas" 2>/dev/null || true
    exit 0
fi

# Genera las entradas con formato de imagen de wofi:
#   img:/ruta/icono_app:text:<índice>: Clase — Título
# El índice es el LOCAL del monitor (1..9), derivado del workspace
# absoluto según el esquema de monitors.lua (GAP=10):
#   ws 1..9 -> 1..9,  ws 11..19 -> 1..9,  ws 21..29 -> 1..9
# Guardamos un mapa paralelo etiqueta-visible -> address para recuperar.
menu=""
declare -A ADDR_BY_LABEL
while IFS=$'\t' read -r ws class title address; do
    [[ -z "$address" ]] && continue
    icon="$(icon_for_class "$class")"
    # índice local 1..9 a partir del workspace absoluto
    if [[ "$ws" =~ ^[0-9]+$ ]] && (( ws > 0 )); then
        index=$(( (ws - 1) % 10 + 1 ))
    else
        index="$ws"   # workspaces especiales/nombrados: dejar tal cual
    fi
    label="$index: $class — $title"
    if [[ -n "$icon" ]]; then
        entry="img:$icon:text:$label"
    else
        entry="$label"
    fi
    menu+="$entry"$'\n'
    ADDR_BY_LABEL["$label"]="$address"
done <<< "$raw"

# ── Mostrar en wofi ────────────────────────────────────────────
chosen="$(printf '%s' "$menu" \
    | wofi --dmenu --allow-images --prompt "Ventanas" \
           --insensitive --width 700 --height 400)"

[[ -z "$chosen" ]] && exit 0

# wofi devuelve la etiqueta visible (sin el prefijo img:...:text:).
# Por si acaso, normalizamos quitando un posible prefijo de imagen.
label="${chosen#img:*:text:}"
address="${ADDR_BY_LABEL[$label]:-}"

[[ -z "$address" ]] && exit 0

# Enfoca la ventana por address (sintaxis Lua de este Hyprland).
# focus({ window = ... }) salta al workspace/monitor de la ventana.
hyprctl dispatch "hl.dsp.focus({ window = \"address:$address\" })"

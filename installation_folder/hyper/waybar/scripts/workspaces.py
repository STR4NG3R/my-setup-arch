#!/usr/bin/env python3
# ───────────────────────────────────────────────────────────────
# workspaces.py — módulo custom de Waybar para Hyprland
#
# Muestra SOLO el workspace activo del monitor en el que vive esta
# instancia de la barra, con el formato:  <icono> <índice_local>
#
# El "índice local" es la posición del workspace dentro de su monitor
# según el esquema de ~/.config/hypr/monitors.lua:
#     workspace_real = base + n   (base = index_monitor * GAP)
#     índice_local   = ((workspace_real - 1) % GAP) + 1   -> 1..GAP
#
# Se actualiza AUTOMÁTICAMENTE escuchando el socket de eventos de
# Hyprland (.socket2.sock). No usa polling ni socat ni jq.
#
# Uso en el config de Waybar (un módulo por barra):
#   "custom/workspace": {
#       "exec": "~/.config/waybar/scripts/workspaces.py $output",
#       "return-type": "json",
#       "restart-interval": 1
#   }
# donde $output es el nombre del monitor (ej. "HDMI-A-1").
# Si no se pasa output, usa el monitor enfocado.
# ───────────────────────────────────────────────────────────────
import json
import os
import socket
import subprocess
import sys

GAP = 10  # debe coincidir con monitors.lua

# Iconos por índice local (1..GAP). Cubre TODOS los índices posibles
# (1..10) para que NUNCA se use el fallback. Edítalos a tu gusto.
ICONS = {
    1:  "\U000f059f",  # 󰖟  internet / web
    2:  "\U000f018d",  # 󰆍  terminal
    3:  "\U000f0174",  # 󰅴  código
    4:  "\U000f024b",  # 󰉋  carpeta
    5:  "\U000f0b79",  # 󰭹  chat
    6:  "\U000f075a",  # 󰝚  música
    7:  "\U000f0eb5",  # 󰺵  juegos
    8:  "\U000f0493",  # 󰒓  config
    9:  "\U000f035c",  # 󰍜  menú
    10: "\U000f04ce",  # 󰓎  extra (estrella)
}
# Solo se usaría si por alguna razón el índice cae fuera de 1..GAP.
DEFAULT_ICON = "\U000f0765"  # 󰝥  circle


def local_index(ws_id: int) -> int:
    """Convierte el id absoluto del workspace a su índice local 1..GAP."""
    if ws_id is None or ws_id <= 0:
        return ws_id if ws_id is not None else 0
    return ((ws_id - 1) % GAP) + 1


def get_active_ws(target_output):
    """Devuelve (ws_id, monitor_name) del workspace activo del monitor target.
    Si target_output es None, usa el monitor con focus."""
    try:
        out = subprocess.check_output(["hyprctl", "monitors", "-j"], text=True)
        monitors = json.loads(out)
    except Exception:
        return None, None

    if not monitors:
        return None, None

    chosen = None
    if target_output:
        for m in monitors:
            if m.get("name") == target_output:
                chosen = m
                break
    if chosen is None:
        for m in monitors:
            if m.get("focused"):
                chosen = m
                break
    if chosen is None:
        chosen = monitors[0]

    aw = chosen.get("activeWorkspace", {}) or {}
    return aw.get("id"), chosen.get("name")


def emit(target_output):
    ws_id, mon = get_active_ws(target_output)
    if ws_id is None:
        print(json.dumps({"text": "", "tooltip": "sin workspace"}), flush=True)
        return
    idx = local_index(ws_id)
    icon = ICONS.get(idx, DEFAULT_ICON)
    payload = {
        "text": f"{icon}",
        "tooltip": f"Monitor {mon} · workspace {ws_id} (local {idx})",
        "class": f"ws-{idx}",
        "alt": str(idx),
    }
    print(json.dumps(payload), flush=True)


def socket_path():
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    if not sig:
        return None
    return os.path.join(runtime, "hypr", sig, ".socket2.sock")


def main():
    target_output = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] else None

    # Estado inicial.
    emit(target_output)

    sp = socket_path()
    if not sp or not os.path.exists(sp):
        # Sin socket de eventos no hay actualización automática: salimos
        # y dejamos que Waybar reinicie el script (restart-interval).
        return

    # Eventos que implican un posible cambio de workspace activo.
    triggers = (
        "workspace>>",
        "workspacev2>>",
        "focusedmon>>",
        "focusedmonv2>>",
        "moveworkspace>>",
        "moveworkspacev2>>",
        "createworkspace>>",
        "createworkspacev2>>",
        "destroyworkspace>>",
        "destroyworkspacev2>>",
        "activespecial>>",
    )

    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(sp)
    except OSError:
        return

    buf = b""
    with s:
        while True:
            try:
                data = s.recv(4096)
            except OSError:
                break
            if not data:
                break
            buf += data
            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                ev = line.decode("utf-8", "replace")
                if any(ev.startswith(t) for t in triggers):
                    emit(target_output)


if __name__ == "__main__":
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        # El consumidor (Waybar o un pipe de prueba) cerró la salida.
        try:
            sys.stdout.close()
        except Exception:
            pass

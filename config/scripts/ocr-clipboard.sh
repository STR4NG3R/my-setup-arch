#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# ocr-clipboard.sh
# Selecciona un área de la pantalla, extrae su texto con OCR
# (Tesseract, spa+eng) y lo copia al portapapeles de Wayland.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

# Idiomas de OCR (ajusta si lo necesitas: "spa", "eng", "spa+eng", ...)
OCR_LANG="${OCR_LANG:-spa+eng}"

# Imagen temporal segura
TMP_IMG="$(mktemp /tmp/ocr_screen_XXXXXX.png)"

# Limpieza garantizada al salir (éxito, error o interrupción)
cleanup() { rm -f "$TMP_IMG"; }
trap cleanup EXIT

# 0. Verificar dependencias
for dep in grim slurp tesseract wl-copy notify-send; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        notify-send "OCR" "Falta la dependencia: $dep" -u critical -t 3000
        exit 1
    fi
done

# 1. Seleccionar el área. Si el usuario cancela slurp (Esc), salimos sin ruido.
GEOM="$(slurp 2>/dev/null)" || exit 0
[ -z "$GEOM" ] && exit 0

# 2. Capturar solo la zona seleccionada
if ! grim -g "$GEOM" "$TMP_IMG"; then
    notify-send "OCR Fallido" "No se pudo tomar la captura" -u normal -t 2500
    exit 1
fi

# 3. Ejecutar OCR
OCR_TEXT="$(tesseract "$TMP_IMG" stdout -l "$OCR_LANG" --psm 6 2>/dev/null || true)"

# Eliminar líneas vacías al inicio/final
OCR_TEXT="$(printf '%s' "$OCR_TEXT" | sed '/^[[:space:]]*$/d')"

# 4. Verificar que se extrajo texto
if [ -z "$OCR_TEXT" ]; then
    notify-send "OCR Fallido" "No se detectó texto en la selección" -u normal -t 2500
    exit 1
fi

# 5. Copiar al portapapeles
printf '%s' "$OCR_TEXT" | wl-copy

# 6. Notificación con vista previa
PREVIEW="$(printf '%s' "$OCR_TEXT" | head -c 80)"
notify-send "📋 Texto copiado al portapapeles" "${PREVIEW}…" -u low -t 2000

starship init fish | source

# Integración de fzf (búsqueda difusa estilo fuzzel en la terminal):
#   Ctrl+R  -> historial de comandos
#   Ctrl+T  -> buscar archivos/directorios
#   Alt+C   -> cd a un directorio
if type -q fzf
    fzf --fish | source
end

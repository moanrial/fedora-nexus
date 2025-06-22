# Corrigir e adicionar localização ao Gnome-Weather

localizacao_fix() {
log_section "A adicionar localização ao Gnome-Weather."

if ! confirmar; then
info "Cancelado pelo utilizador."
return
fi

TMP_DIR=/tmp/fedora-nexus/fedora-nexus-main
SCRIPT="$TMP_DIR/add-location-to-gnome-weather.sh"

if [[ ! -f "$SCRIPT" ]]; then
erro "Script $SCRIPT não encontrado."
return 1
fi

chmod +x "$SCRIPT"
"$SCRIPT"

if [[ $? -ne 0 ]]; then
erro "Ocorreu um erro ao adicionar a localização ao Gnome-Weather."
return 1
fi

sucesso "Localização adicionada com sucesso."
sleep 1.5
}

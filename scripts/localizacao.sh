# Corrigir e adicionar localização ao Gnome-Weather

localizacao_fix() {
log_section "A adicionar localização ao Gnome-Weather."

if ! confirmar; then
info "Cancelado pelo utilizador."
return
fi

chmod +x ./.tmp/add-location-to-gnome-weather.sh
./.tmp/add-location-to-gnome-weather.sh

sucesso "Localização adicionada com sucesso."

sleep 1.5
}

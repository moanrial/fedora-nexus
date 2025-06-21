# Corrigir e adicionar localização ao Gnome-Weather

function localizacao_fix() {
clear
log_section "A adicionar localização ao Gnome-Weather."
chmod +x ./tmp/add-location-to-gnome-weather.sh
./tmp/add-location-to-gnome-weather.sh
suceso "Finalizado."
sleep 1.5
clear
}

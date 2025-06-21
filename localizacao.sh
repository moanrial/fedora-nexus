# Corrigir e adicionar localização ao Gnome-Weather

function localizacao_fix() {
clear
log_section "A adicionar localização ao Gnome-Weather."
chmod +x ./tmp/gnome-weather-fix.sh
./tmp/gnome-weather-fix.sh
echo "${green}Finalizado${reset} ✅"
sleep 1.5
clear
}

# Para corrigir e adicionar localização

function localizacao_fix() {
clear
log_section "A ADICIONAR LOCALIZAÇÃO AO GNOME-WEATHER"
wget -q -O ./tmp/gnome-weather-fix.sh "https://gist.github.com/dotbanana/1dc4d95d644ce72ab8741d6886b86acc/raw/9e12907ef036193fef4176c4ea0f396fa3f57321/add-location-to-gnome-weather.sh"
chmod +x ./tmp/gnome-weather-fix.sh
./tmp/gnome-weather-fix.sh
rm -r "$TMP_DIR"
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
}

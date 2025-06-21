# para corrigir e adicionar localização ao gnome-weather

function localizacao_fix() {
clear
log_section "a adicionar localização ao gnome-weather"
wget -q -o ./tmp/gnome-weather-fix.sh "https://gist.github.com/dotbanana/1dc4d95d644ce72ab8741d6886b86acc/raw/9e12907ef036193fef4176c4ea0f396fa3f57321/add-location-to-gnome-weather.sh"
chmod +x ./tmp/gnome-weather-fix.sh
./tmp/gnome-weather-fix.sh
echo "${green}finalizado${reset} ✅"
sleep 1.5
clear
}

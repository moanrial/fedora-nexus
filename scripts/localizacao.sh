#!/bin/bash
# Adiciona localização ao GNOME Weather (modo sistema ou Flatpak)

localizacao_fix() {
log_section "Adicionar localização ao Gnome-Weather."

if ! confirmar; then
info "Cancelado pelo utilizador."
return
fi

# Verifica se GNOME Weather está instalado
system=""
flatpak_app=""

if command -v gnome-weather >/dev/null 2>&1; then
system=1
fi

if flatpak list | grep -q org.gnome.Weather; then
flatpak_app=1
fi

if [[ -z "$system" && -z "$flatpak_app" ]]; then
echo "GNOME Weather não está instalado (nem como app nem como Flatpak)."
exit 1
fi

# Pergunta o nome da cidade se não foi passado
if [[ -n "$*" ]]; then
query="$*"
else
read -rp "Introduza o nome do local que pretende adicionar: " query
fi

query_encoded=$(echo "$query" | sed 's/ /+/g')
response=$(curl -s "https://nominatim.openstreetmap.org/search?q=$query_encoded&format=json&limit=1")

# Verifica se encontrou algo
if [[ "$response" == "[]" || -z "$response" ]]; then
echo "Nenhum local encontrado. Tente ser mais específico."
exit 1
fi

# Extrai campos com sed
display_name=$(echo "$response" | sed -n 's/.*"display_name":"\([^"]*\)".*/\1/p')
lat=$(echo "$response" | sed -n 's/.*"lat":"\([^"]*\)".*/\1/p')
lon=$(echo "$response" | sed -n 's/.*"lon":"\([^"]*\)".*/\1/p')

# Confirmação
echo "Local encontrado: $display_name"
read -rp "Deseja adicionar esta localização ao GNOME Weather? [y/n]: " confirm
if [[ "$confirm" != "y" ]]; then
echo "Operação cancelada."
exit 0
fi

# Converte coordenadas para radianos
lat_rad=$(echo "scale=10; $lat * (3.141592654 / 180)" | bc -l)
lon_rad=$(echo "scale=10; $lon * (3.141592654 / 180)" | bc -l)

# Cria nova entrada
location="<(uint32 2, <('$display_name', '', false, [($lat_rad, $lon_rad)], @a(dd) [])>)>"

# Obtém as localizações atuais
if [[ "$system" == "1" ]]; then
current=$(gsettings get org.gnome.Weather locations)
elif [[ "$flatpak_app" == "1" ]]; then
current=$(flatpak run --command=gsettings org.gnome.Weather get org.gnome.Weather locations)
fi

# Remove brackets se já houver locais
if [[ "$current" != "@av []" ]]; then
current_trimmed=$(echo "$current" | sed 's/^\[\(.*\)\]$/\1/')
new_locations="[$current_trimmed, $location]"
else
new_locations="[$location]"
fi

# Aplica as novas localizações
if [[ "$system" == "1" ]]; then
gsettings set org.gnome.Weather locations "$new_locations"
elif [[ "$flatpak_app" == "1" ]]; then
flatpak run --command=gsettings org.gnome.Weather set org.gnome.Weather locations "$new_locations"
fi

echo "Localização adicionada com sucesso!"

}

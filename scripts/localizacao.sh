#!/bin/bash
# Corrigir e adicionar localização ao Gnome-Weather

flatpak=0
system=0

localizacao_fix() {
log_section "Adicionar localização ao Gnome-Weather."

if ! confirmar; then
info "Cancelado pelo utilizador."
return
fi

# Verifica se o GNOME Weather está instalado (sistema)
if command -v gnome-weather >/dev/null 2>&1; then
system=1
fi

# Verifica se o GNOME Weather está instalado via Flatpak
if flatpak list | grep -q org.gnome.Weather; then
flatpak=1
fi

# Se não houver nenhuma instalação detectada, sai
if [[ "$system" != "1" && "$flatpak" != "1" ]]; then
echo "GNOME Weather não está instalado (nem como Flatpak nem como app do sistema)."
exit 1
fi

# Se foi passado argumento, usa como query. Senão, solicita ao usuário.
if [[ -n "$*" ]]; then
query="$*"
else
read -rp "Introduza o nome do local que pretende adicionar ao GNOME Weather: " query
fi

# Substitui espaços por "+" para URL encoding
query="$(echo "$query" | sed 's/ /+/g')"

# Faz a requisição à API do Nominatim
request=$(curl -s "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1")

# Verifica se a resposta está vazia
if [[ "$request" == "[]" || -z "$request" ]]; then
echo "Nenhum local encontrado. Considere tentar com menos termos de pesquisa."
exit 1
fi

# Extrai nome, latitude e longitude com sed
display_name=$(echo "$request" | sed -n 's/.*"display_name":"\([^"]*\)".*/\1/p')
lat=$(echo "$request" | sed -n 's/.*"lat":"\([^"]*\)".*/\1/p')
lon=$(echo "$request" | sed -n 's/.*"lon":"\([^"]*\)".*/\1/p')

# Confirma com o usuário
echo "Local encontrado: $display_name"
read -rp "Deseja adicionar esta localização ao GNOME Weather? [y/n]: " answer
if [[ "$answer" != "y" ]]; then
echo "Localização não adicionada."
exit 0
fi

# Converte latitude e longitude para radianos
lat_rad=$(echo "scale=10; $lat * (3.141592654 / 180)" | bc -l)
lon_rad=$(echo "scale=10; $lon * (3.141592654 / 180)" | bc -l)

# Busca localizações existentes
if [[ "$system" == "1" ]]; then
locations=$(gsettings get org.gnome.Weather locations)
fi

if [[ "$flatpak" == "1" ]]; then
locations=$(flatpak run --command=gsettings org.gnome.Weather get org.gnome.Weather locations)
fi

# Prepara nova entrada de localização
# Atenção: este formato depende da versão do GNOME e pode não funcionar se a estrutura mudar
location="#<('$(echo "$display_name" | sed "s/'/\\\'/g")', '', false, [($lat_rad, $lon_rad)], @a(dd) [])>"

# Adiciona à lista de locais
if [[ "$system" == "1" ]]; then
if [[ "$locations" != "@av []" ]]; then
new_locations=$(echo "$locations" | sed "s|]$|, $location]|")
else
new_locations="[$location]"
fi
gsettings set org.gnome.Weather locations "$new_locations"
fi

if [[ "$flatpak" == "1" ]]; then
if [[ "$locations" != "@av []" ]]; then
new_locations=$(echo "$locations" | sed "s|]$|, $location]|")
else
new_locations="[$location]"
fi
flatpak run --command=gsettings org.gnome.Weather set org.gnome.Weather locations "$new_locations"
fi

echo "Localização adicionada com sucesso ao GNOME Weather."

}

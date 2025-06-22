# instalar_flatpaks.sh - Instalação de aplicações via Flatpak

function instalar_flatpaks() {
log_section "Instalação de aplicações Flatpak"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

# Ativar repositório flathub, se necessário
if ! flatpak remote-list | grep -q flathub; then
info "A adicionar repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

flatpaks=(
com.discordapp.Discord
com.dropbox.Client
com.github.IsmaelMartinez.teams_for_linux
com.github.Matoking.protontricks
io.github.Foldex.AdwSteamGtk
io.github.limo_app.limo
io.github.loot.loot
org.ferdium.Ferdium
com.github.tchx84.Flatseal
)

for app in "${flatpaks[@]}"; do
if ! flatpak info "$app" &> /dev/null; then
  info "A instalar Flatpak: $app"
  flatpak install -y flathub "$app"
else
  info "$app já está instalado."
fi
done

sucesso "Flatpaks instalados com sucesso."
sleep 1.5
}


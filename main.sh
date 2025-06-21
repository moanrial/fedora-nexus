# main.sh - funções main

function atualizar_sistema_e_remover_pacotes() {
clear
log_section "A atualizar sistema & remover pacotes não essenciais"
sudo dnf update -y && sudo dnf upgrade -y
pacotes=(
gnome-tour.x86_64
yelp.x86_64
)
for pacote in "${pacotes[@]}"; do
info "A remover: $pacote"
sudo dnf remove -y "$pacote"
info "$pacote removido!"
done
sucesso "Finalizado."
sleep 1.5
clear
}

function instalar_pacotes_do_utilizador() {
clear
log_section "A instalar pacotes principais do utilizador"
pacotes=(
amd-gpu-firmware.noarch
wine-common.noarch
winetricks.noarch
lutris.x86_64
thunderbird.x86_64
gnome-boxes.x86_64
deja-dup.x86_64
steam.i686
steam-devices.noarch
vlc.x86_64
qbittorrent.x86_64
gimp.x86_64
gimp-help-pt.noarch
gnome-extensions-app.x86_64
gnome-feeds.noarch
gamemode.x86_64
firewalld.noarch
firewall-config.noarch
gnome-shell-extension-gsconnect.x86_64
gnome-shell-extension-appindicator.noarch
gnome-shell-extension-caffeine.noarch
gnome-shell-extension-dash-to-dock.noarch
gnome-shell-extension-gamemode.noarch
gnome-shell-extension-system-monitor.noarch
gnome-shell-extension-user-theme.noarch
seahorse.x86_64
gnome-tweaks.noarch
mangohud.x86_64
libreoffice.x86_64
libreoffice-help-pt-PT.x86_64
libreoffice-langpack-pt-PT.x86_64
fastfetch.x86_64
flatpak.x86_64
)
for pacote in "${pacotes[@]}"; do
if ! rpm -q "$pacote" > /dev/null 2>&1; then
info "A instalar: $pacote"
sudo dnf install -y "$pacote" --allowerasing
else
info "$pacote já está instalado!"
fi
done
sucesso "Finalizado."
sleep 1.5
clear
}

function instalar_flatpaks() {
clear
log_section "A instalar flatpaks principais do utilizador"
flatpaks=(
com.discordapp.Discord
com.dropbox.client
com.github.ismaelmartinez.teams_for_linux
com.github.matoking.protontricks
io.github.foldex.adwsteamgtk
io.github.limo_app.limo
io.github.loot.loot
org.ferdium.ferdium
com.github.tchx84.flatseal
)
for app in "${flatpaks[@]}"; do
if ! flatpak list | grep -q "$app"; then
info "A instalar: $app"
flatpak install -y flathub $app
else
info "$app Já está instalado."
fi
done
sucesso "Finalizado."
sleep 1.5
clear
}

function instalar_ficheiros_adicionais() {
clear
log_section "A instalar ficheiros adicionais externos (droidCam, autenticação-gov)"

#instalar droidcam
sudo dnf install -y ./tmp/droidcam.client.setup.rpm
sudo dnf install -y "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -e %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -e %fedora).noarch.rpm"
sudo dnf install -y kernel-headers v4l2loopback
#instalar autenticação-gov & plugin-autenticação.gov
sudo flatpak install -y --noninteractive ./tmp/pteid-mw-pcsclite-2.3.flatpak 2>/dev/null || true
sudo dnf install -y ./tmp/plugin-autenticacao-gov_fedora.rpm
sucesso "Finalizado."
sleep 1.5
clear
}




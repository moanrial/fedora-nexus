# main.sh - Funções auxiliares

function atualizar_sistema_e_remover_pacotes() {
clear
log_section "A ATUALIZAR SISTEMA & REMOVER PACOTES NÃO ESSENCIAIS"
sudo dnf update -y && sudo dnf upgrade -y
PACOTES=(
gnome-tour.x86_64
yelp.x86_64
)
for pacote in "${PACOTES[@]}"; do
echo -e "${RED}A REMOVER:${RESET} ${YELLOW}$pacote${RESET}"
sudo dnf remove -y "$pacote"
echo -e "${YELLOW}$pacote${RESET} ${RED}REMOVIDO${RESET}"
done
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
}

function instalar_pacotes_do_utilizador() {
clear
log_section "A INSTALAR PACOTES PRINCIPAIS DO UTILIZADOR"
PACOTES=(
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
for pacote in "${PACOTES[@]}"; do
if ! rpm -q "$pacote" > /dev/null 2>&1; then
echo -e "${YELLOW}A INSTALAR: $pacote${RESET}"
sudo dnf install -y "$pacote" --allowerasing
else
echo -e "${YELLOW}$pacote${RESET} ${GREEN}JÁ ESTÁ INSTALADO${RESET}"
fi
done
echo -e "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
}

function instalar_flatpaks() {
clear
log_section "A INSTALAR FLATPAKS PRINCIPAIS DO UTILIZADOR"
FLATPAKS=(
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
for app in "${FLATPAKS[@]}"; do
if ! flatpak list | grep -q "$app"; then
echo -e "${YELLOW}A INSTALAR: $app${RESET}"
flatpak install -y flathub $app
else
echo -e "${YELLOW}$app${RESET} ${GREEN}JÁ ESTÁ INSTALADO${RESET}"
fi
done
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
}

function instalar_ficheiros_adicionais() {
clear
log_section "A INSTALAR FICHEIROS ADICIONAIS EXTERNOS (DROIDCAM, AUTENTICAÇÃO-GOV)"

#INSTALAR DROIDCAM
sudo dnf install -y ./tmp/droidCam.client.setup.rpm
sudo dnf install -y "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y kernel-headers v4l2loopback
#INSTALAR AUTENTICAÇÃO-GOV & PLUGIN-AUTENTICAÇÃO.GOV
sudo flatpak install -y --noninteractive ./tmp/pteid-mw-pcsclite-2.3.flatpak 2>/dev/null || true
sudo dnf install -y ./tmp/plugin-autenticacao-gov_fedora.rpm
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
}


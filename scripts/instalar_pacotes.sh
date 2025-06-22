# instalar_pacotes.sh - Instalação de pacotes principais do utilizador

function instalar_pacotes() {
log_section "A instalar pacotes principais do utilizador"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

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
}


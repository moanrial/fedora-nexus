ficheiros_adicionais() {
log_section "A instalar ficheiros adicionais externos (droidCam, autenticação-gov, VS Code)"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

mkdir -p "$TMP_DIR"
mkdir -p "/lib/firmware/brcm"

# Transferência de ficheiros extra
info "A transferir ficheiros extra."

ficheiros=(
"https://droidcam.app/go/droidCam.client.setup.rpm"
"https://aplicacoes.autenticacao.gov.pt/apps/pteid-mw-pcsclite-2.3.flatpak"
"https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov_fedora.rpm"
"https://raw.githubusercontent.com/winterheart/broadcom-bt-firmware/refs/heads/master/brcm/BCM20702A1-0b05-17cb.hcd"
)

for url in "${ficheiros[@]}"; do
destino="$TMP_DIR/$(basename "$url")"

if [[ -f "$destino" ]]; then
    info "Já existe: $(basename "$url") — a ignorar transferência."
    continue
fi

loading "→ A transferir $(basename "$url")"

if ! wget -q -O "$destino" "$url"; then
    erro "Erro ao transferir $url"
    return 1
fi

sleep 0.5
done

sucesso "Ficheiros extra transferidos com sucesso."
sleep 1

# Instalar droidcam
info "A instalar DroidCam"
sudo dnf install -y "$TMP_DIR/droidCam.client.setup.rpm"

# RPM Fusion (caso não esteja já instalado)
info "A configurar repositórios RPM Fusion"
sudo dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Kernel headers e v4l2loopback
info "A instalar kernel headers e v4l2loopback"
sudo dnf install -y kernel-headers v4l2loopback

# Autenticação.gov (Flatpak + plugin RPM)
info "A instalar Autenticação.gov"
sudo flatpak install -y --noninteractive "$TMP_DIR/pteid-mw-pcsclite-2.3.flatpak" 2>/dev/null || true
sudo dnf install -y "$TMP_DIR/plugin-autenticacao-gov_fedora.rpm"

# Instalar Visual Studio Code
info "A instalar Visual Studio Code"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update || true
sudo dnf install -y code

# A instalar drivers bluetooth em falta.

sudo cp "$TMP_DIR/BCM20702A1-0b05-17cb.hcd" "/lib/firmware/brcm/"

sucesso "Ficheiros adicionais instalados com sucesso."
sleep 1.5
}
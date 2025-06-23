# ficheiros_adicionais.sh - Instalação de ficheiros externos adicionais (temas, fontes, etc.)

ficheiros_adicionais() {
log_section "A instalar ficheiros adicionais externos (droidCam, autenticação-gov)"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

mkdir -p "$TMP_DIR"

# Transferência de ficheiros extra
info "A transferir ficheiros extra."

ficheiros=(
"https://droidcam.app/go/droidCam.client.setup.rpm"
"https://aplicacoes.autenticacao.gov.pt/apps/pteid-mw-pcsclite-2.3.flatpak"
"https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov_fedora.rpm"
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
sleep 2
exit 1
fi

sleep 0.5
done

sucesso "Ficheiros extra transferidos com sucesso."
sleep 1.5

# Instalar droidcam
sudo dnf install -y "$TMP_DIR/droidCam.client.setup.rpm"

# RPM Fusion (caso não esteja já instalado)
sudo dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Kernel headers e v4l2loopback
sudo dnf install -y kernel-headers v4l2loopback

# Autenticação.gov (Flatpak + plugin RPM)
sudo flatpak install -y --noninteractive "$TMP_DIR/pteid-mw-pcsclite-2.3.flatpak" 2>/dev/null || true
sudo dnf install -y "$TMP_DIR/plugin-autenticacao-gov_fedora.rpm"


# Instalar VisualStudioCode

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update
sudo dnf install code

sucesso "Ficheiros adicionais instalados com sucesso."
sleep 1.5

}
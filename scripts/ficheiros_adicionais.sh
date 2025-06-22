# ficheiros_adicionais.sh - Instalação de ficheiros externos adicionais (temas, fontes, etc.)

ficheiros_adicionais() {
log_section "A instalar ficheiros adicionais externos (droidCam, autenticação-gov)"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

tmp_dir="./tmp"
mkdir -p "$tmp_dir"

# Transferência de ficheiros extra
info "A transferir ficheiros extra."

ficheiros=(
"https://droidcam.app/go/droidCam.client.setup.rpm"
"https://aplicacoes.autenticacao.gov.pt/apps/pteid-mw-pcsclite-2.3.flatpak"
"https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov_fedora.rpm"
"https://gist.github.com/dotbanana/1dc4d95d644ce72ab8741d6886b86acc/raw/9e12907ef036193fef4176c4ea0f396fa3f57321/add-location-to-gnome-weather.sh"
)

for url in "${ficheiros[@]}"; do
destino="$tmp_dir/$(basename "$url")"

if [[ -f "$destino" ]]; then
info "Já existe: $(basename "$url") — a ignorar transferência."
continue
fi

loading "→ A transferir $(basename "$url")"

if ! wget -q -O "$destino" "$url"; then
erro "Erro ao transferir $url"
sleep 2
rm -rf "$tmp_dir"
exit 1
fi

sleep 0.5
done

sucesso "Ficheiros extra transferidos com sucesso."
sleep 1.5

# Instalar droidcam
sudo dnf install -y "$tmp_dir/droidCam.client.setup.rpm"

# RPM Fusion (caso não esteja já instalado)
sudo dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Kernel headers e v4l2loopback
sudo dnf install -y kernel-headers v4l2loopback

# Autenticação.gov (Flatpak + plugin RPM)
sudo flatpak install -y --noninteractive "$tmp_dir/pteid-mw-pcsclite-2.3.flatpak" 2>/dev/null || true
sudo dnf install -y "$tmp_dir/plugin-autenticacao-gov_fedora.rpm"

sucesso "Ficheiros adicionais instalados com sucesso."
sleep 1.5
}


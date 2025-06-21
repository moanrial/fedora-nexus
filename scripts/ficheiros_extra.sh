# Transferencia de ficheiros extra.

function transferencia_ficheiros_extra() {
# transferência do droidcam & autenticacao-gov
info "A transferir ficheiros extra."

ficheiros=(
"https://droidcam.app/go/droidCam.client.setup.rpm"
"https://aplicacoes.autenticacao.gov.pt/apps/pteid-mw-pcsclite-2.3.flatpak"
"https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov_fedora.rpm"
"https://gist.github.com/dotbanana/1dc4d95d644ce72ab8741d6886b86acc/raw/9e12907ef036193fef4176c4ea0f396fa3f57321/add-location-to-gnome-weather.sh"
)

for url in "${ficheiros[@]}"; do
destino="$tmp_dir/$(basename "$url")"
loading "→ A transferir $(basename "$url")"

if ! wget -q -O "$destino" "$url"; then
erro "Erro ao transferir $url"
sleep 2
rm -r "$tmp_dir"
exit 1
fi

sleep 0.5
done

sucesso "Ficheiros extra transferidos com sucesso."
sleep 1.5
}

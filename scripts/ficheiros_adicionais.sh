# ficheiros_adicionais.sh - Instalação de ficheiros externos adicionais (temas, fontes, etc.)

function ficheiros_adicionais() {
log_section "Instalação de ficheiros externos adicionais"

if ! confirmar; then
info "Instalação cancelada pelo utilizador."
return
fi

tmp_dir="/tmp/fedora-installer"
mkdir -p "$tmp_dir"

# Exemplo: Instalar fontes adicionais
fontes_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
destino_fonts="$HOME/.local/share/fonts"

info "A instalar fontes Nerd Fonts (FiraCode)..."
mkdir -p "$destino_fonts"
curl -L "$fontes_url" -o "$tmp_dir/FiraCode.zip"
unzip -o "$tmp_dir/FiraCode.zip" -d "$destino_fonts"
fc-cache -f

# Exemplo: Tema GTK ou ícones
# tema_url="https://example.com/tema.tar.xz"
# icons_url="https://example.com/icons.tar.xz"
# mkdir -p ~/.themes ~/.icons
# curl -L "$tema_url" | tar -xJ -C ~/.themes
# curl -L "$icons_url" | tar -xJ -C ~/.icons

sucesso "Ficheiros adicionais instalados com sucesso."
sleep 1.5
}


# Limpeza dos logs e da pasta temporária.

limpeza_final() {
log_section "Limpar os ficheiros não necessários da instalação."

if ! confirmar; then
info "Limpeza cancelada pelo utilizador."
return
fi

TMP_DIR="/tmp/fedora-nexus"

# Verifica se existe a pasta ./.tmp e remove
if [ -d "$TMP_DIR" ]; then
info "[INFO] Limpeza de ficheiros temporários..."
rm -rf "$TMP_DIR"
fi

sucesso "Finalizado."
sleep 2
}

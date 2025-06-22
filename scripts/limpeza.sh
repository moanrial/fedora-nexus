# Limpeza dos logs e da pasta temporária.

limpeza_final() {
log_section "Limpar os ficheiros não necessários da instalação."

if ! confirmar; then
info "Limpeza cancelada pelo utilizador."
return
fi

TMP_DIR="/tmp/fedora-nexus/fedora-nexus-main"
LOG_DIR="/tmp/fedora-nexus/fedora-nexus-main/logs"

if [[ "${apagar_log_automaticamente:-false}" == true ]]; then
rm -rf "$log_dir"
else
read -p "Deseja apagar o log de instalação? [s/N] " resposta
[[ "$resposta" =~ ^[sS]$ ]] && rm -rf "$log_dir"
fi

# Verifica se existe a pasta ./.tmp e remove
if [ -d "$TMP_DIR" ]; then
info "A remover pasta temporária."
rm -r "$TMP_DIR"
fi

sucesso "Finalizado."
sleep 1.5

}

# Limpeza dos logs e da pasta temporária.

limpeza_final() {
log_section "Limpar os ficheiros não necessários da instalação."

if ! confirmar; then
info "Limpeza cancelada pelo utilizador."
return
fi

tmp_dir="./.tmp"

if [[ "${apagar_log_automaticamente:-false}" == true ]]; then
rm -f "$LOG_FILE"
else
read -p "Deseja apagar o log de instalação? [s/N] " resposta
[[ "$resposta" =~ ^[sS]$ ]] && rm -f "$LOG_FILE"
fi

# Verifica se existe a pasta ./.tmp e remove
if [ -d "$tmp_dir" ]; then
info "A remover pasta temporária."
rm -r "$tmp_dir"
fi

sucesso "Finalizado."
sleep 1.5

}

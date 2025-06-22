# atualizar_sistema.sh - Atualização do sistema e limpeza de pacotes antigos

function atualizar_sistema() {
log_section "Atualização e manutenção do sistema"

if ! confirmar; then
info "Atualização cancelada pelo utilizador."
return
fi

info "A atualizar o sistema..."
sudo dnf upgrade --refresh -y

info "A remover pacotes desnecessários..."
sudo dnf autoremove -y

sucesso "Sistema atualizado e limpo com sucesso."
sleep 1.5
}

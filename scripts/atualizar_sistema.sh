# atualizar_sistema.sh - Atualização do sistema e limpeza de pacotes antigos

atualizar_sistema() {
log_section "Atualização e manutenção do sistema."

if ! confirmar; then
info "Atualização cancelada pelo utilizador."
return
fi

info "A atualizar o sistema..."
sudo dnf upgrade --refresh -y

info "A remover pacotes desnecessários..."
sudo dnf autoremove -y

pacotes=(
gnome-tour.x86_64
yelp.x86_64
)

for pacote in "${pacotes[@]}"; do
if rpm -q "$pacote" > /dev/null 2>&1; then
info "A remover: $pacote"
sudo dnf remove -y "$pacote"
info "$pacote removido!"
else
info "$pacote já não está instalado."
fi
done

sucesso "Sistema atualizado e limpo com sucesso."
sleep 1.5
}

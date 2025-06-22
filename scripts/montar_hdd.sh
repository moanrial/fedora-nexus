# Montar HDD

montar_hdd() {
log_section "A montar disco de restauro"

if ! confirmar; then
info "Montagem cancelada pelo utilizador."
return
fi

mount_point="/mnt/Restauro"
uuid="$RESTORE_UUID"

# Cria o ponto de montagem, se não existir!
if [ ! -d "$mount_point" ]; then
info "A criar ponto de montagem em $mount_point..."
sudo mkdir -p "$mount_point"
sleep 1.5
sucesso "Finalizado."
fi
# Verifica se já está montado!
if ! mountpoint -q "$mount_point"; then
info "A montar o disco de restauro."
sudo mount -U "$uuid" "$mount_point"
sucesso "Disco montado com sucesso em $mount_point"
sucesso "Finalizado."
sleep 1.5
else
info "O disco de restauro já está montado em $mount_point."
sucesso "Finalizado."
sleep 1.5
fi
}

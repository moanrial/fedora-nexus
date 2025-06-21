# montar hdd

function montar_hdd() {
clear
log_section "A montar disco de restauro"
mount_point="/mnt/Restauro"
uuid="f794f76e-0e02-4c91-89ce-61feaccb35c7"
# Cria o ponto de montagem, se não existir!
if [ ! -d "$mount_point" ]; then
info "A criar ponto de montagem em $mount_point..."
sudo mkdir -p "$mount_point"
sleep 1.5
sucesso "Finalizado."
clear
fi
# Verifica se já está montado!
if ! mountpoint -q "$mount_point"; then
info "A montar o disco de restauro."
sudo mount -U "$uuid" "$mount_point"
sucesso "Disco montado com sucesso em $mount_point"
sucesso "Finalizado."
sleep 1.5
clear
else
info "O disco de restauro já está montado em $mount_point."
sucesso "Finalizado."
sleep 1.5
clear
fi
}

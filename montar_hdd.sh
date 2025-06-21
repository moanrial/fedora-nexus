# montar hdd

function montar_hdd() {
clear
log_section "a montar disco de restauro"
mount_point="/mnt/restauro"
uuid="f794f76e-0e02-4c91-89ce-61feaccb35c7"
# cria o ponto de montagem, se não existir
if [ ! -d "$mount_point" ]; then
echo "a criar ponto de montagem em $mount_point..."
sudo mkdir -p "$mount_point"
sleep 1.5
echo "${green}finalizado${reset} ✅"
clear
fi
# verifica se já está montado
if ! mountpoint -q "$mount_point"; then
echo "a montar o disco de restauro..."
sudo mount -u "$uuid" "$mount_point"
echo "disco montado com sucesso em $mount_point"
echo "${green}finalizado${reset} ✅"
sleep 1.5
clear
else
echo "o disco de restauro já está montado em $mount_point."
echo "${green}finalizado${reset} ✅"
sleep 1.5
clear
fi
}

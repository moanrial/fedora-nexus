# Montar HDD

function montar_hdd() {
clear
log_section "A MONTAR DISCO DE RESTAURO"
MOUNT_POINT="/mnt/Restauro"
UUID="f794f76e-0e02-4c91-89ce-61feaccb35c7"
# Cria o ponto de montagem, se não existir
if [ ! -d "$MOUNT_POINT" ]; then
echo "A CRIAR PONTO DE MONTAGEM EM $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"
sleep 1.5
echo "${GREEN}FINALIZADO${RESET} ✅"
clear
fi
# Verifica se já está montado
if ! mountpoint -q "$MOUNT_POINT"; then
echo "A MONTAR O DISCO DE RESTAURO..."
sudo mount -U "$UUID" "$MOUNT_POINT"
echo "DISCO MONTADO COM SUCESSO EM $MOUNT_POINT"
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
else
echo "O DISCO DE RESTAURO JÁ ESTÁ MONTADO EM $MOUNT_POINT."
echo "${GREEN}FINALIZADO${RESET} ✅"
sleep 1.5
clear
fi
}

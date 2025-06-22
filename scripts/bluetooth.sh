# Conectividade Bluetooth

configurar_bluetooth() {
log_section "A configurar o bluetooth para arrancar automaticamente."

if ! confirmar; then
info "Configuração cancelada pelo utilizador."
return
fi

# Verifica se bluetoothctl está disponível, senão instala bluez e blueman
if ! command -v bluetoothctl &>/dev/null; then
erro "Bluetoothctl não encontrado. A instalar bluez..."
sudo dnf install -y bluez blueman
fi

# =====================
DEVICE_NAME="MSX BT"

echo "A iniciar scan Bluetooth por '$DEVICE_NAME'..."

# Inicia o scan em segundo plano
bluetoothctl scan on &

# Espera um pouco para dar tempo ao scan
sleep 5

# Procura o MAC address pelo nome
bt_mac=$(bluetoothctl devices | grep "$DEVICE_NAME" | awk '{print $2}')

# Interrompe o scan
bluetoothctl scan off

if [ -z "$bt_mac" ]; then
    echo "Dispositivo '$DEVICE_NAME' não encontrado."
    return 1
fi

echo "Dispositivo encontrado: $bt_mac"

# Validação de formato MAC
if [[ ! "$bt_mac" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
erro "Formato de MAC inválido. Deve ser XX:XX:XX:XX:XX:XX"
return 1
fi

# Caminho para o script de conexão
bt_script="$HOME/.sh/conectar-colunas.sh"
mkdir -p "$HOME/.sh"


if [[ -f "$bt_script" ]]; then
info "Script de conexão bluetooth já existe. A substituir..."
fi

# Gerar o script
cat > "$bt_script" <<EOF
#!/bin/bash

device_mac="$bt_mac"

echo "A tentar conectar ao dispositivo bluetooth: \$device_mac"
bluetoothctl power on
bluetoothctl connect "\$device_mac"
bluetoothctl trust "\$device_mac"

echo "Dispositivo bluetooth conectado."
EOF

chmod +x "$bt_script"

# Criar entrada no autostart
autostart_dir="$HOME/.config/autostart"
autostart_file="$autostart_dir/conectar_colunas_bt.desktop"

mkdir -p "$autostart_dir"
cat > "$autostart_file" <<EOF
[Desktop Entry]
Type=application
Exec=$bt_script
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=ColunasBluetooth
EOF

sucesso "Script de conexão Bluetooth criado e configurado para arrancar automaticamente."
sleep 1.5
}

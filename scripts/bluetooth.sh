# Conectividade Bluetooth

configurar_bluetooth() {
log_section "A configurar o bluetooth para arrancar automaticamente."

# Verifica se bluetoothctl está disponível, senão instala bluez e blueman
if ! command -v bluetoothctl &>/dev/null; then
erro "Bluetoothctl não encontrado. A instalar bluez..."
sudo dnf install -y bluez blueman
fi

# Pedir o MAC address com validação simples
read -p "Insere o MAC das colunas bluetooth: " bt_mac # <- MAC das Colunas bluetooth

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
cat > "$bt_script" <<eof
#!/bin/bash

device_mac="$bt_mac"

echo "A tentar conectar ao dispositivo bluetooth: \$device_mac"
bluetoothctl power on
bluetoothctl connect "\$device_mac"
bluetoothctl trust "\$device_mac"

echo "Dispositivo bluetooth conectado."
eof

chmod +x "$bt_script"

# Criar entrada no autostart
autostart_dir="$HOME/.config/autostart"
autostart_file="$autostart_dir/conectar_colunas_bt.desktop"

mkdir -p "$autostart_dir"
cat > "$autostart_file" <<eof
[desktop entry]
type=application
exec=$bt_script
hidden=false
nodisplay=false
x-gnome-autostart-enabled=true
name=colunasbluetooth
eof

sucesso "Script de conexão Bluetooth criado e configurado para arrancar automaticamente."
sleep 1.5
}

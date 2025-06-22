# Conectividade Bluetooth

configurar_bluetooth() {
log_section "A configurar o bluetooth para arrancar automaticamente."

if ! confirmar; then
info "Configuração cancelada pelo utilizador."
return
fi

# Verifica se bluetoothctl está disponível
if ! command -v bluetoothctl &>/dev/null; then
erro "Bluetoothctl não encontrado. A instalar bluez..."
sudo dnf install -y bluez blueman
fi

device_mac="2A:53:8E:5B:54:A6"  # <<--- INSERIR AQUI O MAC

bt_script="$HOME/.sh/conectar-colunas.sh"
mkdir -p "$HOME/.sh"

# Criar ou substituir o script
cat > "$bt_script" <<EOF
#!/bin/bash

device_mac="$device_mac"

echo "A tentar conectar ao dispositivo bluetooth: \$device_mac"
bluetoothctl power on
bluetoothctl trust "\$device_mac"
bluetoothctl pair "\$device_mac"
bluetoothctl connect "\$device_mac"
EOF

chmod +x "$bt_script"

autostart_dir="\$HOME/.config/autostart"
autostart_file="\$autostart_dir/conectar_colunas_bt.desktop"
mkdir -p "\$autostart_dir"

cat > "\$autostart_file" <<EOF
[Desktop Entry]
Type=Application
Exec=$bt_script
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=ColunasBluetooth
EOF

sucesso "Conexão Bluetooth configurada para arrancar automaticamente."
}

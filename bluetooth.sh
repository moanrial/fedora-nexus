# Conectividade Bluetooth

function configurar_ligacao_bluetooth() {
clear
log_section "a configurar o bluetooth para arrancar automaticamente"
bt_mac="2a:53:8e:5b:54:a6"  # <- msx bt(colunasbluetooth)
bt_script="$HOME/.sh/conectar-colunas.sh"
# corrigir expansão correta da pasta
mkdir -p "$HOME/.sh"
# criar o script bluetooth
cat > "$bt_script" <<eof
#!/bin/bash

device_mac="$bt_mac"

echo "🔵 a tentar conectar ao dispositivo bluetooth: \$device_mac"
bluetoothctl power on
bluetoothctl connect "\$device_mac"
bluetoothctl trust "\$device_mac"

# tenta ativar perfil a2dp (ignorar se não necessário)
pactl set-card-profile bluez_card.\${device_mac//:/_} a2dp_sink

echo "✅ dispositivo bluetooth conectado (se emparelhado corretamente)"
eof

chmod +x "$bt_script"

# criar entrada .desktop para autostart
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

echo "script bluetooth configurado para iniciar automaticamente na sessão. ✅"
echo "${green}finalizado${reset} ✅"
sleep 1.5
clear
}

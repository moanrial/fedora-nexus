# Conectividade Bluetooth

configurar_bluetooth() {
log_section "A configurar o bluetooth para arrancar automaticamente."

# Verifica se bluetoothctl existe
if ! command -v bluetoothctl &> /dev/null; then
    echo "❌ O bluetoothctl não está instalado. Por favor, instala o pacote 'bluez'."
    exit 1
fi

# Verifica se pactl existe
if ! command -v pactl &> /dev/null; then
    echo "❌ O pactl (PulseAudio ou PipeWire) não está disponível. Verifica a tua instalação de áudio."
    exit 1
fi

# Pergunta o MAC Address do dispositivo
read -rp "👉 Introduz o MAC Address das colunas Bluetooth (ex: 00:1A:7D:DA:71:13): " BT_DEVICE

# Caminhos
SCRIPT_PATH="$HOME/connect_bt_speakers.sh"
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/connect_bt_speakers.desktop"

# Cria o script de conexão
cat > "$SCRIPT_PATH" <<EOF
#!/bin/bash

# Script gerado automaticamente para conectar colunas Bluetooth

BT_DEVICE="$BT_DEVICE"

# Espera um pouco após login
sleep 5

# Liga o adaptador Bluetooth (caso esteja desligado)
bluetoothctl power on

# Tenta conectar
bluetoothctl connect "\$BT_DEVICE"

# Define perfil de áudio
pactl set-card-profile bluez_card.\$(echo \$BT_DEVICE | sed 's/:/_/g') a2dp_sink
EOF

chmod +x "$SCRIPT_PATH"
echo "✅ Script de conexão criado em: $SCRIPT_PATH"

# Cria diretório autostart se não existir
mkdir -p "$AUTOSTART_DIR"

# Cria o ficheiro .desktop
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Exec=$SCRIPT_PATH
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conectar Colunas Bluetooth
Comment=Conecta automaticamente as colunas Bluetooth ao iniciar a sessão
EOF

echo "✅ Script de arranque criado em: $DESKTOP_FILE"

echo
echo "🎉 Instalação concluída! As colunas serão conectadas automaticamente ao iniciar a sessão."

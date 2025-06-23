# Conectividade Bluetooth

configurar_bluetooth() {
log_section "A configurar o bluetooth para arrancar automaticamente."

# Instalador automático para configurar conexão de colunas Bluetooth

# === CONFIGURAÇÃO FIXA ===
BT_DEVICE="2A:53:8E:5B:54:A6"

# === Caminhos ===
SCRIPT_PATH="$HOME/.sh/ConectarColunas.sh"
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/ConectarColunas.desktop"

echo "Iniciar instalação automática para MAC: $BT_DEVICE"

# Verifica se comandos necessários existem
for cmd in bluetoothctl pactl; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "O comando '$cmd' não está disponível. Por favor, instala-o antes de continuar."
        exit 1
    fi
done

# Cria o script de conexão
cat > "$SCRIPT_PATH" <<EOF
#!/bin/bash

# Script gerado automaticamente para conectar colunas Bluetooth

BT_DEVICE="$BT_DEVICE"

# Aguarda um pouco após o login
sleep 5

# Liga o adaptador Bluetooth
bluetoothctl power on

# Conecta ao dispositivo
bluetoothctl connect "\$BT_DEVICE"

# Define o perfil A2DP (áudio)
pactl set-card-profile bluez_card.\$(echo \$BT_DEVICE | sed 's/:/_/g') a2dp_sink
EOF

chmod +x "$SCRIPT_PATH"
echo "Script de conexão criado em: $SCRIPT_PATH"

# Cria diretório autostart se não existir
mkdir -p "$AUTOSTART_DIR"

# Cria ficheiro .desktop para arranque automático
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

echo "Autostart criado em: $DESKTOP_FILE"

echo
echo "Instalação completa! As colunas serão conectadas automaticamente ao iniciar sessão."

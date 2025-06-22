# Conectividade Bluetooth

configurar_bluetooth() {
  log_section "A configurar o bluetooth para arrancar automaticamente."

  if ! confirmar; then
    info "Configuração cancelada pelo utilizador."
    return
  fi

  if ! command -v bluetoothctl &>/dev/null; then
    erro "Bluetoothctl não encontrado. A instalar bluez..."
    sudo dnf install -y bluez blueman
  fi

  DEVICE_NAME="MSX BT"
  echo "A iniciar scan Bluetooth por '$DEVICE_NAME'..."

  # Começa o processo interativo do bluetoothctl
  {
    echo "power on"
    echo "scan on"
    sleep 1
  } | bluetoothctl &>/dev/null &

  # Espera até encontrar o dispositivo (até 15s)
  for i in {1..15}; do
    bt_mac=$(bluetoothctl devices | grep "$DEVICE_NAME" | awk '{print $2}')
    if [[ -n "$bt_mac" ]]; then
      echo "Dispositivo encontrado: $bt_mac"
      echo "scan off" | bluetoothctl
      break
    fi
    sleep 1
  done

  if [ -z "$bt_mac" ]; then
    erro "Dispositivo '$DEVICE_NAME' não encontrado."
    return 1
  fi

  bt_script="$HOME/.sh/conectar-colunas.sh"
  mkdir -p "$HOME/.sh"

  if [[ -f "$bt_script" ]]; then
    info "Script de conexão bluetooth já existe. A substituir..."
  fi

  cat > "$bt_script" <<EOF
#!/bin/bash

device_mac="$bt_mac"

echo "A tentar conectar ao dispositivo bluetooth: \$device_mac"
bluetoothctl power on
bluetoothctl trust "\$device_mac"
bluetoothctl connect "\$device_mac"

echo "Dispositivo bluetooth conectado."
EOF

  chmod +x "$bt_script"

  autostart_dir="$HOME/.config/autostart"
  autostart_file="$autostart_dir/conectar_colunas_bt.desktop"

  mkdir -p "$autostart_dir"
  cat > "$autostart_file" <<EOF
[Desktop Entry]
Type=Application
Exec=$bt_script
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=ColunasBluetooth
EOF

  sucesso "Script de conexão Bluetooth criado e configurado para arrancar automaticamente."
  sleep 1.5
}

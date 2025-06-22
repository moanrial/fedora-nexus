#!/bin/bash
# core.sh - lógica central

# Diretórios
script_dir="./scripts/"
tmp_dir="/tmp/fedora-installer"
log="./instalacao_$(date +%Y%m%d_%H%M%S).log"

# Importar utilitários
source "./utils.sh"

# Configurar ambiente
export LANG=pt_PT.UTF-8
export LC_ALL=pt_PT.UTF-8
set -euo pipefail

# Manter sudo ativo
manter_sudo_ativo() {
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$BASHPID" || exit; done 2>/dev/null &
trap 'kill $(jobs -p) 2>/dev/null || true' EXIT
}

# Verificar ligação à internet
verificar_ligacao() {
info "A verificar ligação à Internet..."
if ! ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
erro "Sem ligação à Internet."
exit 1
fi
}

# Verificar dependências
verificar_dependencias() {
local deps=(ping sudo curl tee)
for cmd in "${deps[@]}"; do
if ! command -v "$cmd" &> /dev/null; then
erro "Dependência em falta: $cmd"
exit 1
fi
done
}

# Iniciar logging
iniciar_logs() {
mkdir -p "$tmp_dir"
log_section "$1" | tee -a "$log"
}

# Transferir scripts auxiliares
transferir_auxiliares() {
base_url="https://raw.githubusercontent.com/moanrial/fedora-nexus/main/scripts"
ficheiros=(
atualizar_sistema.sh
bluetooth.sh
ficheiros_adicionais.sh
instalar_flatpaks.sh
instalar_pacotes.sh
limpeza.sh
localizacao.sh
menu.sh
montar_hdd.sh
)

mkdir -p scripts

for ficheiro in "${ficheiros[@]}"; do
destino="scripts/$ficheiro"

if [[ -f "$destino" ]]; then
echo "$ficheiro já existe. A saltar a transferência."
else
echo "A transferir $ficheiro..."
if curl -fsSL "$base_url/$ficheiro" -o "$destino"; then
echo "$ficheiro transferido com sucesso."
else
erro "Erro ao transferir $ficheiro"
exit 1
fi
fi
done
}

# Importar todos os scripts auxiliares
importar_scripts_auxiliares() {
for file in "$script_dir"/*.sh; do
source "$file"
done
}

# Ações finais
limpeza_final() {
sucesso "Instalação concluída."
rm -rf "$tmp_dir"
}

# Placeholder para ficheiros extra
ficheiros_extra() {
info "A verificar ficheiros extra..."
# Implementar se necessário
}

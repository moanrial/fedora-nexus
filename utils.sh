#!/usr/bin/env bash

# Confirmar
confirmar() {
local mensagem="${1:-Confirmar?}"
if [[ "$AUTO_MODE" == true ]]; then
info "$mensagem (AUTO: sim automático)"
return 0
fi
read -r -p "$mensagem (s/n): " resposta
[[ "$resposta" =~ ^[sS]$ ]]
}

# Cores
vermelho="\033[1;31m"
verde="\033[1;32m"
azul="\033[1;34m"
reset="\033[0m"

# Funções de output
info() { echo -e "${azul}[INFO]${reset} $1"; }
sucesso() { echo -e "${verde}[SUCESSO]${reset} $1"; }
erro() { echo -e "${vermelho}[ERRO]${reset} $1"; }
loading() { echo -n "$1"; for i in {1..3}; do echo -n "."; sleep 0.5; done; echo; }
log_section() { info "$1"; }

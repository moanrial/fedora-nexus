#!/bin/bash

# install.sh - Script principal

# Carrega funções essenciais e scripts auxiliares
source "./core.sh"
iniciar_logs "Inicio da Instalação"
transferir_auxiliares

# Importa scripts da pasta scripts/
for f in scripts/*.sh; do
source "$f"
done

# Execução automática com flag --silent ou --auto
if [[ "${1:-}" == "--silent" || "${1:-}" == "--auto" ]]; then
  manter_sudo_ativo &  # Garante sudo enquanto corre
  atualizar_sistema
  instalar_pacotes
  instalar_flatpaks
  instalar_ficheiros_adicionais
  info "Instalação completa."
else
  # Menu interativo
  executar_menu
fi

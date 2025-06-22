#!/bin/bash

# install.sh - Script principal

# Carrega funções essenciais e scripts auxiliares
source "./core.sh"
transferir_auxiliares

# Execução automática com flag --silent ou --auto
if [[ "${1:-}" == "--silent" || "${1:-}" == "--auto" ]]; then
  manter_sudo_ativo &  # Garante sudo enquanto corre
  atualizar_sistema
  instalar_pacotes_do_utilizador
  instalar_flatpaks
  instalar_ficheiros_adicionais
  info "Instalação completa."
else
  # Menu interativo
  executar_menu
fi

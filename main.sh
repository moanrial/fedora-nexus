#!/bin/bash

# main.sh

if [ "$INSTALLED_BY_INSTALL_SH" != "true" ]; then
    echo "Erro: Este script deve ser executado através do install.sh."
    exit 1
fi

# install.sh - Script de automatização pós-formatação para Fedora
# Este script instala pacotes, flatpaks, configura localização, monta discos, etc.

echo -e "\n Iniciando instalação...\n"

# Carrega funções essenciais e scripts auxiliares
source "./core.sh"
source "./utils.sh"

# Iniciar sudo imediatamente (apenas uma vez)
sudo -v
manter_sudo_ativo & 

iniciar_logs "Inicio da Instalação"
transferir_auxiliares

# Importa scripts da pasta scripts/
for f in scripts/*.sh; do
source "$f"
done

# Execução automática com flag --silent ou --auto
if [[ "${1:-}" == "--silent" || "${1:-}" == "--auto" ]]; then
export AUTO_MODE=true
export apagar_log_automaticamente=true
iniciar_logs "Modo automático"

atualizar_sistema
instalar_pacotes
instalar_flatpaks
ficheiros_adicionais
localizacao_fix
montar_hdd
configurar_bluetooth
limpeza_final

info "Instalação completa."
else
export AUTO_MODE=false
export apagar_log_automaticamente=false
iniciar_logs "Modo interativo"

# Menu interativo
executar_menu
fi

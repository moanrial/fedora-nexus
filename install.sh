#!/bin/bash
# install.sh - Script principal
echo -e "\n Iniciando instalação...\n"

# Diretório base dos scripts
repo_base="https://raw.githubusercontent.com/moanrial/fedora-nexus/main"

# Ficheiros base obrigatórios
ficheiros_base=(core.sh utils.sh)

for f in "${ficheiros_base[@]}"; do
if [[ ! -f "$f" ]]; then
echo "A transferir $f..."
curl -fsSL "$repo_base/$f" -o "$f" || {
echo "Erro ao transferir $f"
exit 1
}
fi
done

# Carrega funções essenciais e scripts auxiliares
source "./core.sh"

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
# Menu interativo
executar_menu
fi

#!/bin/bash
export LANG=pt_PT.UTF-8
set -e

# Variáveis globais
log="./instalador.log"
tmp_dir="./tmp"
script_dir="./scripts"
apagar_log_automaticamente=false

# Funções 
function log_section() {
local text="$1"
info "${text}"
}

# Sudo continuo
function manter_sudo_ativo() {
sudo -v
while true; do sleep 60; sudo -v; done &
sudo_keep_alive_pid=$!
trap '[ -n "$sudo_keep_alive_pid" ] && kill "$sudo_keep_alive_pid"' exit
clear
}

# Gerador de Logs
function iniciar_logs() {
local text="$1"
info "${text}"
exec > >(tee -a "$log") 2>&1
}

# Dependências satisfeitas
function verificar_dependencias() {
dependencias=("ping" "sudo" "curl" "tee")
for cmd in "${dependencias[@]}"; do
if ! command -v "$cmd" > /dev/null 2>&1; then
erro "Erro: o comando '$cmd' não está instalado."
sleep 2
exit 1
fi
done
sucesso "Todas as dependências estão satisfeitas."
}

### --- verificar conectividade --- ###
function verificar_ligacao() {
info "A verificar conectividade com a Internet."
if ! ping -c 1 1.1.1.1 > /dev/null 2>&1 && ! ping -c 1 google.com > /dev/null 2>&1; then
erro "Sem ligação à Internet ou DNS."
sleep 2
exit 1
fi
sucesso "Conectividade está OK."
}

# descarregar ficheiros auxiliares
function transferir_auxiliares() {
mkdir -p "$script_dir"
auxiliares=("main.sh" "localizacao.sh" "montar_hdd.sh" "bluetooth.sh" "limpeza.sh" "utils.sh")
base_url="https://raw.githubusercontent.com/moanrial/fedora-nexus/main/scripts"

for ficheiro in "${auxiliares[@]}"; do
destino="${script_dir}/${ficheiro}"
if [[ ! -f "$destino" ]]; then
loading "→ A transferir ${ficheiro} para ${script_dir}"
curl -fSsl "${base_url}/${ficheiro}" -o "$destino"
if [[ $? -ne 0 ]]; then
erro "Erro ao transferir ${ficheiro}."
sleep 2
exit 1
fi
fi
sleep 1.5
done
}

# Transferência de ficheiros extra.
function ficheiros_extra() {
# Transferência do droidCam & autenticacao-gov
info "A transferir ficheiros extra."

ficheiros=(
"https://droidcam.app/go/droidCam.client.setup.rpm"
"https://aplicacoes.autenticacao.gov.pt/apps/pteid-mw-pcsclite-2.3.flatpak"
"https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov_fedora.rpm"
"https://gist.github.com/dotbanana/1dc4d95d644ce72ab8741d6886b86acc/raw/9e12907ef036193fef4176c4ea0f396fa3f57321/add-location-to-gnome-weather.sh"
)

for url in "${ficheiros[@]}"; do
destino="$tmp_dir/$(basename "$url")"
loading "→ A transferir $(basename "$url")"

if ! wget -q -O "$destino" "$url"; then
erro "Erro ao transferir $url"
sleep 2
rm -r "$tmp_dir"
exit 1
fi

sleep 0.5
done

sucesso "Ficheiros extra transferidos com sucesso."
sleep 1.5
}

function executar_tudo() {
# executa todas as funções automaticamente.
atualizar_sistema_e_remover_pacotes
instalar_pacotes_do_utilizador
instalar_flatpaks
instalar_ficheiros_adicionais
localizacao_fix
montar_hdd
configurar_ligacao_bluetooth
limpeza_final
clear
}

### === menu interativo === ###
function mostrar_menu() {
clear
echo "========= MENU DE INSTALAÇÃO PARA FEDORA-NEXUS ==========="
echo ""
echo " (1) Atualizar/remover pacotes"
echo " (2) Instalar pacotes do utilizador"
echo " (3) Instalar flatpaks do utilizador"
echo " (4) Instalar ficheiros adicionais"
echo " (5) Gnome-Weather-Fix"
echo " (6) Montar disco de restauro"
echo " (7) Configurar bluetooth"
echo " (8) Limpeza de pastas e logs"
echo " (9) Executar tudo"
echo " (0) Sair"
echo ""
echo "=========================================================="
}

function executar_opcao() {
case "$1" in
(1) atualizar_sistema_e_remover_pacotes ;;
(2) instalar_pacotes_do_utilizador ;;
(3) instalar_flatpaks ;;
(4) instalar_ficheiros_adicionais ;;
(5) localizacao_fix ;;
(6) montar_hdd ;;
(7) configurar_ligacao_bluetooth ;;
(8) limpeza_final ;;
(9) executar_tudo ;;
(0) echo "A sair..."; apagar_log_automaticamente=true; limpeza_final; exit 0 ;;
(*) erro "Opção inválida!" 
sleep 1
clear
;;
esac
}

### === execução === ###
# Garantir que scripts são transferidos antes de usar funções
transferir_auxiliares

# Importar utils.sh primeiro
utils="${script_dir}/utils.sh"
if [[ -f "$utils" ]]; then
source "$utils"
else
echo "[ERRO] utils.sh não encontrado."
exit 1
fi

# Agora já podes usar funções como info, log_section, etc.
log_section "Credenciais necessárias!"
manter_sudo_ativo
verificar_dependencias
verificar_ligacao
iniciar_logs
transferir_auxiliares
ficheiros_extra

# importar e verificar os ficheiros descarregados

for file in main.sh localizacao.sh montar_hdd.sh bluetooth.sh limpeza.sh; do
path="${script_dir}/${file}"
if [[ -f "$path" ]]; then
source "$path"
else
erro "Ficheiro não encontrado: $file"
exit 1
fi
done

while true; do
mostrar_menu
read -rp "ESCOLHE UMA OPÇÃO: " opcao
executar_opcao "$opcao"
done

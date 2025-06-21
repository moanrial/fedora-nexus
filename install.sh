#!/bin/bash
# linguagem pt-pt
export LANG=pt_PT.UTF-8
# debug
set -e
#set -xe

# Cores para mensagens
vermelho="\033[1;31m"
verde="\033[1;32m"
azul="\033[1;34m"
reset="\033[0m"

loading() {
echo -n "$1"
for i in {1..3}; do
echo -n "."
sleep 0.5
done
echo
}

# Funções de output
info() { echo -e "${azul}[INFO]${reset} $1"; }
sucesso() { echo -e "${verde}[SUCESSO]${reset} $1"; }
erro() { echo -e "${vermelho}[ERRO]${reset} $1"; }

# Variáveis globais
log="./instalador.log"
tmp_dir="./tmp"
script_dir="./scripts"
apagar_log_automaticamente=false

### --- funções --- ###
function log_section() {
local text="$1"
info "${text}"
}

function manter_sudo_ativo() {
sudo -v
while true; do sleep 60; sudo -v; done &
sudo_keep_alive_pid=$!
trap '[ -n "$sudo_keep_alive_pid" ] && kill "$sudo_keep_alive_pid"' exit
clear
}

### --- Gerador de Log --- ###
function iniciar_logs() {
local text="$1"
info "${text}"
exec > >(tee -a "$log") 2>&1
mkdir -p "$script_dir"
}

# Dependências satisfeitas?
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
auxiliares=("main.sh" "localizacao.sh" "montar_hdd.sh" "bluetooth.sh" "ficheiros_extra.sh")
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


# Limpeza dos logs e da pasta temporária.
function limpeza_final() {
clear
log_section "A limpar os ficheiros não necessários da instalação."
if sudo dnf autoremove -y && sudo dnf clean all; then
if [ "$apagar_log_automaticamente" = true ]; then
rm -f "$log"
else
read -p "Deseja apagar o log de instalação? [s/N] " resposta
[[ "$resposta" =~ ^[sS]$ ]] && rm -f "$log"
fi
fi
# Verifica se existe a pasta ./tmp e remove
if [ -d "$tmp_dir" ]; then
info "A remover pasta temporária"
rm -r "$tmp_dir"
fi
sucesso "Finalizado."
sleep 1.5
clear
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
(4) ficheiros_extra ;;
(5) localizacao_fix ;;
(6) montar_hdd ;;
(7) configurar_ligacao_bluetooth ;;
(8) limpeza_final ;;
(9) executar_tudo ;;
(0) echo "A sair..."; apagar_log_automaticamente=true; limpeza_final; exit 0 ;;
(*) erro "Opção inválida!" 
sleep 1.5
clear
;;
esac
}

### === execução === ###
log_section "Credenciais necessárias!"
manter_sudo_ativo
verificar_dependencias
verificar_ligacao
iniciar_logs
transferir_auxiliares

# importar e verificar os ficheiros descarregados

for file in main.sh localizacao.sh montar_hdd.sh bluetooth.sh ficheiros_extra.sh; do
path="${script_dir}/${file}"
if [[ -f "$path" ]]; then
source "$path"
else
erro "Ficheiro não encontrado: $file"
exit 1
fi
done

ficheiros_extra

while true; do
mostrar_menu
read -rp "ESCOLHE UMA OPÇÃO: " opcao
executar_opcao "$opcao"
done

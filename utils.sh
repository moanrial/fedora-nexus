# utils.sh - Funções auxiliares reutilizáveis

### --- VERIFICAR CONECTIVIDADE --- ###
function verificar_ligacao() {
echo "${NEGRITO}${YELLOW}A VERIFICAR CONECTIVIDADE COM A INTERNET...${RESET}"
if ! ping -c 1 1.1.1.1 > /dev/null 2>&1 && ! ping -c 1 google.com > /dev/null 2>&1; then
echo "${NEGRITO}${RED}SEM LIGAÇÃO À INTERNET OU DNS.${RESET}"
sleep 1.5
clear
exit
fi
echo "${NEGRITO}${GREEN}CONECTIVIDADE ESTÁ OK.${RESET}"
sleep 1.5
clear
}

function manter_sudo_ativo() {
sudo -v
while true; do sleep 60; sudo -v; done &
SUDO_KEEP_ALIVE_PID=$!
trap '[ -n "$SUDO_KEEP_ALIVE_PID" ] && kill "$SUDO_KEEP_ALIVE_PID"' EXIT
clear
}

function verificar_dependencias() {
DEPENDENCIAS=("ping" "sudo" "curl" "tee")
for cmd in "${DEPENDENCIAS[@]}"; do
if ! command -v "$cmd" > /dev/null 2>&1; then
echo "${NEGRITO}${RED}ERRO: O COMANDO '$CMD' NÃO ESTÁ INSTALADO.${RESET}"
exit 1
fi
done
echo "${NEGRITO}${GREEN}TODAS AS DEPENDÊNCIAS ESTÃO SATISFEITAS.${RESET}"
}

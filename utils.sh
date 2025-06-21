# utils.sh - Funções auxiliares reutilizáveis

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

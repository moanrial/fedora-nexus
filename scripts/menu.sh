# menu.sh - Menu interativo para execução seletiva dos scripts

### === menu interativo === ###
mostrar_menu() {
clear
echo "========= MENU DE INSTALAÇÃO PARA FEDORA-NEXUS ==========="
echo ""
echo " (1) Atualizar e remover pacotes"
echo " (2) Instalar pacotes do utilizador"
echo " (3) Instalar flatpaks do utilizador"
echo " (4) Instalar ficheiros adicionais"
echo " (5) Gnome-Weather-Fix"
echo " (6) Montar disco de restauro"
echo " (7) Configurar bluetooth"
echo " (8) Limpeza de pastas e logs"
echo " (0) Sair"
echo ""
echo "=========================================================="
}

executar_opcao() {
case "$1" in
(1) atualizar_sistema ;;
(2) instalar_pacotes ;;
(3) instalar_flatpaks ;;
(4) ficheiros_adicionais ;;
(5) localizacao_fix ;;
(6) montar_hdd ;;
(7) configurar_bluetooth ;;
(8) limpeza_final ;;
(0) echo "A sair..."; sleep 1.5; clear; exit 0 ;;
(*) erro "Opção inválida!" 
;;
esac
}

executar_menu() {
while true; do
mostrar_menu
read -rp "ESCOLHE UMA OPÇÃO: " opcao
executar_opcao "$opcao"
done
}

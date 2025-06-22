# menu.sh - Menu interativo para execução seletiva dos scripts

### === menu interativo === ###
mostrar_menu() {
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

executar_opcao() {
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
;;
esac
}

executar_menu() {
while true; do
mostrar_menu
read -rp "ESCOLHE UMA OPÇÃO: " opcao
executar_opcao "$opcao"
done

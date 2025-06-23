#!/bin/bash

# install.sh
export INSTALLED_BY_INSTALL_SH=true
./main.sh

# Diretório temporário
TMP_DIR="/tmp/fedora-nexus"
ZIP_URL="https://github.com/moanrial/fedora-nexus/archive/refs/heads/main.zip"
DIR_EXTRAIDO="$TMP_DIR/fedora-nexus-main"

# Verificações
command -v curl >/dev/null 2>&1 || { echo "É necessário ter 'curl' instalado."; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "É necessário ter 'unzip' instalado."; exit 1; }

# Criar diretório
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# Descarregar o projeto
echo "[INFO] A descarregar os ficheiros..."
curl -L "$ZIP_URL" -o "$TMP_DIR/fedora-nexus.zip"

# Descompactar
unzip -q "$TMP_DIR/fedora-nexus.zip" -d "$TMP_DIR"

# Tornar scripts executáveis
chmod +x "$DIR_EXTRAIDO"/*.sh
chmod +x "$DIR_EXTRAIDO/scripts/"*.sh

# Entrar no diretório
cd "$DIR_EXTRAIDO" || { echo "Erro ao entrar no diretório extraído"; exit 1; }

# Menu de seleção
clear
echo "Escolha o modo de execução:"
echo "1) Modo interativo"
echo "2) Modo automático (--auto)"
read -rp "Opção [1-2]: " MODO

# Executar main.sh conforme escolha
if [[ "$MODO" == "2" ]]; then
echo "Executando o instalador em modo automático..."
./main.sh --auto
else
echo "Executando o instalador em modo interativo..."
./main.sh
fi
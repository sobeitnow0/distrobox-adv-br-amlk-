#!/bin/bash
# Script de Instalação do Lacuna Web PKI (Nativo)

# Variáveis
# URL fixa na versão 2.13.3 para garantir compatibilidade com o Checksum
URL_LACUNA="https://get.webpkiplugin.com/Downloads/2.13.3/setup-deb-64"
ARQUIVO_DEB="${HOME}/Downloads/setup-deb-64.deb"

# SHA256 exato da versão 2.13.3
CHECKSUM_LACUNA="8b43c49f07d720480afb90f35a2f159abe916c8ec161e9a64f301e9aebfe9949"

echo "Instalando dependências (wget)..."
sudo apt update && sudo apt install -y wget

echo "Baixando Lacuna Web PKI..."
# -O salva diretamente com o nome final
wget -O "${ARQUIVO_DEB}" "${URL_LACUNA}"

# Verificação de Checksum
echo "Verificando checksum do Lacuna Web PKI..."
if ! echo "${CHECKSUM_LACUNA}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO CRÍTICO: O arquivo baixado não confere com o Checksum esperado."
    echo "Isso pode significar um download corrompido ou um ataque de segurança."
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Lacuna Web PKI..."
# Instalação via apt resolve dependências automaticamente
sudo apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos de instalação..."
rm -f "${ARQUIVO_DEB}"

echo "Instalação do componente nativo Web PKI concluída."

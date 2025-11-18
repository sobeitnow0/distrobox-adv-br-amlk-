#!/bin/bash
# Script de Instalação do Softplan WebSigner (e-SAJ)

# Variáveis
# URL oficial da versão 2.12.1
URL_WEBSIGNER="https://websigner.softplan.com.br/Downloads/2.12.1/webpki-chrome-64-deb"
ARQUIVO_DEB="${HOME}/Downloads/websigner-setup.deb"

# SHA256 fornecido
CHECKSUM_WEBSIGNER="5da8fd36f1371f52bbaebede75fade1928f09cff2dd605b8da5663c6da505379"

echo "Instalando dependências..."
sudo apt update && sudo apt install -y wget

echo "Baixando Softplan WebSigner..."
# Baixa e já salva com o nome correto (.deb)
wget -O "${ARQUIVO_DEB}" "${URL_WEBSIGNER}"

# Verificação de Checksum
echo "Verificando integridade do arquivo..."
if ! echo "${CHECKSUM_WEBSIGNER}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO CRÍTICO: O Checksum do WebSigner falhou."
    echo "O arquivo pode estar corrompido."
    exit 1
fi
echo "Checksum validado com sucesso."

echo "Instalando Softplan WebSigner..."
# Instalação via apt para resolver dependências automaticamente
sudo apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos de instalação..."
rm -f "${ARQUIVO_DEB}"

echo "Instalação do Softplan WebSigner concluída."

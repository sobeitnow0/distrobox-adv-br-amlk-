#!/bin/bash
# Script de Instalação do SafeSign IC Standard (Versão compatível com OpenSSL 3/Debian Trixie)

# Variáveis
URL_SAFESIGN="https://assets.ctfassets.net/zuadwp3l2xby/2loCJpZkGMJe5y06gwzM4C/a065ab00cd0c42ca04de8870dce3de06/SafeSign_IC_Standard_Linux_ub2404_4.2.1.0-AET.000.zip"
ARQUIVO_ZIP="${HOME}/Downloads/SafeSign_IC_Standard.zip"
PASTA_TEMP="${HOME}/Downloads/safesign_temp"

# SHA256 do arquivo zip fornecido
CHECKSUM_SAFESIGN="3cf3e94ca8dddefe4e192c2a84a14cbdfd0789271d02d7d323da0b48ecdb8ac7"

# --- Pré-requisitos ---
echo "Instalando dependências necessárias (unzip, pcscd, libs)..."
# libccid e pcscd são essenciais para o token ser reconhecido
sudo apt update && sudo apt install -y unzip wget libccid pcscd libgdbm-compat4

echo "Baixando SafeSign IC Standard..."
# Usamos -O para salvar com um nome simples e evitar problemas de espaços
wget -O "${ARQUIVO_ZIP}" "${URL_SAFESIGN}"

# Verificação de Checksum
echo "Verificando checksum do SafeSign..."
if ! echo "${CHECKSUM_SAFESIGN}  ${ARQUIVO_ZIP}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeSign falhou! O arquivo pode ter sido alterado pelo fornecedor."
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Descompactando SafeSign..."
# Extraímos para uma pasta temporária para não espalhar arquivos no Downloads
mkdir -p "${PASTA_TEMP}"
unzip -o -q "${ARQUIVO_ZIP}" -d "${PASTA_TEMP}"

echo "Localizando o instalador .deb..."
# Encontra o arquivo .deb automaticamente, lidando com espaços e subpastas
ARQUIVO_DEB=$(find "${PASTA_TEMP}" -name "*.deb" | head -n 1)

if [ -z "${ARQUIVO_DEB}" ]; then
    echo "ERRO: Nenhum arquivo .deb encontrado dentro do ZIP."
    exit 1
fi

echo "Instalando SafeSign (${ARQUIVO_DEB})..."
sudo apt install -y "${ARQUIVO_DEB}"

# Correção de dependências quebradas (comum em distros Testing)
if [ $? -ne 0 ]; then
    echo "Tentando corrigir dependências..."
    sudo apt --fix-broken install -y
fi

echo "Limpando arquivos temporários..."
rm -rf "${ARQUIVO_ZIP}" "${PASTA_TEMP}"

echo "Instalação do SafeSign IC Standard concluída."

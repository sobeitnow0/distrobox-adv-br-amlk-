#!/bin/bash
# Script de Instalação do SafeNet Authentication Client (SAC) - Versão com Interface

# Variáveis
URL_SAFENET="https://www.digicert.com/StaticFiles/Linux_SAC_10.9_GA.zip"
ARQUIVO_ZIP="${HOME}/Downloads/Linux_SAC_10.9_GA.zip"
DIRETORIO_EXTRAIDO="${HOME}/Downloads/SAC_10.9_GA"

# ATENÇÃO: Mudamos para a pasta "Standard" para ter o tokenadmin (GUI)
# O caminho exato dentro do zip pode variar, mas geralmente segue este padrão para a versão 10.9
ARQUIVO_DEB="${DIRETORIO_EXTRAIDO}/Installation/Standard/Ubuntu-2204/safenetauthenticationclient_10.9.4723_amd64.deb"

# SHA256 do arquivo zip (Mantido o seu original)
CHECKSUM_SAFENET="46759cfe91d736af18a49d10e4749f264022db44e04ed4caf94e1ca77d6a013e"

# --- Pré-requisitos ---
echo "Instalando dependências necessárias (unzip)..."
sudo apt update && sudo apt install -y unzip wget libccid pcscd

echo "Baixando SafeNet Authentication Client..."
wget -c -P "${HOME}/Downloads" "${URL_SAFENET}"

# Verificação de Checksum
echo "Verificando checksum do SafeNet..."
if ! echo "${CHECKSUM_SAFENET}  ${ARQUIVO_ZIP}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeNet falhou! O arquivo pode estar corrompido ou foi atualizado pela Digicert."
    # Opcional: Se quiser que ele continue mesmo com checksum errado (arriscado), comente a linha abaixo
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Descompactando SafeNet..."
# -o overwrite, -q quiet, -d destination
unzip -o -q "${ARQUIVO_ZIP}" -d "${HOME}/Downloads"

echo "Verificando se o arquivo .deb existe no caminho esperado..."
if [ ! -f "${ARQUIVO_DEB}" ]; then
    echo "ERRO: O arquivo .deb não foi encontrado em: ${ARQUIVO_DEB}"
    echo "Conteúdo da pasta extraída:"
    ls -R "${DIRETORIO_EXTRAIDO}"
    exit 1
fi

echo "Instalando SafeNet (Versão Standard com GUI)..."
# Usamos 'apt install' no arquivo local para resolver dependências automaticamente
sudo apt install -y "${ARQUIVO_DEB}"

# Correção para possíveis dependências quebradas no Trixie
if [ $? -ne 0 ]; then
    echo "Houve um erro na instalação. Tentando corrigir dependências..."
    sudo apt --fix-broken install -y
fi

echo "Limpando arquivos temporários..."
rm -rf "${DIRETORIO_EXTRAIDO}" "${ARQUIVO_ZIP}"

echo "Instalação do SafeNet Authentication Client concluída."

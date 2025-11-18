#!/bin/bash

# --- Configuração das bibliotecas ---
# Caminhos ajustados para o padrão Debian e checagem de existência
if [ -f "/usr/lib/libaetpkss.so.3" ]; then
    CAMINHO_SAFESIGN="/usr/lib/libaetpkss.so.3"
else
    CAMINHO_SAFESIGN="/usr/lib/libaetpkss.so"
fi
NOME_SAFESIGN="SafeSign"

if [ -f "/usr/lib/libeToken.so.10" ]; then
    CAMINHO_SAFENET="/usr/lib/libeToken.so.10"
elif [ -f "/usr/lib/libeToken.so" ]; then
    CAMINHO_SAFENET="/usr/lib/libeToken.so"
else
    CAMINHO_SAFENET="/usr/lib/libeToken.so"
fi
NOME_SAFENET="SafeNet"

# --- Passo 1: Definir e Criar o Diretório do Perfil Manualmente ---
# Usamos um nome fixo para garantir consistência
PERFIL_NOME="default-esr"
PERFIL_PATH="distrobox.default-esr"
DIR_PERFIL="$HOME/.mozilla/firefox/$PERFIL_PATH"
ARQUIVO_INI="$HOME/.mozilla/firefox/profiles.ini"

echo "Criando estrutura de perfil do Firefox manualmente..."

# Cria a pasta do perfil
mkdir -p "$DIR_PERFIL"

# --- Passo 2: Inicializar o Banco de Dados NSS (Certificados) ---
# Isso cria os arquivos cert9.db e key4.db sem abrir o Firefox
if [ ! -f "$DIR_PERFIL/cert9.db" ]; then
    echo "Inicializando banco de dados de certificados..."
    # -N: Novo DB, --empty-password: sem senha mestra inicial
    certutil -N -d "sql:$DIR_PERFIL" --empty-password
else
    echo "Banco de dados já existe."
fi

# --- Passo 3: Criar o arquivo profiles.ini ---
# Isso faz o Firefox reconhecer a pasta que criamos como o perfil padrão
if [ ! -f "$ARQUIVO_INI" ]; then
    echo "Criando arquivo profiles.ini..."
    cat <<EOF > "$ARQUIVO_INI"
[Profile0]
Name=$PERFIL_NOME
Path=$PERFIL_PATH
IsRelative=1
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF
fi

echo "Perfil configurado em: $DIR_PERFIL"
echo "---"

# --- Passo 4: Adicionar as bibliotecas de segurança (Tokens) ---

# Função para adicionar token com verificação
adicionar_token() {
    local nome="$1"
    local lib="$2"
    
    if [ -f "$lib" ]; then
        echo "Adicionando a biblioteca $nome ($lib)..."
        # Verifica se já existe para não duplicar erro
        if modutil -list -dbdir "sql:$DIR_PERFIL" | grep -q "$nome"; then
             echo "Módulo $nome já está configurado."
        else
             # Tenta adicionar
             echo -e "\n" | modutil -add "$nome" -libfile "$lib" -dbdir "sql:$DIR_PERFIL"
             if [ $? -eq 0 ]; then
                 echo "$nome adicionado com sucesso."
             else
                 echo "Erro ao adicionar $nome."
             fi
        fi
    else
        echo "Aviso: Biblioteca para $nome não encontrada em $lib. Pulei esta etapa."
    fi
    echo "---"
}

adicionar_token "$NOME_SAFESIGN" "$CAMINHO_SAFESIGN"
adicionar_token "$NOME_SAFENET" "$CAMINHO_SAFENET"

echo "Operação de configuração de tokens concluída."

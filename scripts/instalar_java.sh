#!/bin/bash

# Script de Instalação do Java (OpenJDK 11) - Versão Estável Debian

echo "Atualizando lista de pacotes..."
sudo apt update

echo "Instalando OpenJDK 11 (Compatível com PJe/e-SAJ)..."
# Instala o Java 11 e as bibliotecas gráficas necessárias
sudo apt install -y openjdk-11-jdk openjdk-11-jre

# Configura o Java 11 como padrão (caso tenha outros instalados)
if command -v update-alternatives &> /dev/null; then
    echo "Configurando Java 11 como padrão..."
    # Tenta definir automaticamente para o caminho do Java 11
    sudo update-alternatives --set java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 2>/dev/null || sudo update-alternatives --auto java
fi

echo "Verificando versão instalada..."
java -version

echo "Instalação do Java concluída com sucesso."

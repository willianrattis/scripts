#!/bin/bash

get_project_path() {
    while true; do
        read -p "Digite o caminho do diretório do projeto: " project_path

        # Verificar se o diretório existe
        if [ -d "$project_path" ]; then
            # Verificar se existe algum arquivo .sln no diretório
            sln_file=$(find "$project_path" -maxdepth 1 -name "*.sln")
            if [ -n "$sln_file" ]; then
                echo "Arquivo .sln encontrado: $sln_file"
                break
            else
                echo "Nenhum arquivo .sln encontrado no diretório fornecido."
            fi
        else
            echo "Diretório não encontrado."
        fi
    done
    echo "Caminho do projeto confirmado: $project_path"
    echo ""
    return "$project_path"
}

# Chamar a função para obter o caminho do projeto
get_project_path
PROJECT_PATH="$project_path"

# Ler o tempo de espera em segundos
read -p "Informe o tempo de espera entre as compilações (em segundos): " sleep_time

while true
do
    echo "Building .NET application..."
    dotnet build "$PROJECT_PATH"
    echo "Build complete. Waiting for $sleep_time seconds before next build..."
    sleep "$sleep_time"
done
 
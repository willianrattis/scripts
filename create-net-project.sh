#!/bin/zsh

# Funções para formatação de nomes
format_short_company_name() {
  echo "$1" | tr -d ' ' | tr '[:upper:]' '[:lower:]'
}

format_full_company_name() {
  echo "$1" | awk '{ for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); } 1' | tr -d ' '
}

format_api_name_root() {
  echo "$1" | tr -d ' ' | tr '[:upper:]' '[:lower:]'
}

format_api_name() {
  echo "$1" | awk '{ for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); } 1' | tr -d ' '
}

# Coletar informações
read "project_directory?Digite o caminho do diretório do projeto: "
read "short_company_name?Digite o nome curto da empresa: "
read "full_company_name?Digite o nome completo da empresa: "
read "api_name?Digite o nome da API: "

# Formatar os nomes
project_directory=$(echo "$project_directory" | tr -d ' ')
short_company_name=$(format_short_company_name "$short_company_name")
full_company_name=$(format_full_company_name "$full_company_name")
api_name_root=$(format_api_name_root "$api_name")
api_name=$(format_api_name "$api_name")

# Mudar para o diretório do projeto
cd "$project_directory"

# Executar os comandos
mkdir "$short_company_name-backend-$api_name_root" && cd "$short_company_name-backend-$api_name_root"

git init && git branch -M main && dotnet new gitignore

dotnet new globaljson --sdk-version 6.0.408

# Criar projetos em src e adicionar referências
mkdir src && cd src
dotnet new webapi -o "$full_company_name.$api_name.Api"
dotnet new classlib -o "$full_company_name.$api_name.Corporate"
cd "$full_company_name.$api_name.Api" && dotnet add reference "../$full_company_name.$api_name.Corporate/"
cd ..
cd "$full_company_name.$api_name.Corporate" && dotnet add package Refit --source https://api.nuget.org/v3/index.json
cd ../..

# Criar projetos em tests e adicionar referências
mkdir tests && cd tests
dotnet new xunit -o "$full_company_name.$api_name.Api.UnitTests"
dotnet new xunit -o "$full_company_name.$api_name.Api.IntegrationTests"
cd "$full_company_name.$api_name.Api.IntegrationTests" && dotnet add reference "../../src/$full_company_name.$api_name.Api/" && dotnet add package WireMock.Net --source https://api.nuget.org/v3/index.json
cd ..
cd "$full_company_name.$api_name.Api.UnitTests" && dotnet add reference "../../src/$full_company_name.$api_name.Api/"
cd ../..

# Criar e atualizar a solução
dotnet new sln -n "$full_company_name.$api_name"
dotnet sln add "src/$full_company_name.$api_name.Api"
dotnet sln add "src/$full_company_name.$api_name.Corporate"
dotnet sln add "tests/$full_company_name.$api_name.Api.IntegrationTests"
dotnet sln add "tests/$full_company_name.$api_name.Api.UnitTests"

echo "Listing projects in the solution..."
dotnet sln list

echo "Restore(s) and Build(s)"
echo "----------"
dotnet restore &&
dotnet build

# Abrir o projeto no Visual Studio Code
code "$project_directory/$short_company_name-backend-$api_name_root"

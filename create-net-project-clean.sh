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

# Perguntar se é um projeto para teste
read "is_test_project?É um projeto para teste? (y/n): "
if [[ "$is_test_project" == "y" ]]; then
  project_directory="/Users/willianrattis/Development/Tests"
else
  read "project_directory?Digite o caminho do diretório do projeto: "
fi

# Coletar outras informações
read "short_company_name?Digite o nome curto da empresa: "
read "full_company_name?Digite o nome completo da empresa: "
read "api_name?Digite o nome da API: "

# Formatar os nomes
project_directory=$(echo "$project_directory" | tr -d ' ')
short_company_name=$(format_short_company_name "$short_company_name")
full_company_name=$(format_full_company_name "$full_company_name")
api_name_root=$(format_api_name_root "$api_name")
api_name=$(format_api_name "$api_name")

# Mudar para o diretório do projeto e criar a estrutura base
cd "$project_directory"
mkdir "$short_company_name-backend-$api_name_root" && cd "$short_company_name-backend-$api_name_root"
git init && git branch -M main && dotnet new gitignore
dotnet new globaljson --sdk-version 6.0.408

# Criação da pasta .vscode e arquivos de configuração
mkdir .vscode && cd .vscode

# Gerar launch.json
echo "{
    \"version\": \"0.2.0\",
    \"configurations\": [
        {
            \"name\": \".NET Core Launch (web)\",
            \"type\": \"coreclr\",
            \"request\": \"launch\",
            \"preLaunchTask\": \"build\",
            \"program\": \"\${workspaceFolder}/src/$full_company_name.$api_name.Api/bin/Debug/net6.0/$full_company_name.$api_name.Api.dll\",
            \"args\": [],
            \"cwd\": \"\${workspaceFolder}/src/$full_company_name.$api_name.Api\",
            \"stopAtEntry\": false,
            \"serverReadyAction\": {
                \"action\": \"openExternally\",
                \"pattern\": \"\\\\bNow listening on:\\\\s+(https?://\\\\S+)\"
            },
            \"env\": {
                \"ASPNETCORE_ENVIRONMENT\": \"Development\"
            },
            \"sourceFileMap\": {
                \"/Views\": \"\${workspaceFolder}/Views\"
            }
        },
        {
            \"name\": \".NET Core Attach\",
            \"type\": \"coreclr\",
            \"request\": \"attach\"
        }
    ]
}" > launch.json

# Gerar tasks.json
echo "{
    \"version\": \"2.0.0\",
    \"tasks\": [
        {
            \"label\": \"build\",
            \"command\": \"dotnet\",
            \"type\": \"process\",
            \"args\": [
                \"build\",
                \"\${workspaceFolder}/$full_company_name.$api_name.sln\",
                \"/property:GenerateFullPaths=true\",
                \"/consoleloggerparameters:NoSummary\"
            ],
            \"problemMatcher\": \"\$msCompile\"
        },
        {
            \"label\": \"publish\",
            \"command\": \"dotnet\",
            \"type\": \"process\",
            \"args\": [
                \"publish\",
                \"\${workspaceFolder}/$full_company_name.$api_name.sln\",
                \"/property:GenerateFullPaths=true\",
                \"/consoleloggerparameters:NoSummary\"
            ],
            \"problemMatcher\": \"\$msCompile\"
        },
        {
            \"label\": \"watch\",
            \"command\": \"dotnet\",
            \"type\": \"process\",
            \"args\": [
                \"watch\",
                \"run\",
                \"--project\",
                \"\${workspaceFolder}/$full_company_name.$api_name.sln\"
            ],
            \"problemMatcher\": \"\$msCompile\"
        }
    ]
}" > tasks.json

cd ..

# Continuação da criação da estrutura do projeto
mkdir src && cd src
dotnet new webapi -o "$full_company_name.$api_name.Api"
dotnet new classlib -o "$full_company_name.$api_name.Domain"
dotnet new classlib -o "$full_company_name.$api_name.Infrastructure"
dotnet new classlib -o "$full_company_name.$api_name.Application"

# Adicionar pacote ao projeto Api
cd "$full_company_name.$api_name.Api" && dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection --source https://api.nuget.org/v3/index.json

# Criar pastas adicionais dentro da API
mkdir Configuration Extensions Helpers Mappings Requests Responses Services

# Voltar para a pasta src
cd ..

# Adicionar referências conforme as dependências
# Application depende de Domain
cd "$full_company_name.$api_name.Application" && dotnet add reference "../$full_company_name.$api_name.Domain/"
cd ..

# Infrastructure (Persistence) depende de Application
cd "$full_company_name.$api_name.Infrastructure" && dotnet add reference "../$full_company_name.$api_name.Application/"
cd ..

# WebAPI depende de Application e Infrastructure (Persistence)
cd "$full_company_name.$api_name.Api" && dotnet add reference "../$full_company_name.$api_name.Application/"
dotnet add reference "../$full_company_name.$api_name.Infrastructure/"
cd ../..
# Criação dos projetos de teste e adição de referências
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
dotnet sln add "src/$full_company_name.$api_name.Domain"
dotnet sln add "src/$full_company_name.$api_name.Infrastructure"
dotnet sln add "src/$full_company_name.$api_name.Application"
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

echo "Projeto criado com sucesso!"

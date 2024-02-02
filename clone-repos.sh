#!/bin/zsh

# Substitua pelo seu token de acesso pessoal do GitHub
github_token="your-token"

# Configurações do repositório
org_name="viavarejo-internal"
repo_filter="vv-viaunica"
destination_folder=/Users/willianrattis/Development/Git/Via/ViaUnica

# Verifique se a pasta de destino existe e crie-a se necessário
if [[ ! -d $destination_folder ]]; then
  echo "Criando a pasta de destino: $destination_folder"
  mkdir -p $destination_folder
fi

# Função para obter repositórios usando a API GraphQL
get_repos_graphql() {
  query=$(cat <<-GQL
  {
    organization(login: "$org_name") {
      repositories(first: 100) {
        nodes {
          name
          url
        }
      }
    }
  }
GQL
)

  response=$(curl -H "Authorization: token $github_token" -X POST -H "Content-Type: application/json" -d "{\"query\":\"$(echo $query | tr '\n' ' ' | sed 's/"/\\"/g')\"}" https://api.github.com/graphql)
  echo "$response"
}

# Obtenha a lista de repositórios
echo "Obtendo repositórios..."
response=$(get_repos_graphql)
echo "Resposta da API GraphQL:"
echo "$response"

repos=$(echo "$response" | jq -r ".data.organization.repositories.nodes[] | select(.name | test(\"$repo_filter\")) | .url")

echo "Repositórios filtrados:"
echo "$repos"

# Clone os repositórios selecionados
for repo in ${(f)repos}; do
  echo "Clonando $repo..."
  git clone $repo $destination_folder/$(basename -s .git $repo)
done

echo "Clonagem dos repositórios concluída."
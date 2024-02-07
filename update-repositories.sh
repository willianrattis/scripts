#!/bin/bash

for d in */ ; do
    cd "$d"
    echo "Atualizando o repositório ${d%/}"
    git checkout develop/main
    git pull origin develop/main
    cd ..
done

echo "Todos os repositórios foram atualizados."


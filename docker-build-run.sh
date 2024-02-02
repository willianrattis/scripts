#!/bin/bash

# Prompt user for base path
read -p "Base path to Dockerfile: " base_path

# Change to the base directory
cd "$base_path"

# Check if the Dockerfile exists
if [ ! -f "Dockerfile" ]; then
  echo "Dockerfile not found in the current directory."
  exit 1
fi

# Prompt user for API name
read -p "Nome da api? " api_name

# Prompt user for environment
read -p "Ambiente? " ambiente

# Build Docker image
docker build -t "via-${api_name}-api" --build-arg "PROJECT_NAME_PATH=Via.${api_name}.Api" .

# Run Docker container
docker run -p 5000:5000 -e "ASPNETCORE_ENVIRONMENT=${ambiente}" -d "via-${api_name}-api"

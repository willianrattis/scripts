#!/bin/bash

# ANSI escape codes for formatting
BOLD=$(tput bold)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Step 1: Ask for user and password
echo "${BOLD}${YELLOW}Please enter your credentials to re-add the NuGet sources:${RESET}"
echo -n "Enter your username: "
read username
echo -n "Enter your password: "
read -s password
echo
echo

# Show current NuGet sources
echo "${BOLD}${YELLOW}Current registered NuGet sources:${RESET}"
dotnet nuget list source
echo
echo

# Step 2: Remove each NuGet source individually
echo "${BOLD}${YELLOW}Removing NuGet sources...${RESET}"
dotnet nuget remove source "nuget.org"
dotnet nuget remove source "Core"
dotnet nuget remove source "Via"
echo
echo

# Step 3: Clear NuGet caches
echo "${BOLD}${YELLOW}Clearing NuGet caches...${RESET}"
dotnet nuget locals all --clear
dotnet nuget locals global-packages --clear
echo
echo

# Step 4: Re-add sources
echo "${BOLD}${YELLOW}Re-adding NuGet sources...${RESET}"
dotnet nuget add source https://<your-personal-repositories>/repository/nuget-online/ --name Online --username $username --password $password --store-password-in-clear-text
dotnet nuget add source https://<your-personal-repositories>/repository/repository-core/ --name Core --username $username --password $password --store-password-in-clear-text
dotnet nuget add source https://api.nuget.org/v3/index.json --name nuget.org
echo
echo

# Show updated NuGet sources
echo "${BOLD}${YELLOW}Updated registered NuGet sources:${RESET}"
dotnet nuget list source
echo
echo

echo "${BOLD}${YELLOW}All operations completed successfully.${RESET}"

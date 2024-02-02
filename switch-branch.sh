#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NO_COLOR='\033[0m' # No Color

# The path to the folder containing your repositories
REPOS_FOLDER="/Users/willianrattis/Development/Git/Via/ViaUnica"

echo "Starting to check repositories..."
# Iterate over each subfolder
for repo in "$REPOS_FOLDER"/*; do
    if [ -d "$repo" ]; then # Check if it is a directory
        repo_name=$(basename "$repo")
        echo -e "\nChecking $repo_name..."
        cd "$repo"
        # Ensure we are in a Git repository
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            current_branch=$(git rev-parse --abbrev-ref HEAD)
            # Check if already on 'develop/main' branch
            if [[ "$current_branch" == "develop/main" ]]; then
                echo -e "${BLUE}$repo_name is already in the branch develop/main!${NO_COLOR}"
            else
                # Attempt to switch to 'develop/main' branch
                if git rev-parse --verify develop/main >/dev/null 2>&1; then
                    git checkout develop/main && echo -e "${GREEN}Switched to develop/main in $repo_name${NO_COLOR}" || echo -e "${RED}Failed to switch to develop/main in $repo_name. Current branch: $current_branch${NO_COLOR}"
                else
                    # If 'develop/main' does not exist, output the current branch
                    echo -e "${RED}$repo_name can't change to the branch develop/main. Current branch: $current_branch${NO_COLOR}"
                fi
            fi
        else
            echo -e "${RED}$repo_name is not a git repository.${NO_COLOR}"
        fi
    fi
done
echo "Repository check complete."

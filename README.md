# Script Collection

This repository contains a collection of scripts to automate various tasks related to repository management and .NET project setup. Below is a description and usage guide for each script.

## Scripts

### `clone-repos.sh`

**Description:**

This script clones a set of repositories from GitHub that match a specific filter from a given organization. It uses the GitHub GraphQL API to fetch repository URLs and then clones them into a specified directory.

**Usage:**

1. Replace `"your-token"` with your personal GitHub access token.
2. Set the `org_name` variable to the name of the GitHub organization.
3. Set the `repo_filter` to the specific filter term you want to match repository names against.
4. Set the `destination_folder` to the path where you want the repositories to be cloned.

Run the script in your terminal:

```sh
./clone-repos.sh
```

### `create-net-project-clean.sh`

**Description:**

This script sets up a clean .NET project structure with separate layers for API, Domain, Infrastructure, and Application. It also initializes a new git repository, creates necessary .vscode configuration files, and adds project references.

**Usage:**

1. Run the script.
2. Follow the interactive prompts to input whether it is a test project, the project directory path, and names for the company and API.

Run the script in your terminal:

```sh
./create-net-project-clean.sh
```

## General Instructions

To use the scripts, you may need to grant them execution permissions:

```sh
chmod +x *.sh
```

Ensure you have the required dependencies installed, such as `git`, `dotnet`, and any other tool used in the scripts.

For any issues or contributions, please open an issue or pull request in this repository.

This collection of scripts is designed to automate various tasks for .NET development, Docker container management, NuGet source handling, and Git operations. Below is a description of each script and its purpose.

## clone-repos.sh

Clones a filtered list of repositories from a specified GitHub organization using a personal access token. Repositories are cloned into a designated folder on the local machine.

## create-net-project-clean.sh

Creates a clean .NET project structure including API, Domain, Infrastructure, and Application layers with appropriate NuGet packages and references. It also generates VS Code configuration files for debugging and tasks.

## create-net-project.sh

Similar to `create-net-project-clean.sh`, but includes an additional Corporate class library and integration tests setup.

## describe_pod.sh

Uses `kubectl` to find and describe a Kubernetes pod based on a substring of the pod name provided by the user.

## docker-build-run.sh

Builds a Docker image from a specified Dockerfile and runs the container, setting the ASP.NET Core environment based on the user input.

## dotnet-build.sh

Continuously builds a .NET project from a specified directory path, with a user-defined wait time between builds.

## reset-nuget-sources.sh

Removes specified NuGet sources, clears NuGet caches, and re-adds sources with new credentials provided by the user.

## switch-branch.sh

Checks all Git repositories within a specified directory and attempts to switch them to the `develop/main` branch, reporting the status of each repository.

---

### Usage

Each script is designed to be run from a terminal. Make sure to grant execution permissions with `chmod +x <script-name>.sh` before running. For scripts that require input, follow the prompts provided by the script.

### Prerequisites

- Git installed for `clone-repos.sh` and `switch-branch.sh`
- .NET SDK installed for `create-net-project*.sh`, `dotnet-build.sh`, and `reset-nuget-sources.sh`
- Docker installed for `docker-build-run.sh`
- `kubectl` installed and configured for `describe_pod.sh`
- jq installed for parsing JSON in `clone-repos.sh`

Make sure to replace placeholder values such as personal access tokens, paths, and URLs with your actual data before running the scripts.

### Contributing

Feel free to fork this repository and customize the scripts as needed for your environment. Contributions and improvements are welcome through pull requests.

---

For detailed information on each script, refer to the comments provided at the beginning of each file.
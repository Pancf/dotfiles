#!/bin/sh

if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

if ! command -v curl &>/dev/null; then
    echo "${RED}Please install curl first.${NORMAL}"
    exit 1
fi

if ! command -v git &>/dev/null; then
    echo "${RED}Please install git first.${NORMAL}"
    exit 1
fi

if [[ "${SHELL}" != "/bin/zsh" ]]; then
    echo "${RED}Please set zsh as default shell first.${NORMAL}"
    exit 1
fi

function is_arm64()
{
    [[ $(uname -m) = "arm64" ]]
}

function is_x86()
{
    [[ $(uname -m) = "x86_64" ]]
}

sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"
    local repo_branch="$3"

    if [ -z "${repo_branch}" ]; then
        repo_branch="master"
    fi

    if [ ! -d "${repo_path}" ]; then
        mkdir -p "${repo_path}"
        git clone --depth 1 --branch ${repo_branch} "https://github.com/${repo_uri}.git" "${repo_path}"
    else
        cd "${repo_path}" && git pull --ff-only --stat origin ${repo_branch}; cd - >/dev/null
    fi
}

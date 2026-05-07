#!/usr/bin/env bash

if [[ -n "${DOTFILES_COMMON_SOURCED:-}" ]]; then
  return 0
fi
DOTFILES_COMMON_SOURCED=1

if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
  set -x
fi

if command -v tput >/dev/null 2>&1; then
  ncolors="$(tput colors 2>/dev/null || echo 0)"
else
  ncolors=0
fi

if [[ -t 1 && "${ncolors:-0}" -ge 8 ]]; then
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

DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-0}"

info() {
  printf '%s\n' "${BLUE}==>${NORMAL} $*"
}

warn() {
  printf '%s\n' "${YELLOW}warn:${NORMAL} $*" >&2
}

error() {
  printf '%s\n' "${RED}error:${NORMAL} $*" >&2
}

success() {
  printf '%s\n' "${GREEN}ok:${NORMAL} $*"
}

run() {
  if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
    printf 'dry-run:'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    error "missing required command: ${command_name}"
    return 1
  fi
}

ensure_dir() {
  local dir="$1"
  if [[ -d "${dir}" ]]; then
    return 0
  fi
  run mkdir -p "${dir}"
}

timestamp() {
  date '+%Y%m%d-%H%M%S'
}

sync_repo() {
  local repo_uri="$1"
  local repo_path="$2"
  local repo_branch="${3:-master}"

  if [[ ! -d "${repo_path}/.git" ]]; then
    ensure_dir "$(dirname "${repo_path}")"
    run git clone --depth 1 --branch "${repo_branch}" "https://github.com/${repo_uri}.git" "${repo_path}"
    return
  fi

  if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
    printf 'dry-run: git -C %q pull --ff-only --stat origin %q\n' "${repo_path}" "${repo_branch}"
    return 0
  fi

  git -C "${repo_path}" pull --ff-only --stat origin "${repo_branch}"
}

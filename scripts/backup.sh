#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

backup_path() {
  local path="$1"
  printf '%s.backup.%s' "${path}" "$(timestamp)"
}

backup_if_needed() {
  local path="$1"

  if [[ ! -e "${path}" && ! -L "${path}" ]]; then
    return 0
  fi

  local backup
  backup="$(backup_path "${path}")"
  info "Backing up ${path} to ${backup}"
  run mv "${path}" "${backup}"
}

backup_unless_repo_symlink() {
  local path="$1"
  local expected_target="$2"

  if [[ -L "${path}" ]]; then
    local current_target
    current_target="$(readlink "${path}")"
    if [[ "${current_target}" == "${expected_target}" ]]; then
      return 0
    fi
  fi

  backup_if_needed "${path}"
}


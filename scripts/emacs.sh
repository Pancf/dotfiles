#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"
source "${SCRIPT_DIR}/backup.sh"

install_emacs_config() {
  require_command git

  if [[ -e "${HOME}/.emacs.d" && ! -d "${HOME}/.emacs.d/.git" ]]; then
    backup_if_needed "${HOME}/.emacs.d"
  fi

  sync_repo syl20bnr/spacemacs "${HOME}/.emacs.d" develop
  ensure_dir "${HOME}/opensource"
  sync_repo Pancf/emacs-configuration "${HOME}/opensource/emacs-configuration" master

  local source_spacemacs="${HOME}/opensource/emacs-configuration/spacemacs-configuration/spacemacs"
  local target_spacemacs="${HOME}/.spacemacs"
  if [[ ! -f "${source_spacemacs}" ]]; then
    error "missing Spacemacs config: ${source_spacemacs}"
    return 1
  fi

  backup_if_needed "${target_spacemacs}"
  info "Installing .spacemacs"
  run cp "${source_spacemacs}" "${target_spacemacs}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_emacs_config
fi


#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/common.sh"
source "${SCRIPT_DIR}/backup.sh"

link_file() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "${source_path}" ]]; then
    error "source does not exist: ${source_path}"
    return 1
  fi

  ensure_dir "$(dirname "${target_path}")"

  if [[ -L "${target_path}" ]]; then
    local current_target
    current_target="$(readlink "${target_path}")"
    if [[ "${current_target}" == "${source_path}" ]]; then
      success "Already linked ${target_path}"
      return 0
    fi
  fi

  backup_unless_repo_symlink "${target_path}" "${source_path}"
  info "Linking ${target_path} -> ${source_path}"
  run ln -s "${source_path}" "${target_path}"
}

link_dotfiles() {
  link_file "${DOTFILES_DIR}/shell/zshenv" "${HOME}/.zshenv"
  link_file "${DOTFILES_DIR}/shell/zshrc" "${HOME}/.zshrc"
  link_file "${DOTFILES_DIR}/git/gitconfig" "${HOME}/.gitconfig"
  link_file "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config.ghostty"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  link_dotfiles
fi

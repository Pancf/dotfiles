#!/usr/bin/env bash
set -euo pipefail

if [[ "${DOTFILES_DEBUG:-0}" == "1" ]]; then
  set -x
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DOTFILES_DIR}/scripts/common.sh"

SKIP_BREW=0
SKIP_SHELL=0
SKIP_GIT=0
SKIP_GHOSTTY=0
SKIP_MACOS=0
SKIP_EMACS=0
SKIP_NVM=0

usage() {
  cat <<'USAGE'
Usage: ./bootstrap.sh [options]

Options:
  --dry-run       Show actions without changing files
  --skip-brew     Skip Homebrew installation
  --skip-shell    Skip Oh My Zsh and shell plugin installation
  --skip-git      Skip Git symlink step
  --skip-ghostty  Skip Ghostty symlink step
  --skip-macos    Skip macOS defaults
  --skip-emacs    Skip Emacs configuration
  --skip-nvm      Skip nvm installation
  --help          Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      export DOTFILES_DRY_RUN=1
      DOTFILES_DRY_RUN=1
      ;;
    --skip-brew) SKIP_BREW=1 ;;
    --skip-shell) SKIP_SHELL=1 ;;
    --skip-git) SKIP_GIT=1 ;;
    --skip-ghostty) SKIP_GHOSTTY=1 ;;
    --skip-macos) SKIP_MACOS=1 ;;
    --skip-emacs) SKIP_EMACS=1 ;;
    --skip-nvm) SKIP_NVM=1 ;;
    --help)
      usage
      exit 0
      ;;
    *)
      error "unknown option: $1"
      usage
      exit 2
      ;;
  esac
  shift
done

info "Bootstrapping dotfiles from ${DOTFILES_DIR}"
if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
  warn "dry-run mode is enabled"
fi

require_command git
require_command curl

if [[ "${SKIP_BREW}" == "0" ]]; then
  source "${DOTFILES_DIR}/scripts/brew.sh"
  install_brew_bundle
fi

if [[ "${SKIP_SHELL}" == "0" ]]; then
  source "${DOTFILES_DIR}/scripts/zsh.sh"
  install_zsh_stack
fi

if [[ "${SKIP_NVM}" == "0" ]]; then
  source "${DOTFILES_DIR}/scripts/nvm.sh"
  install_nvm
fi

source "${DOTFILES_DIR}/scripts/link.sh"
if [[ "${SKIP_SHELL}" == "0" ]]; then
  link_file "${DOTFILES_DIR}/shell/zshenv" "${HOME}/.zshenv"
  link_file "${DOTFILES_DIR}/shell/zshrc" "${HOME}/.zshrc"
fi
if [[ "${SKIP_GIT}" == "0" ]]; then
  link_file "${DOTFILES_DIR}/git/gitconfig" "${HOME}/.gitconfig"
fi
if [[ "${SKIP_GHOSTTY}" == "0" ]]; then
  link_file "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config"
fi

if [[ "${SKIP_EMACS}" == "0" ]]; then
  source "${DOTFILES_DIR}/scripts/emacs.sh"
  install_emacs_config
fi

if [[ "${SKIP_MACOS}" == "0" ]]; then
  source "${DOTFILES_DIR}/macos/defaults.sh"
  configure_macos_defaults
fi

success "Bootstrap complete"


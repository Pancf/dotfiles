#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/common.sh"

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  info "Installing Homebrew"
  if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
    printf 'dry-run: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\n'
    return 0
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

load_homebrew_shellenv() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew_bundle() {
  install_homebrew
  load_homebrew_shellenv
  require_command brew
  info "Installing Homebrew bundle"
  run brew bundle --file "${DOTFILES_DIR}/Brewfile"
  info "Cleaning Homebrew"
  run brew cleanup
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_brew_bundle
fi


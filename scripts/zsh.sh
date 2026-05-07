#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

install_oh_my_zsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    success "Oh My Zsh already installed"
    return 0
  fi

  info "Installing Oh My Zsh"
  if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
    printf 'dry-run: RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"\n'
    return 0
  fi

  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_powerlevel10k() {
  local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "${theme_dir}/.git" ]]; then
    success "Powerlevel10k already installed"
    return 0
  fi

  ensure_dir "$(dirname "${theme_dir}")"
  info "Installing Powerlevel10k"
  run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${theme_dir}"
}

install_zsh_custom_plugin() {
  local name="$1"
  local repo="$2"
  local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/${name}"

  if [[ -d "${plugin_dir}/.git" ]]; then
    success "${name} already installed"
    return 0
  fi

  ensure_dir "$(dirname "${plugin_dir}")"
  info "Installing ${name}"
  run git clone --depth=1 "${repo}" "${plugin_dir}"
}

install_zsh_stack() {
  require_command git
  require_command curl
  install_oh_my_zsh
  install_powerlevel10k
  install_zsh_custom_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
  install_zsh_custom_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_zsh_stack
fi


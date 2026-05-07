#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

install_nvm() {
  local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
  if [[ -s "${nvm_dir}/nvm.sh" ]]; then
    success "nvm already installed"
    return 0
  fi

  require_command curl
  info "Installing nvm with upstream installer"
  if [[ "${DOTFILES_DRY_RUN}" == "1" ]]; then
    printf 'dry-run: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash\n'
    return 0
  fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_nvm
fi


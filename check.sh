#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${ROOT_DIR}"

bash -n bootstrap.sh check.sh scripts/*.sh macos/defaults.sh
git config --file git/gitconfig --list >/dev/null

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck bootstrap.sh check.sh scripts/*.sh macos/defaults.sh
else
  printf '%s\n' 'warn: shellcheck not installed; skipping shellcheck'
fi

if command -v brew >/dev/null 2>&1; then
  if ! brew bundle check --file Brewfile; then
    printf '%s\n' 'warn: Brewfile dependencies are not fully installed; run brew bundle --file Brewfile to install them'
  fi
else
  printf '%s\n' 'warn: brew not installed; skipping brew bundle check'
fi

DOTFILES_DRY_RUN=1 ./bootstrap.sh --dry-run --skip-brew --skip-emacs --skip-macos --skip-nvm

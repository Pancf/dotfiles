#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../scripts/common.sh"

write_default() {
  run defaults write "$@"
}

configure_macos_defaults() {
  info "Applying macOS defaults"

  write_default NSGlobalDomain AppleICUForce24HourTime -bool true
  write_default NSGlobalDomain AppleShowAllExtensions -bool true
  write_default NSGlobalDomain KeyRepeat -int 2
  write_default NSGlobalDomain InitialKeyRepeat -int 30
  write_default com.apple.dock orientation -string left
  write_default com.apple.AppleMultitouchTrackpad Clicking -bool true
  write_default com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  write_default NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  write_default NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
  write_default NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  run killall Dock || true
  run killall Finder || true
  run killall SystemUIServer || true
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  configure_macos_defaults
fi

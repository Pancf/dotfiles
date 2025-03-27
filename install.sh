#!/bin/sh

EMACSD=$HOME/.emacs.d

function backup_dotfiles()
{
    confs="
    .gitconfig
    .zshenv
    .zshrc
    .zshrc.local
    "
    for c in ${confs}; do
        [ -f ${HOME}/${c} ] && mv ${HOME}/${c} ${HOME}/${c}.bak
    done
    [ -d ${EMACSD} ] && mv ${EMACSD} ${EMACSD}.bak
}

backup_dotfiles

source misc.sh

source install_ohmyzsh.sh

cp .zshenv ${HOME}/.zshenv

cp .zshrc ${HOME}/.zshrc

cp gitconfig ${HOME}/.gitconfig

source install_brew.sh

source install_emacs_config.sh

source install_dracula.sh

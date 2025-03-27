#!/bin/sh

git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

[ ! -d ${HOME}/opensource ] && mkdir -p ${HOME}/opensource
sync_repo Pancf/emacs-configuration ${HOME}/opensource/emacs-configuration
[ -f ${HOME}/.spacemacs ] && rm ${HOME}/.spacemacs
cp ${HOME}/opensource/emacs-configuration/spacemacs-configuration/spacemacs ${HOME}/.spacemacs

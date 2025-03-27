#!/bin/bash

if ! command -v brew &>/dev/null; then
    echo "${GREEN}Installing homebrew{NORMAL}"
    
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if is_arm64; then
        touch  ${HOME}/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

fi

bottles=(
    bat
    git-delta
    ripgrep
    rbenv
    pyenv
    emacs-plus@31
    font-fira-code-nerd-font
    font-meslo-lg-nerd-font
    google-chrome
    raycast
    iterm2
)

function pyenv_hook()
{
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshenv
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshenv
    echo 'eval "$(pyenv init - zsh)"' >> ~/.zshenv
}

function rbenv_hook()
{
    echo 'eval "$(rbenv init - --no-rehash zsh)"' >> ~/.zshenv
}

function install_bottles()
{
    for bottle in ${bottls[@]}; do
        echo "${BLUE}Installing ${bottle}.${NORMAL}"
        brew install -q ${bottle}
        if [[ "${bottle}" = "pyenv" ]]; then
            pyenv_hook
        fi
        if [[ "${bottle}" = "rbenv" ]]; then
            rbenv_hook
        fi
    done
}

function clean()
{
    brew cleanup
}

install_bottles
clean
    

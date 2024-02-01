#!/usr/bin/env bash

# Default config for installation of packages
brew=false
scm_breeze=false
node=false
vscode=false
docker=false
vimrc=false
iterm2=false
ohmyzsh=false

shell_path=""

# load config for packages
# shellcheck source=config.sh
source "./config.sh"

echo_green() {
    local message="$1"
    local green='\033[0;32m'
    local nc='\033[0m' # No Color

    echo -e "${green}${message}${nc}"
}

echo_red() {
    local message="$1"
    local green='\033[0;31m'
    local nc='\033[0m' # No Color

    echo -e "${green}${message}${nc}"
}

show_error_and_exit() {
    echo_red "$1"
    exit 1
}

check_create_shell_profile() {
    if [[ "$SHELL" == "/bin/zsh" ]]; then
      if [[ ! -f $HOME/.zshrc ]]; then
        touch ~/.zshrc
      fi
      shell_path="$HOME/.zshrc"
    elif [[ "$SHELL" == "/bin/bash" ]]; then
        if [[ ! -f $HOME/.bash_profile ]]; then
          touch ~/.bashrc
          echo "[ -r ~/.bashrc ] && . ~/.bashrc" > ~/.bash_profile
        fi
        shell_path="$HOME/.bashrc"
    fi
}

install_brew() {
    set +e
    brew -v && return
    set -e

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo $HOME
    echo "Adding brew settings to shell path: $shell_path"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $shell_path
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew -v || show_error_and_exit "Brew install failed"
    echo_green "Brew installed successfully"
}

install_brew_packages() {
    local additional_packages=("$@")

    brew install git jq vim
    git --version || show_error_and_exit "Git install failed"
    jq --version || show_error_and_exit "jq install failed"
    vim --version || show_error_and_exit "vim install failed"

    for package in "${additional_packages[@]}"; do
        brew install "$package"
        echo_green "Package '$package' installed with success"
    done

    echo_green "Brew packages installed successfully"
}

install_vscode() {
    curl -fsSL -o vs-code.zip "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
    unzip vs-code.zip -d /Applications
    echo_green "VSCode installed successfully"
}

install_nvm_and_node() {
    latest_tag="$(curl -sSL https://api.github.com/repos/nvm-sh/nvm/tags | jq '.[0].name' | tr -d '"')"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$latest_tag/install.sh" | bash

    # shellcheck disable=SC1090
    source "$HOME/.nvm/nvm.sh"

    nvm -v || show_error_and_exit "nvm install failed"
    nvm install stable
    echo "nvm and stable Node.js installed successfully"
}

install_docker() {
    echo "Checking Docker is installed"
    docker -v && return

    brew install --cask docker
}

install_iterm() {
    curl -fsSL -o iterm.zip https://iterm2.com/downloads/stable/latest
    unzip iterm.zip -d /Applications
    echo_green "iTerm2 installed successfully"
}

install_vimrc() {
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
}

install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_scm_breeze() {
    git clone git://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze
    ~/.scm_breeze/install.sh
}

show_usage() {
    cat <<-EOF
Usage: $(basename "$0") [additional-brew-packages]

This command sets up Mac machine by installing:

- Brew
- Brew packages
- VSCode
- Node.js
- Docker
- Vim and Vimrc
- iTerm2
- OhMyZsh and Scm Breeze

additional-brew-packages:

    List of additional packages to be installed (Default: git jq vim)

EOF
    exit 1
}

main() {
    [[ "$1" == "-h" ]] && show_usage

    echo_red "Make sure to run post-setup-mac.sh after this"
    sleep 1

    check_create_shell_profile

    if [[ "$brew" == true ]]; then
        local additional_brew_packages=("${@:1}")
        install_brew
        install_brew_packages "${additional_brew_packages[@]}"
    fi

    [[ "$scm_breeze" == true ]] && install_scm_breeze
    [[ "$node" == true ]] && install_nvm_and_node
    [[ "$vscode" == true ]] && install_vscode
    [[ "$docker" == true ]] && install_docker
    [[ "$vimrc" == true ]] && install_vimrc
    [[ "$iterm2" == true ]] && install_iterm
    [[ "$ohmyzsh"  == true ]] && install_ohmyzsh
}

main "$@"

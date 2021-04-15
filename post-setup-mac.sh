#!/usr/bin/env bash

main() {
    [[ -s "/Users/ardeshireshghi/.scm_breeze/scm_breeze.sh" ]] && echo '[ -s "/Users/ardeshireshghi/.scm_breeze/scm_breeze.sh" ] && source "/Users/ardeshireshghi/.scm_breeze/scm_breeze.sh"' >> ~/.zshrc
    [[ -d "$HOME/.nvm" ]] && cat >> ~/.zshrc <<EOF
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOF
}

main "$@"

# mac-setup-scripts

Set of shell scripts for installing packages and editors on Mac.

## Usage

1. Clone the repo on you Mac machine

`git clone git@github.com:ardeshireshghi/mac-setup-scripts.git`

2. Open `config.sh` and set/unset the packages that you need.

3. Run `./setup-mac.sh` which will install the items in `config.sh` that are set to `true`

If you need additional "Brew" tools just add them to command: `./setup-mac.sh go rust [...more]`

4. (optional) If you are installing `oh-my-zsh` together with `nvm` and `scm-breeze`, make sure you run `./post-setup-mac.sh`. This is because `oh-my-zsh` creates a new `~/.zshrc` and you lose the NVM and scm-breeze setup.

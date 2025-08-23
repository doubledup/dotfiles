#!/usr/bin/env bash

set -euo pipefail

endcolor='\x1b[0m'
blue='\x1b[0;34m'
green='\x1b[0;32m'
red='\x1b[0;31m'
yellow='\x1b[0;33m'

os_name="$(uname -s)"
printf "%bSetting up %s...%b\n" "$blue" "$os_name" "$endcolor"

if [ "$os_name" = "Darwin" ]; then

    printf '%bDisabling "smart" quotes...%b\n' "$blue" "$endcolor"
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    printf '%bChecking XCode...%b\n' "$blue" "$endcolor"
    if xcode-select --version >/dev/null; then
        printf '%bXCode is already installed.%b\n' "$green" "$endcolor"
    else
        printf '%bInstalling XCode...%b\n' "$blue" "$endcolor"
        xcode-select --install
    fi

    printf '%bChecking Homebrew...%b\n' "$blue" "$endcolor"
    if [ -d /opt/homebrew/ ]; then
        printf '%bHomebrew is already installed.%b\n' "$green" "$endcolor"
    else
        printf '%bInstalling Homebrew...%b\n' "$blue" "$endcolor"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    printf '%bHomebrew is ready. Installing packages...%b\n' "$blue" "$endcolor"
    brew bundle install --file "$HOME"/.dotfiles/rcignore/Brewfile

    # Update claude with Homebrew, not with claude
    claude config set -g autoUpdates false

    printf '%bSymlinking dotfiles...%b\n' "$blue" "$endcolor"
    RCRC="$HOME"/.dotfiles/rcrc rcup -t mac

    printf '%bCopying Karabiner config...%b\n' "$blue" "$endcolor"
    cp ~/.dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
    echo '___'
    printf '%bCopied Karabiner config. Restart Karabiner now.%b\n' "$yellow" "$endcolor"
    echo '___'

    printf '%bCopying Firefox style...%b\n' "$blue" "$endcolor"
    chromedir=$(ls -d "$HOME"/Library/Application\ Support/Firefox/Profiles/*default-release)/chrome
    mkdir -p "$chromedir"
    if [ -f "$chromedir/userChrome.css" ]; then
        echo '___'
        printf '%bFirefox style already exists. Not copying style from dotfiles.%b\n' "$yellow" "$endcolor"
        echo '___'
    else
        ln -s "$HOME"/.dotfiles/rcignore/userChrome.css "$chromedir"/userChrome.css
        printf '%bFirefox styling applied.%b\n' "$green" "$endcolor"
    fi

    printf '%bSetting up Rust...%b\n' "$blue" "$endcolor"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    printf '%bSetting up Elm...%b\n' "$blue" "$endcolor"
    npm i -g npm
    npm i -g @elm-tooling/elm-language-server elm-format elm-live elm-review elm-test
else
    printf '%bNo installation set up for %s yet%b\n' "$red" "$os_name" "$endcolor"
fi

printf '%bSetup complete!%b\n' "$green" "$endcolor"

#!/usr/bin/env fish

# ARM Homebrew binaries
[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

[ -f (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish ]; and source (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish

set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

# zsh plugins
# if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fi
# if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# fi

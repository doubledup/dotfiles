#!/usr/bin/env fish

# ARM Homebrew binaries
[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)
# Rosetta/x86 Homebrew
set -x PATH $PATH '/usr/local/bin'
alias ibrew='arch -x86_64 /usr/local/bin/brew'

[ -f (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish ]; and source (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish
# [ -f (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish ]; and source (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish

set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

# # use gnu utils by default
# set -x PATH "/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# set -x PATH "/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

# zsh plugins
# if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fi
# if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# fi

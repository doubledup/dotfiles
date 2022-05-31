#!/usr/bin/env fish

# ARM Homebrew binaries
[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

# Rosetta/x86 Homebrew
set -x PATH $PATH '/usr/local/bin'
alias ibrew='arch -x86_64 /usr/local/bin/brew'

# # use gnu utils by default
# set -x PATH "/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# set -x PATH "/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

# asdf
# [ -f (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish ]; and source (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish
[ -f (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish ]; and source (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish

# goku config file
set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

# [ -f (brew --prefix)/share/autojump/autojump.fish ]; and source (brew --prefix)/share/autojump/autojump.fish
zoxide init --cmd j fish | source
# type zoxide > /dev/null
# if test $status -eq 0
#   zoxide init fish | source
# end

# zsh plugins
# if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fi
# if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# fi

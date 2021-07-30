#!/usr/bin/env fish

# Rosetta/x86 Homebrew binaries
set -x PATH $PATH "/usr/local/bin"

# ARM Homebrew binaries
[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

alias ibrew='arch -x86_64 /usr/local/bin/brew'

# # use gnu utils by default
# set -x PATH "/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# set -x PATH "/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# set -x MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

[ -f (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish ]; and source (arch -x86_64 /usr/local/bin/brew --prefix asdf)/asdf.fish
[ -f (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish ]; and source (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish

[ -f ~/.asdf/plugins/dotnet-core/set-dotnet-home.fish ]; and source ~/.asdf/plugins/dotnet-core/set-dotnet-home.fish

[ -f (brew --prefix)/share/autojump/autojump.fish ]; and source (brew --prefix)/share/autojump/autojump.fish

# if [[ -f "$(brew --prefix)/opt/fzf/bin" && ! "$PATH" == "*$(brew --prefix)/opt/fzf/bin*" ]]; then
#   export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
# fi
# [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" && $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null
# [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

# if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fi

# if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
#   source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# fi

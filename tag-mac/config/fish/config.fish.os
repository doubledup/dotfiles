#!/usr/bin/env fish

# Homebrew binaries
set -x PATH "/usr/local/bin:$PATH"

# use gnu utils by default
set -x PATH "/usr/local/opt/coreutils/libexec/gnubin:$PATH"
set -x MANPATH "/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
set -x PATH "/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
set -x MANPATH "/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

source (brew --prefix asdf)/asdf.fish

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

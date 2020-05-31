#!/usr/bin/env fish

function fish_greeting
  # fortune | cowsay
end

# Tools

## fzf
set -x FZF_DEFAULT_OPTS "-i --bind alt-j:preview-down,alt-k:preview-up,alt-n:preview-page-down,alt-p:preview-page-up,ctrl-n:page-down,ctrl-p:page-up --height 50% --preview '(highlight -O ansi -l {} || cat {}) 2> /dev/null | head -1000'"
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

## thefuck
command -v thefuck >/dev/null; and thefuck --alias | source

## git
# The default less flags that git uses are FRX:
#
# F makes less exit if there's less than one page of diff. This makes `git
# diff` inconsistent: sometimes it opens less, sometimes not.
#
# X prevents the less output from getting cleared when less exits. This
# pollutes terminal output after scrolling multiple pages of diff.
#
# Removing these makes the behaviour of `git diff` consistent: it *always*
# opens less and *never* leaves its output lying around in the terminal.
set -x LESS -R

# Path

## binaries
set -x PATH "$HOME/.local/bin:$PATH"

## exenv
if command -v exenv >/dev/null
  # set -x PATH "$HOME/.exenv/bin:$PATH"
  # eval "$(exenv init - --no-rehash)"
end

## go
set -x GOPATH "$HOME/code/go"
set -x PATH "$GOPATH/bin:$PATH"

## nodenv
if command -v nodenv >/dev/null
  # set -x PATH "$HOME/.nodenv/bin:$PATH"
  # eval "$(nodenv init - --no-rehash)"
end

## pyenv
if command -v pyenv >/dev/null
  status --is-interactive; and source (pyenv init - --no-rehash|psub)
  set -x PIPENV_VENV_IN_PROJECT 1
end

## rbenv
if command -v rbenv >/dev/null
  status --is-interactive; and source (rbenv init - --no-rehash|psub)
end

## rust
set -x PATH "$HOME/.cargo/bin:$PATH"

# Aliases

## builtins
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias ll='ls -l --color=auto'
alias sl='sl | lolcat'

## git
alias g=git
alias gst='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -v'
alias gco='git checkout'
alias grb='git rebase'
alias glog='git log --oneline --decorate --graph'

## vim & nvim
set -x EDITOR 'nvim'

alias v="$EDITOR"
alias vim!='vim -N -u NONE -U NONE'
alias nvim!='nvim -N -u NONE -U NONE'
alias vimrc="$EDITOR ~/.vimrc"
alias nvimrc="$EDITOR ~/.config/nvim/init.vim"

alias e='emacsclient -c'
alias et='emacsclient -t'

## zsh
alias zshrc="$EDITOR ~/.zshrc"

alias :q=exit

test -e ~/.config/fish/config.fish.os; and source ~/.config/fish/config.fish.os
test -e ~/.config/fish/config.fish.local; and source ~/.config/fish/config.fish.local

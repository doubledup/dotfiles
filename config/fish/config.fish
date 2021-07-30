#!/usr/bin/env fish

function fish_greeting
  set csf (command -v cowspeakfortune)

  if test -n "$csf"
    cowspeakfortune
  end
end

## thefuck
command -v thefuck >/dev/null; and thefuck --alias | source

# Environment variables

## fzf
# set --universal FZF_DEFAULT_COMMAND 'fd'
set FZF_KEYBINDINGS 'alt-o:toggle-preview,alt-j:preview-down,alt-k:preview-up,alt-n:preview-page-down,alt-p:preview-page-up,ctrl-n:page-down,ctrl-p:page-up'
set FZF_PREVIEW 'highlight -O ansi -l {} || cat {} | head -1000 2> /dev/null'
set FZF_PREVIEW_WINDOW 'right:60%:wrap' #:noborder:hidden
set -x FZF_DEFAULT_OPTS "-i --bind $FZF_KEYBINDINGS --height 80% --preview '$FZF_PREVIEW' --preview-window '$FZF_PREVIEW_WINDOW'"
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

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
set -x LESS -Rix4

# Path

set -x PIPENV_VENV_IN_PROJECT 1

## binaries
set -x PATH $PATH $HOME/.local/bin

## dotnet-core
alias dn='dotnet'

## go
set -x GOPATH "$HOME/.local/share/go"
set -x PATH $PATH $GOPATH/bin

## rust
set -x PATH $PATH $HOME/.cargo/bin

# Aliases

## builtins
alias sl='sl | lolcat'

## emacs
alias e='emacsclient -c'
alias et='emacsclient -t'

## fish
alias fishrc="$EDITOR ~/.config/fish/config.fish"

alias f=fuck
alias fucking=sudo

## git
alias g=git
alias gst='git status'
alias gb='git branch'
alias ga='git add'
alias gc='git commit -v'
alias gco='git checkout'
alias grb='git rebase'
alias glog='git log --oneline --decorate --graph'

## kitty
alias icat='kitty +kitten icat --align=left'

## kubernetes
alias k=kubectl
alias mk=minikube

## skaffold
alias sk=skaffold

## vim & neovim
set -x EDITOR 'nvim'
alias nv="$EDITOR"
alias vim!='vim -N -u NONE -U NONE'
alias nvim!='nvim -N -u NONE -U NONE'
alias vimrc="$EDITOR ~/.vimrc"
alias nvimrc="$EDITOR ~/.config/nvim/init.vim"

## vscode
alias c='code'

## zsh
alias zshrc="$EDITOR ~/.zshrc"

alias :q=exit

# Functions

function plz
    eval sudo $history[1]
end

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

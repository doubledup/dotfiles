#!/usr/bin/env fish

# Environment variables

set -x BAT_THEME 'TwoDark'
set -x EDITOR 'nvim'
set -x GTI_SPEED 3000
set -x PIPENV_VENV_IN_PROJECT 1

## fzf
# ctrl-y:execute-silent(echo {} | pbcopy)+abort,
set FZF_KEYBINDINGS 'ctrl-o:toggle-all,alt-o:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,alt-j:preview-down,alt-k:preview-up,alt-d:preview-half-page-down,alt-u:preview-half-page-up'
set FZF_PREVIEW 'bat --style=numbers --color=always --line-range :1000 {} 2> /dev/null'
set FZF_PREVIEW_WINDOW 'down:wrap' #:noborder :hidden :60%
set -x FZF_DEFAULT_OPTS "--height 100% --bind $FZF_KEYBINDINGS --preview '$FZF_PREVIEW' --preview-window '$FZF_PREVIEW_WINDOW'" # --ansi
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -x FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git . \$dir"

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
# -i: ignore case in searches
# -x4: tabs are 4 characters wide
set -x LESS -Rix4

## Path

### binaries
set -x PATH $PATH $HOME/.local/bin

### go
set -x GOPATH "$HOME/.local/share/go"
set -x PATH $PATH $GOPATH/bin

## rust
set -x PATH $PATH $HOME/.cargo/bin

# Aliases

if type -q batcat
  alias bat=batcat
end
if type -q fdfind
  alias fd=fdfind
end

## builtins
alias :q=exit
alias la='ls -alh --color=auto'
alias ll='ls -lh --color=auto'
alias ls='ls -h --color=auto'
alias sl='sl -aF | lolcat'

alias c=cargo

## dotnet-core
alias dn='dotnet'

## emacs
alias e='emacsclient -c'
alias et='emacsclient -t'

## fish
function fishrc
  cd ~/.dotfiles
  $EDITOR config/fish/config.fish
  cd -
end

## thefuck
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
function git_wrapper
  if test "$argv" = "stash poop"
    echo '💩'
    sleep 2
    command git stash pop
  else
    command git $argv
  end
end
alias git=git_wrapper

## kitty
alias icat='kitty +kitten icat --align=left'
alias kssh='kitty +kitten ssh'

## kubernetes
alias k=kubectl
alias mk=minikube

## skaffold
alias sk=skaffold

## vim & neovim
alias nv="$EDITOR"
alias vn="$EDITOR"
alias vim!='vim -N -u NONE -U NONE'
alias nvim!='nvim -N -u NONE -U NONE'
function nvimrc
  cd ~/.dotfiles
  $EDITOR config/nvim/init.vim
  cd -
end

## vscode
alias co='code'

## zsh
function zshrc
  cd ~/.dotfiles
  $EDITOR zshrc
  cd -
end

# Functions

function plz
    eval sudo $history[1]
end

function fish_greeting
  set csf (command -v cowspeakfortune)

  if test -n "$csf"
    cowspeakfortune
  end
end

# Key bindings
# not using a fish_user_key_bindings function, since that seems to be used by fzf
bind \cj "$EDITOR"
bind \e, fishrc
bind \em accept-autosuggestion execute
bind \co 'fish_commandline_prepend $EDITOR'
bind \ea 'echo; ls -al; commandline -f repaint'
bind \cs 'echo; git status; commandline -f repaint'
bind \cg 'git diff; commandline -f repaint'

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

[ -f ~/.asdf/asdf.fish ]; and source ~/.asdf/asdf.fish

[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -f (command -v direnv) ]; and direnv hook fish | source
[ -f (command -v thefuck) ]; and thefuck --alias | source

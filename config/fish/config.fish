#!/usr/bin/env fish

# Environment variables

set -x BAT_PAGER "less $LESS -n"
set -x BAT_THEME 'Coldark-Dark'
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

## less
# The default less flags that bat & git use are FRX:
#
# F makes less exit if there's less than one page of diff. This makes `git
# diff` inconsistent: sometimes it opens less, sometimes not.
#
# X prevents the less output from getting cleared when less exits. This
# pollutes terminal output after scrolling multiple pages of diff.
#
# Removing these makes the behaviour of less consistent: it *always*
# opens less and *never* leaves its output lying around in the terminal.
#
# N displays line numbers
# Q keeps less quiet: terminal bells are never rung.
# R is needed to interpret ANSI colors correctly. (from bat's help for its
# --pager flag)
# -i: ignore case in searches
# -x4: tabs are 4 characters wide
set -x LESS -QRNix4

## Path

### binaries
set -x PATH $PATH $HOME/.local/bin

### foundry
export PATH="$PATH:/Users/daviddunn/.foundry/bin"

### go
set -x GOPATH "$HOME/.local/share/go"
set -x PATH $PATH $GOPATH/bin

# pnpm
set -gx PNPM_HOME "/Users/daviddunn/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

## rust
set -x PATH $PATH $HOME/.cargo/bin

## yarn
set -x PATH $PATH $HOME/.yarn/bin/

# Aliases

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
function fishrc --description "Edit Fish shell config";
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
alias gf='git fetch'
alias gz='git stash'
alias gp='git pull'
alias gh='git push'
alias gco='git checkout'
alias gc='git commit -v'
alias gb='git branch'
alias glog='git log --oneline --decorate --graph'
alias ga='git add'
alias gr='git reset'

alias grb='git rebase'

function git_wrapper --description "Toilet humour typo";
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
function nvimrc --description "Edit NeoVim config";
  cd ~/.dotfiles
  $EDITOR config/nvim/init.vim
  cd -
end

## vscode
alias co='code'

# Functions

function plz --description "Plz just do the thing (sudo)";
    eval sudo $history[1]
end

function fish_greeting --description "Custom cow-powered greeting";
  set csf (command -v cowspeakfortune)

  if test -n "$csf"
    cowspeakfortune
  end
end

# Key bindings
# not using a fish_user_key_bindings function, since that seems to be used by fzf
bind \e, fishrc
bind \cj "$EDITOR"
bind \em accept-autosuggestion execute
bind \ei "PAGER=$EDITOR __fish_preview_current_file"
bind \ea 'echo; ls -al; commandline -f repaint'
bind \cs 'echo; git status; commandline -f repaint'
bind \cg 'git diff; commandline -f repaint'
# Pass previous args to different command
bind \ek 'commandline -f history-search-backward beginning-of-line kill-word'

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

if type -q bat
  set -x PAGER (command -v bat)
end

[ -f ~/.asdf/asdf.fish ]; and source ~/.asdf/asdf.fish

[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -f (command -v direnv) ]; and direnv hook fish | source
[ -f (command -v thefuck) ]; and thefuck --alias | source

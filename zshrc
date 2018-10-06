# zsh
setopt promptsubst
git_prompt() {
  if [[ -d .git ]]; then
    dirty=$(git status\
      --porcelain\
      --ignore-submodules=none \
      2> /dev/null |
      wc -l |
      sed 's/^0$//;s/[0-9][0-9]*/*/'
    )

    stash=$(git stash list |
      wc -l |
      sed 's/^0$//;s/[0-9][0-9]*/[S:&]/'
    )

    branch_name=$(git branch |
      sed -n '/\* /s///p' |
      sed "s/^\([^(]*\)$/%F{green}($dirty$stash\1)%f/" |
      sed "s/(HEAD detached at \(.*\))$/%F{yellow}(${dirty}${stash}detached@\1)%f/"
    )
    echo "$branch_name"
  fi
}
PS1='[%F{blue}%3~%f]$(git_prompt)%(!.#.$) '

exit_status='%(?..%F{red}%?%f)'
RPS1="${exit_status}"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000000
setopt append_history
setopt no_extended_glob
# read histfile whenever history is needed
setopt share_history
# save commands to history before they're run
setopt inc_append_history

# alt-backspace clears by word, where [/-_ ] aren't considered as being in words

WORDCHARS=${WORDCHARS/\/}
WORDCHARS=${WORDCHARS/\-}
WORDCHARS=${WORDCHARS/\_}
WORDCHARS=${WORDCHARS/\ }
WORDCHARS=${WORDCHARS/\.}

# eval `dircolors ~/.dir_colors`
# export TERM=xterm-256color

# autojump
[ -f /usr/share/autojump/autojump.zsh ] && . /usr/share/autojump/autojump.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# git
export LESS=-R

# Aliases

## builtins
alias la='ls -al'
alias ll='ls -l'
alias claer='clear'

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
export EDITOR='nvim'

alias vim!='vim -N -u NONE -U NONE'
alias vimrc="$EDITOR ~/.vimrc"
alias nvimrc="$EDITOR ~/.config/nvim/init.vim"

## zsh
alias zshrc="$EDITOR ~/.zshrc"
setopt AUTO_CD
command_not_found_handler() {
  if [[ $1 =~ ^b[kb]*$ ]]; then
    len=${#1}
    up_one=../
    unset arg
    for _ in {1..$len}
    do
      arg+=$up_one
    done
    echo 'zsh spawns command_not_found_handler in a new subshell :'"'"'('
    echo 'cd '$arg
    cd ../
  else
    exit 127
  fi
}
alias :q=exit

# Path

## binaries
export PATH="$HOME/.local/bin:$PATH"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

## nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

## go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

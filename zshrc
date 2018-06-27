# Zsh
PS1="%(?.%F{green}.%F{red})%?%f [%F{blue}%3~%f]%(#.#.$) "
#RPS1=""
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
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    local WORDCHARS=${WORDCHARS/\-}
    local WORDCHARS=${WORDCHARS/\_}
    local WORDCHARS=${WORDCHARS/\ }
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

# eval `dircolors ~/.dir_colors`
# export TERM=xterm-256color

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

## local binaries
export PATH="$HOME/.local/bin:$PATH"

# autojump
# /usr/share/autojump/autojump.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

## nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

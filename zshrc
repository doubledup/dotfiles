# Zsh
PS1="%(?.%F{green}.%F{red})%?%f [%F{white}%3~%f]%(#.#.$) "
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
alias gc='git commit'
alias gco='git checkout'
alias grb='git rebase'

## vim
alias vim!='vim -N -u NONE -U NONE'
alias vimrc='vim ~/.vimrc'

## zsh
alias zshrc='vim ~/.zshrc'
setopt AUTO_CD
command_not_found_handler() {
  if [[ $1 =~ ^b[kb]*$ ]]; then
    len=${#1}
    up_one=../
    unset arg
    # echo "cmd len: $len"
    # echo "arg before: $arg"
    for _ in {1..$len}
    do
      arg+=$up_one
      # echo "arg so far: $arg"
    done
    echo 'zsh spawns command_not_found_handler in a new subshell :'"'"'('
    echo 'cd '$arg
    cd ../
    # echo 'ran cd'
  else
    exit 127
  fi
}

# Path

## local binaries
export PATH="$HOME/.local/bin:$PATH"

# autojump
# /usr/share/autojump/autojump.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## npm
export PATH=$HOME/.npm-global/bin:$PATH

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

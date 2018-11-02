#!/usr/bin/env zsh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000000
setopt append_history
setopt no_extended_glob
# read histfile whenever history is needed
setopt share_history
# save commands to history before they're run
setopt inc_append_history
# cd by typing directory name
setopt auto_cd
setopt no_beep

. ~/.zshrc.zni

zstyle ':completion:*' rehash true

# autocomplete switches for aliases
setopt complete_aliases
setopt menu_complete

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# alt-backspace clears by word, where [/_ .-] aren't considered as being in words
WORDCHARS=$(echo $WORDCHARS | sed 's/[\/_ \.\-]//g')
# change highlight for dark theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=2'

# eval `dircolors ~/.dir_colors`
# export TERM=xterm-256color

# prompt

setopt promptsubst
git_prompt() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) ]]; then
    branch=$(git branch |
      sed -n '/\* /s///p' |
      sed "s/^\([^(]*\)$/\1/" |
      sed "s/(HEAD detached at \(.*\))$/detached@\1/"
    )

    dirty=$(git status\
      --porcelain\
      --ignore-submodules=none \
      2> /dev/null |
      wc -l |
      sed 's/^0$//;s/[0-9][0-9]*/*/'
    )

    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
      ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
      behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

      remote=''
      if [ $ahead -gt 0 ] || [ $behind -gt 0 ]
      then
        remote+='|'
      fi
      if [ $ahead -gt 0 ]
      then
        remote+="$ahead->"
      fi
      if [ $behind -gt 0 ]
      then
        remote+="<-$behind"
      fi
    fi

    stash=$(git stash list |
      wc -l |
      sed 's/^0$//;s/[0-9][0-9]*/|S:&/'
    )

    if [[ -n ${dirty} ]]; then
      prompt='%F{yellow}'
    else
      prompt='%F{green}'
    fi

    prompt+="($branch$dirty$remote$stash)%f"
    echo $prompt
  fi
}

PS1='[%F{blue}%3~%f]$(git_prompt)%(!.#.♠) '
exit_status='%(?..%F{red}%?%f)'
RPS1="${exit_status}"

# Tools

## autojump
[ -f /usr/share/autojump/autojump.zsh ] && . /usr/share/autojump/autojump.zsh

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--bind alt-j:preview-down,alt-k:preview-up,alt-n:preview-page-down,alt-p:preview-page-up,ctrl-n:page-down,ctrl-p:page-up --height 50% --preview '(highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## git
export LESS=-R

# Aliases

## builtins
alias la='ls -al'
alias ll='ls -l'

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

#!/usr/bin/env zsh

# zsh settings

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

setopt menu_complete

# change highlight for dark theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=2'

# when moving & deleting by word, [/_ .-] aren't considered as being in words
WORDCHARS=$(echo $WORDCHARS | sed 's/[\/_ \.=-]//g' | sed 's/\$/|/g')

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

    remote=${$(command git rev-parse --verify $branch@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
      ahead=$(command git rev-list $branch@{upstream}..HEAD 2>/dev/null | wc -l)
      behind=$(command git rev-list HEAD..$branch@{upstream} 2>/dev/null | wc -l)

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

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="-i --bind alt-j:preview-down,alt-k:preview-up,alt-n:preview-page-down,alt-p:preview-page-up,ctrl-n:page-down,ctrl-p:page-up --height 50% --preview '(highlight -O ansi -l {} || cat {}) 2> /dev/null | head -1000'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## thefuck
eval $(thefuck --alias)

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
export LESS=-R

# Path

## binaries
export PATH="$HOME/.local/bin:$PATH"

## exenv
export PATH="$HOME/.exenv/bin:$PATH"
eval "$(exenv init - --no-rehash)"

## go
export GOPATH="$HOME/code/go"
export PATH="$GOPATH/bin:$PATH"

## nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init - --no-rehash)"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"
export PIPENV_VENV_IN_PROJECT=1

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - --no-rehash)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

## rust
export PATH="$HOME/.cargo/bin:$PATH"

# Aliases

## builtins
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias ll='ls -l --color=auto'
alias sl='sl | lolcat'

## eopkg
alias eobundle="cat Eofile | tr '\n' ' ' | sed 's/.$/\n/' | xargs sudo eopkg install"

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

[[ -f "$HOME/.zshrc.os" ]] && source ~/.zshrc.os
[[ -f "$HOME/.zshrc.local" ]] && source ~/.zshrc.local

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

setopt menu_complete

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# change highlight for dark theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=2'

if [[ $(uname -s) == "Darwin" ]]; then
  # use gnu utils by default
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
else
  [ -f /usr/share/autojump/autojump.zsh ] && . /usr/share/autojump/autojump.zsh
fi

# alt-backspace clears by word, where [/_ .-] aren't considered as being in words
WORDCHARS=$(echo $WORDCHARS | sed 's/[\/_ \.=-]//g' | sed 's/\$/|/g')

eval `dircolors ~/.dir_colors`

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
export FZF_DEFAULT_OPTS="--bind alt-j:preview-down,alt-k:preview-up,alt-n:preview-page-down,alt-p:preview-page-up,ctrl-n:page-down,ctrl-p:page-up --height 50% --preview '(highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## git
export LESS=-R

# Aliases

## builtins
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias ll='ls -l --color=auto'

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

## exenv
export PATH="$HOME/.exenv/bin:$PATH"
eval "$(exenv init -)"

## go
export GOPATH="$HOME/code/go"
export PATH="$GOPATH/bin:$PATH"

## nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PIPENV_VENV_IN_PROJECT=1

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

[[ -f "$HOME/.zshrc.local" ]] && source ~/.zshrc.local

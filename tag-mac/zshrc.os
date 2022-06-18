#!/usr/bin/env zsh

. "$(brew --prefix asdf)/asdf.sh"

[ -f "$(brew --prefix)/etc/profile.d/autojump.sh" ] && . "$(brew --prefix)/etc/profile.d/autojump.sh"

if [[ -f "$(brew --prefix)/opt/fzf/bin" && ! "$PATH" == "*$(brew --prefix)/opt/fzf/bin*" ]]; then
  export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
fi
[[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" && $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null
[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

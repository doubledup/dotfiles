#!/usr/bin/env zsh

eval `dircolors ~/.dir_colors`

# get extra info for VTE-based terminal emulators
# (lets new termainals open with the same dir as the current one)
if [ $VTE_VERSION ]; then
  if [ -f /etc/profile.d/vte.sh ]; then
    source /etc/profile.d/vte.sh
  elif [ -f /usr/share/defaults/etc/profile.d/vte.sh ]; then
    source /usr/share/defaults/etc/profile.d/vte.sh
  fi
fi

if [ -f /usr/share/autojump/autojump.zsh ]; then
  . /usr/share/autojump/autojump.zsh
fi

[[ -f '/usr/share/fzf/completion.zsh' && $- == *i* ]] && source '/usr/share/fzf/completion.zsh' 2> /dev/null
[ -f '/usr/share/fzf/key-bindings.zsh' ] && source '/usr/share/fzf/key-bindings.zsh'

syntax_plugin_file='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if [ -f "$syntax_plugin_file" ]; then
  source "$syntax_plugin_file"
fi

autosuggestions_plugin_file='/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
if [ -f "$autosuggestions_plugin_file" ]; then
  source "$autosuggestions_plugin_file"
fi

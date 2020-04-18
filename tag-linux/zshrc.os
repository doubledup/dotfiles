#!/usr/bin/env zsh

if [ -f /usr/share/autojump/autojump.zsh ]; then
  . /usr/share/autojump/autojump.zsh
fi

# get extra info for VTE-based terminal emulators
# (lets new termainals open with the same dir as the current one)
if [ $VTE_VERSION ]; then
  if [ -f /etc/profile.d/vte.sh ]; then
    source /etc/profile.d/vte.sh
  elif [ -f /usr/share/defaults/etc/profile.d/vte.sh ]; then
    source /usr/share/defaults/etc/profile.d/vte.sh
  fi
fi

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

eval `dircolors ~/.dir_colors`

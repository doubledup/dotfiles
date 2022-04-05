#!/usr/bin/env fish

# # get extra info for VTE-based terminal emulators
# # (lets new termainals open with the same dir as the current one)
# if [ $VTE_VERSION ]; then
#   if [ -f /etc/profile.d/vte.sh ]; then
#     source /etc/profile.d/vte.sh
#   elif [ -f /usr/share/defaults/etc/profile.d/vte.sh ]; then
#     source /usr/share/defaults/etc/profile.d/vte.sh
#   fi
# fi

alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias ll='ls -l --color=auto'

alias fd=fdfind

source ~/.asdf/asdf.fish

[ -f /usr/share/autojump/autojump.fish ]; and source /usr/share/autojump/autojump.fish

set fzf_key_bindings_file /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
if test -e $fzf_key_bindings_file
  source $fzf_key_bindings_file
  fzf_key_bindings
end

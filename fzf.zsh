# Setup fzf
# ---------
if [[ -f "$(brew --prefix)/opt/fzf/bin" && ! "$PATH" == "*$(brew --prefix)/opt/fzf/bin*" ]]; then
  export PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ -f '/usr/share/fzf/completion.zsh' && $- == *i* ]] && source '/usr/share/fzf/completion.zsh' 2> /dev/null
[[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" && $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
[ -f '/usr/share/fzf/key-bindings.zsh' ] && source '/usr/share/fzf/key-bindings.zsh'
[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

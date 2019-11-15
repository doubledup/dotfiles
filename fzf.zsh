# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/david.dunn/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/david.dunn/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/david.dunn/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/david.dunn/.fzf/shell/key-bindings.zsh"

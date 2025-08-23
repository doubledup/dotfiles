#!/usr/bin/env fish

# TODO: set up an fzf history file
# set FZF_HISTORY_FILE '~/.local/share/fzf/fzf_history'
# --history $FZF_HISTORY_FILE
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set FZF_PREVIEW 'bat --color always --line-range :1000 --style numbers {} 2> /dev/null'
set FZF_PREVIEW_WINDOW_HOR '70%,bottom,border-top,nowrap'
# set FZF_PREVIEW_WINDOW_VERT '60%,right,border-left,nowrap,hidden'
# set FZF_PREVIEW_WINDOW_HOR_CHANGE 'alt-l:change-preview-window(right,border-left|bottom,border-top|hidden)'
# set FZF_PREVIEW_WINDOW_VERT_CHANGE 'alt-l:change-preview-window(bottom,border-top|right,border-left|hidden)'

# TODO: make separate ignore-vcs bindings for fzf's cd shortcut \ec
set FZF_KEYBINDINGS (string join "," -- \
    "ctrl-o:toggle-all" \
    "alt-o:toggle-preview" \
    "alt-h:reload($FZF_DEFAULT_COMMAND --no-ignore-vcs)" \
    "alt-a:reload($FZF_DEFAULT_COMMAND --ignore-vcs)" \
    "ctrl-j:half-page-down" \
    "ctrl-k:half-page-up" \
    "alt-j:preview-half-page-down" \
    "alt-k:preview-half-page-up" \
    "alt-n:preview-down" \
    "alt-p:preview-up" \
    "ctrl-r:next-history" \
    "ctrl-s:prev-history" \
    # "$FZF_PREVIEW_WINDOW_HOR_CHANGE" \
    "ctrl-y:execute-silent(echo {} | fish_clipboard_copy)" \
)

set -x FZF_DEFAULT_OPTS (string join " " -- \
    "--height 98%" \
    "--layout reverse" \
    "--scrollbar █" \
    "--bind '$FZF_KEYBINDINGS'" \
    "--preview '$FZF_PREVIEW'" \
    "--preview-window '$FZF_PREVIEW_WINDOW_HOR'" \
)

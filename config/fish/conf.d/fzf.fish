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
    "ctrl-n:half-page-down" \
    "ctrl-p:half-page-up" \
    "alt-j:preview-down" \
    "alt-k:preview-up" \
    "alt-n:preview-half-page-down" \
    "alt-p:preview-half-page-up" \
    # "ctrl-r:next-history" \
    # "ctrl-s:prev-history" \
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

# fzf theme: tokyo night moon
set -x FZF_DEFAULT_OPTS (string join " " -- \
  $FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
)

# disable preview for history search
set -x FZF_CTRL_R_OPTS "--preview ''"

# disable preview for directory jump
set -x FZF_ALT_C_OPTS "--preview ''"

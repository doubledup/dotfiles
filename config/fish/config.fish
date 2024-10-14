#!/usr/bin/env fish

# Environment variables

## less
# The default less flags are FRX:
#
# F makes less exit if there's less than one page of diff. This makes `git
# diff` inconsistent: sometimes it opens less, sometimes not.
#
# X prevents the less output from getting cleared when less exits. This
# pollutes terminal output after scrolling multiple pages of diff.
#
# Removing these makes the behaviour of less consistent: it *always*
# opens less and *never* leaves its output lying around in the terminal.
#
# -Q keeps less quiet: terminal bells are never rung.
# -R is needed to interpret ANSI colors correctly. (from bat's help for its --pager flag)
# -i: ignore case in searches
# -x4: tabs are 4 characters wide
set -x LESS -NQRix4

set -x EDITOR 'nvim'
set -x GTI_SPEED 3000
set -x PIPENV_VENV_IN_PROJECT 1

# bat
set -x BAT_PAGER "less $LESS"
# ayu-mirage theme from
# https://github.com/alin23/ayu/blob/0c5d548909bee59ced21a1a471bfb3b36bd02141/ayu-mirage.tmTheme
set -x BAT_THEME 'ayu-mirage'
set -x BAT_STYLE changes,header-filename

## fzf
# TODO: set up a history file
# set FZF_HISTORY_FILE '~/.local/share/fzf/fzf_history'
# --history $FZF_HISTORY_FILE
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set FZF_PREVIEW 'bat --color always --line-range :1000 --style numbers {} 2> /dev/null'
set FZF_PREVIEW_WINDOW_HOR '70%,bottom,border-top,nowrap,hidden'
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
    "alt-n:preview-half-page-down" \
    "alt-p:preview-half-page-up" \
    "alt-j:preview-down" \
    "alt-k:preview-up" \
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

# set FZF_PS_COMMAND 'ps -ax -o tt,pid,user,%cpu,%mem,rss,start,command'
# set FZF_PS_KEYBINDINGS 'alt-v:ignore,alt-h:ignore'
# set FZF_PS_OPTS "--no-preview --bind $FZF_PS_KEYBINDINGS"

## Path

### binaries
set -x PATH $HOME/.local/bin $PATH

### emacs (doom)
set -x PATH $HOME/.config/emacs/bin $PATH

### homebrew
export HOMEBREW_NO_ANALYTICS=1

### go
set -x GOPATH "$HOME/.local/share/go"
set -x PATH $GOPATH/bin $PATH

## rust
set -x PATH $HOME/.cargo/bin $PATH

## yarn
# set -x PATH $PATH $HOME/.yarn/bin/

# Aliases & abbreviations

## builtins
abbr :q exit
alias ls='ls -Fh --color=auto'
alias sl='sl -Fa | lolcat'
abbr l 'ls'
abbr ll 'ls -l'
abbr la 'ls -al'
abbr --position command - 'cd -'
abbr --position command cdtemp 'cd (mktemp -d)'

## bat
abbr bat! 'bat --pager "less $LESS -n" --style=default'

## emacs
abbr e 'emacsclient -c'
abbr et 'emacsclient -t'

## fish
function fishrc --description "Edit Fish shell config";
    cd ~/.dotfiles
    $EDITOR config/fish/config.fish
    cd -
end

## git
abbr g git
abbr gst 'git status'
abbr gf 'git fetch'
abbr gz 'git stash'
abbr gp 'git pull'
abbr gu 'git push'
abbr gd 'git diff'
abbr gco 'git checkout'
abbr gc 'git commit -v'
abbr gb 'git branch'
abbr gl 'git log --oneline --decorate --graph'
abbr glp 'git log --patch --decorate --graph'
abbr gs 'git show'
abbr gsp 'git show --patch'
abbr ga 'git add'
abbr gr 'git reset'
abbr grb 'git rebase'
abbr gm 'git merge'
abbr gcp 'git cherry-pick'

function git_wrapper --description "Toilet humour typo";
    if test "$argv" = "stash poop"
        echo '💩'
        sleep 2
        command git stash pop
    else
        command git $argv
    end
end
alias git=git_wrapper

## kitty
alias icat='kitty +kitten icat --align=left'
abbr kssh 'kitty +kitten ssh'

## rust
abbr c cargo

## vim & neovim
abbr nv "$EDITOR"
abbr vn "$EDITOR"
abbr vim! 'vim -N -u NONE -U NONE'
abbr nvim! 'nvim -N -u NONE -U NONE'

function nvimrc --description "Edit NeoVim config";
    cd ~/.dotfiles
    $EDITOR config/nvim/init.vim
    cd -
end

## vscode
abbr co 'code'

# Functions

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

function plz --description "Plz do the thing (sudo)";
    eval sudo $history[1]
end

function fish_greeting --description "Custom cow-powered greeting";
    set csf (command -v cowspeakfortune)

    if test -n "$csf"
      cowspeakfortune
    end
end

set fish_prompt_pwd_full_dirs 4
function fish_title
    set -q argv[1]; or set argv fish
    echo (string trim $argv): (prompt_pwd);
end

# Key bindings
bind \e- cd_prev
function cd_prev
    cd -
    commandline -f repaint
end

# not using a fish_user_key_bindings function, since that seems to be used by fzf
bind \ev nvimrc
bind \e, fishrc

function launch_editor
    commandline -i " $EDITOR "
    commandline -f backward-kill-word beginning-of-line yank execute
end
bind \co launch_editor

bind \ea 'echo; ls -al; commandline -f repaint'
bind \el 'echo; ls; commandline -f repaint'

# git
bind \cs 'echo; git status; commandline -f repaint'
bind \cg 'git diff; commandline -f repaint'

# Pass previous args to different command
bind \ek 'commandline -f history-search-backward beginning-of-line kill-word'

bind \eh 'MANWIDTH=(math $COLUMNS - 13) MANPAGER=\'bat --wrap never\' __fish_man_page'
bind \eP btm

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

if type -q bat
    set -x PAGER "$(command -v bat)"
end

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH

# zoxide needs to be rerun in new shells
[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -z "$IN_NIX_SHELL" -a -f (command -v direnv) ]; and direnv hook fish | source

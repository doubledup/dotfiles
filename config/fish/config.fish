#!/usr/bin/env fish

# Environment variables

set -x BAT_PAGER "less $LESS"
set -x BAT_THEME ayu-mirage
set -x BAT_STYLE changes,header-filename

set -x EDITOR nvim
set -U fish_greeting

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

## Path

### binaries
set -x PATH $HOME/.local/bin $PATH

### dotnet
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x PATH $HOME/.dotnet/tools $PATH

### homebrew
set -x HOMEBREW_NO_ANALYTICS 1

### go
set -x GOPATH "$HOME/.local/share/go"
set -x PATH $GOPATH/bin $PATH

### sam
set -x SAM_CLI_TELEMETRY 0

# Aliases & abbreviations

## builtins
abbr :q exit
abbr l ls
abbr la 'ls -al'
abbr ll 'ls -l'
alias ls='ls -Fh --color=auto'
alias sl='sl -Fa | lolcat'
abbr --position command - 'cd -'
abbr --position command cdtemp 'cd (mktemp -d)'

## bat
abbr bat! 'bat --pager "less $LESS -n" --style=default'

## brew
abbr b brew
abbr bb brew bundle
abbr bi brew info
abbr bs brew search
abbr bu brew uninstall
abbr bwh brew which-formula

## fish
function fishrc --description "Edit Fish shell config"
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
# avoid conflict with git-spice
abbr gsh 'git show'
abbr gsp 'git show --patch'
abbr ga 'git add'
abbr gr 'git reset'
abbr grb 'git rebase'
abbr gm 'git merge'
abbr gcp 'git cherry-pick'

## kitty
alias icat='kitty +kitten icat --align=left'
abbr kssh 'kitty +kitten ssh'

## rust
abbr c cargo

## vim & neovim
abbr v "$EDITOR"
abbr vim! 'vim -N -u NONE -U NONE'
abbr nvim! 'nvim -N -u NONE -U NONE'
abbr vk 'NVIM_APPNAME=nvim-kickstart nvim'

function nvimrc --description "Edit NeoVim config"
    cd ~/.dotfiles
    $EDITOR config/nvim/init.lua
    cd -
end

# Functions

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

set fish_prompt_pwd_full_dirs 2
function fish_title
    set -q argv[1]; or set argv fish
    set command_name (string split ' ' $argv[1])[1]
    echo $command_name:(prompt_pwd | xargs basename)
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

bind \ea 'echo; ls -al; echo; commandline -f repaint'

# git
bind \cs 'echo; git status; echo; commandline -f repaint'
bind \cg 'git diff'

# Pass previous args to different command
bind \ek 'commandline -f history-search-backward beginning-of-line kill-word'

bind \eh 'MANWIDTH=(math $COLUMNS - 13) MANPAGER=\'bat --wrap never\' __fish_man_page'
bind \eP btm

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

if type -q bat
    set -x PAGER "$(command -v bat)"
end

# zoxide needs to be rerun in new shells
[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -z "$IN_NIX_SHELL" -a -f (command -v direnv) ]; and direnv hook fish | source

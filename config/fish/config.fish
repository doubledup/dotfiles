# Environment variables

set -x BAT_PAGER "less $LESS"
set -x BAT_THEME ayu-mirage
set -x BAT_STYLE changes,header-filename

set -x EDITOR nvim
set -U fish_greeting

## less
# -N: show line numbers
# -Q: keep less quiet, so the terminal bell is never rung. Use a visual bell if it exists.
# -R: output ANSI colors and OSC 8 hyperlinks in "raw" form, allowing the terminal emulator to
# handle them correctly. (from bat's help for its --pager flag)
# -i: ignore case in searches
# -x4: tabs are 4 characters wide
set -x LESS -NQRix4
set -x LESSOPEN '|bat --color=always --paging=never %s'

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

set fish_prompt_pwd_full_dirs 2

# EDITOR / {neo,}vim abbrs
# kept here so they have access to EDITOR (aliases.fish loads before config.fish)
abbr v "$EDITOR"
abbr vim! 'vim -N -u NONE -U NONE'
abbr nvim! 'nvim -N -u NONE -U NONE'
abbr vk 'NVIM_APPNAME=nvim-kickstart nvim'

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

if type -q bat
    set -x PAGER "$(command -v bat)"
end

# zoxide needs to be rerun in new shells
[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -z "$IN_NIX_SHELL" -a -f (command -v direnv) ]; and direnv hook fish | source

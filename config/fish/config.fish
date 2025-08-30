set -U fish_greeting
set fish_prompt_pwd_full_dirs 2

# env

set -x EDITOR nvim
# abbr kept here so it has access to EDITOR (aliases.fish loads before config.fish)
abbr v "$EDITOR"
abbr vk 'NVIM_APPNAME=nvim-kickstart nvim'
abbr nvim! 'nvim -N -u NONE -U NONE'

# less
# -N: show line numbers
# -Q: keep less quiet, so the terminal bell is never rung. Use a visual bell if it exists.
# -R: output ANSI colors and OSC 8 hyperlinks in "raw" form, allowing the terminal emulator to
# handle them correctly. (from bat's help for its --pager flag)
# -i: ignore case in searches
# -x4: tabs are 4 characters wide
set -x LESS -NQRix4
set -x LESSOPEN '|bat --color=always --paging=never %s'

# bat (after less so that $LESS is set)
set -x BAT_PAGER "less $LESS"
set -x BAT_STYLE changes
set -x BAT_THEME ayu-mirage

# path

set -x PATH $HOME/.local/bin $PATH

set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x PATH $HOME/.dotnet/tools $PATH

set -x HOMEBREW_NO_ANALYTICS 1

set -x GOPATH "$HOME/.local/share/go"
set -x PATH $GOPATH/bin $PATH

set -x SAM_CLI_TELEMETRY 0

# other

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

# these run after the OS settings so that we know the commands are available.
# e.g. `brew shellenv` on MacOS sets these up in PATH.
set -x PAGER "$(command -v bat)"
[ -z "$IN_NIX_SHELL" ]; and direnv hook fish | source
fzf --fish | source
zoxide init --cmd j fish | source

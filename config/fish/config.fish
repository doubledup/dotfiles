# Environment variables

set -x BAT_PAGER "less $LESS"
set -x BAT_THEME ayu-mirage
set -x BAT_STYLE changes,header-filename

set -x EDITOR nvim
set -U fish_greeting

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

set fish_prompt_pwd_full_dirs 2

test -e ~/.config/fish/config.os.fish; and source ~/.config/fish/config.os.fish
test -e ~/.config/fish/config.local.fish; and source ~/.config/fish/config.local.fish

if type -q bat
    set -x PAGER "$(command -v bat)"
end

# zoxide needs to be rerun in new shells
[ -f (command -v zoxide) ]; and zoxide init --cmd j fish | source
[ -z "$IN_NIX_SHELL" -a -f (command -v direnv) ]; and direnv hook fish | source

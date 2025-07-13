#!/usr/bin/env fish

[ -z "$IN_NIX_SHELL" -a -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

fzf --fish | source

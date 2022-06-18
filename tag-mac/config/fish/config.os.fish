#!/usr/bin/env fish

[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

[ -f (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish ]; and source (/opt/homebrew/bin/brew --prefix asdf)/asdf.fish

set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

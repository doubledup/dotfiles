#!/usr/bin/env fish

set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

[ -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

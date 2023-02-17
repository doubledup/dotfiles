#!/usr/bin/env fish

set -gx PNPM_HOME "/Users/daviddunn/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH

set -x GOKU_EDN_CONFIG_FILE "$HOME/.config/goku.edn"

[ -z "$IN_NIX_SHELL" -a -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

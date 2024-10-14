#!/usr/bin/env fish

# set -gx PNPM_HOME "/Users/daviddunn/Library/pnpm"
# set -gx PATH "$PNPM_HOME" $PATH

[ -z "$IN_NIX_SHELL" -a -f /opt/homebrew/bin/brew ]; and eval (/opt/homebrew/bin/brew shellenv)

# Default recipe - show available recipes
default:
    @just --list

# The sole push path Claude Code runs unattended: raw `git push` is denied in
# claude/settings.json, and this recipe's fixed shape makes force/delete,
# arbitrary remotes, and -c/env injection impossible from the caller side - only
# a validated branch name is accepted, and origin is checked to be a github.com
# host before pushing. The host check is accident-prevention against a repointed
# origin, not attacker-proof (see DESIGN.md for the accepted residuals).

# Push a branch to origin (github-host-checked); no force, no delete, sanitized environment.
push branch=`git branch --show-current`:
    #!/usr/bin/env bash
    set -euo pipefail
    branch={{quote(branch)}}
    if [[ ! "$branch" =~ ^[A-Za-z0-9._/-]+$ ]]; then
        echo "just push: refusing suspicious branch name: $branch" >&2
        exit 1
    fi
    url=$(env -i PATH="$PATH" HOME="$HOME" git remote get-url --push origin)
    case "$url" in
    git@github.com:* | ssh://git@github.com/* | https://github.com/*) : ;;
    *)
        echo "just push: refusing non-github origin: $url" >&2
        exit 1
        ;;
    esac
    env -i PATH="$PATH" HOME="$HOME" SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-}" \
        git push -u origin "refs/heads/$branch:refs/heads/$branch"

# Format all known file types
fmt:
    stylua .
    fd -e fish --hidden --exclude .git -X fish_indent --write
    shfmt --write $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts)
    prettier --write '**/*.json' '**/*.md'

# Check formatting without modifying files
fmt-check:
    stylua --check .
    fd -e fish --hidden --exclude .git -X fish_indent --check
    shfmt --diff $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts)
    prettier --check '**/*.json' '**/*.md' >/dev/null

# Run linters
lint:
    fish --no-execute $(fd -e fish --hidden --exclude .git)
    shellcheck $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts)
    typos

# Run format check and lint
check: fmt-check lint

# Test the PreToolUse guard hook (secret-path read guard)
test-claude-hooks:
    @echo "Testing guard hook..."
    bash rcignore/test_guard.sh

# Test that configs load without errors
test: test-claude-hooks
    @echo "Testing nvim plugins..."
    nvim --headless +"luafile rcignore/test_plugins.lua"
    @echo "Testing fish config..."
    fish -c 'exit'
    @echo "All config tests passed."

# Update all packages and run tests
update:
    @echo 'brew:'
    brew upgrade
    brew bundle check --global || brew bundle install --global

    @echo 'terminfo:'
    just terminfo

    @echo 'rustup:'
    rustup update
    rustup component add rust-analyzer
    cargo install \
        cargo-audit \
        cargo-bloat \
        cargo-cache \
        cargo-edit \
        cargo-expand \
        cargo-features-manager \
        cargo-fuzz \
        cargo-info \
        cargo-machete \
        cargo-outdated \
        cargo-show-asm \
        cargo-watch \
        speedtest-rs \
        zeitfetch

    @echo 'tldr:'
    tldr --update

    @echo 'nvim:'
    nvim --headless -c MasonToolsUpdateSync -c qa
    @echo "Review plugin changes in the Lazy UI, then quit nvim to continue."
    nvim -c "lua require('lazy').sync()"

    @echo 'mas:'
    mas upgrade

    @echo 'softwareupdate:'
    sudo softwareupdate -ir

    @echo 'test:'
    just test

# Pull dotfile updates, re-link, sync packages and nvim plugins, and triage orphan brews
sync:
    rcdn -t mac
    git pull
    RCRC=~/.dotfiles/rcrc rcup -t mac
    brew bundle --no-upgrade --global
    nvim -c "lua require('lazy').restore()"
    just terminfo
    just brew-cleanup

# Detect and triage brew packages not tracked in Brewfile
brew-cleanup:
    ./scripts/brew-cleanup

# Install a Ghostty terminfo override that softens the bell flash to grey
terminfo:
    ./scripts/install-terminfo

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./scripts/find-broken-symlinks {{args}}

# List all inline TODO/FIXME/HACK comments
todos:
    rg 'TODO|FIXME|HACK' --glob '!lazy-lock.json' --glob '!BACKLOG.md'

# Default recipe - show available recipes
default:
    @just --list

# Format all known file types
fmt:
    stylua .
    find . -name '*.fish' -exec fish_indent --write {} +
    shfmt --write $(find . -name '*.sh') $(shfmt -f ./scripts)
    prettier --write '**/*.json' '**/*.md'

# Check formatting without modifying files
fmt-check:
    stylua --check .
    find . -name '*.fish' -exec fish_indent --check {} +
    shfmt --diff $(find . -name '*.sh') $(shfmt -f ./scripts)
    prettier --check '**/*.json' '**/*.md' >/dev/null

# Run linters
lint:
    fish --no-execute $(find . -name '*.fish')
    shellcheck $(find . -name '*.sh') $(shfmt -f ./scripts)
    typos

# Run format check and lint
check: fmt-check lint

# Test that configs load without errors
test:
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
    just brew-cleanup

# Detect and triage brew packages not tracked in Brewfile
brew-cleanup:
    ./scripts/brew-cleanup

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./scripts/find-broken-symlinks {{args}}

# List all inline TODO/FIXME/HACK comments
todos:
    rg 'TODO|FIXME|HACK' --glob '!lazy-lock.json' --glob '!BACKLOG.md'

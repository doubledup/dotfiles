# Default recipe - show available recipes
default:
    @just --list

# Format all known file types
fmt:
    stylua .
    find . -name '*.fish' -exec fish_indent --write {} +
    shfmt --write $(find . -name '*.sh')
    prettier --write '**/*.json' '**/*.md'

# Check formatting without modifying files
fmt-check:
    stylua --check .
    find . -name '*.fish' -exec fish_indent --check {} +
    shfmt --diff $(find . -name '*.sh')
    prettier --check '**/*.json' '**/*.md' >/dev/null

# Run linters
lint:
    fish --no-execute $(find . -name '*.fish')
    shellcheck $(find . -name '*.sh')
    typos

# Run format check and lint
check: fmt-check lint

# Test that configs load without errors
test:
    @echo "Testing nvim config..."
    nvim --headless -c 'quit'
    @echo "Testing fish config..."
    fish -c 'exit'
    @echo "All config tests passed."

# Update all packages (brew, cargo, nvim, mas, system)
update:
    @echo 'brew:'
    brew bundle upgrade --global

    @echo 'rustup:'
    rustup update
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
    nvim --headless +MasonToolsUpdateSync +qa
    nvim --headless +TSUpdateSync +qa
    nvim --headless "+Lazy! sync" +qa

    @echo 'mas:'
    mas upgrade

    @echo 'softwareupdate:'
    sudo softwareupdate -ir

# Pull dotfile updates and re-link
sync:
    rcdn -t mac
    git pull
    RCRC=~/.dotfiles/rcrc rcup -t mac

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./scripts/find-broken-symlinks {{args}}

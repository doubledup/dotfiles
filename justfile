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
    typos
    shellcheck $(find . -name '*.sh')

# Run lint and format check
check: lint fmt-check

# Test that configs load without errors
test:
    @echo "Testing nvim config..."
    nvim --headless -c 'quit'
    @echo "Testing fish config..."
    fish -c 'exit'
    @echo "All config tests passed."

# Update all packages (brew, cargo, nvim, mas, system)
update:
    updateAll

# Pull dotfile updates and re-link
sync:
    rcdn -t mac
    git pull
    RCRC=~/.dotfiles/rcrc rcup -t mac

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./bin/find-broken-symlinks {{args}}

# Default recipe - show available recipes
default:
    @just --list

# Format all known file types
fmt:
    stylua .
    fd -e fish --hidden --exclude .git -X fish_indent --write
    shfmt --write $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts ./.githooks)
    prettier --write '**/*.json' '**/*.md'

# Check formatting without modifying files
fmt-check:
    stylua --check .
    fd -e fish --hidden --exclude .git -X fish_indent --check
    shfmt --diff $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts ./.githooks)
    prettier --check '**/*.json' '**/*.md' >/dev/null

# Run linters
lint:
    fish --no-execute $(fd -e fish --hidden --exclude .git)
    shellcheck $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts ./.githooks)
    typos

# Run format check and lint
check: fmt-check lint

# Diff the vendored ponytail ruleset against upstream main
ponytail-diff:
    @tmp=$(mktemp "${TMPDIR:-/tmp}/ponytail-XXXXXX"); \
        curl -fsS -H "Accept: application/vnd.github.raw" \
            "https://api.github.com/repos/DietrichGebert/ponytail/contents/skills/ponytail/SKILL.md?ref=main" > "$tmp" \
            || { rm -f "$tmp"; echo "ponytail-diff: upstream fetch failed" >&2; exit 2; }; \
        diff -u claude/skills/ponytail/SKILL.md "$tmp" && echo "up to date"; \
        rc=$?; rm -f "$tmp"; exit $rc

# Re-vendor the Tokyo Night palettes (kitty, ghostty, fish) from upstream main; review with git diff
tokyonight-vendor:
    @for pair in \
        kitty/tokyonight_day.conf:config/kitty/light-theme.auto.conf \
        kitty/tokyonight_moon.conf:config/kitty/dark-theme.auto.conf \
        ghostty/tokyonight_day:config/ghostty/themes/tokyonight-day \
        ghostty/tokyonight_moon:config/ghostty/themes/tokyonight-moon \
        fish/tokyonight_day.fish:config/fish/themes/tokyonight_day.fish \
        fish/tokyonight_moon.fish:config/fish/themes/tokyonight_moon.fish; do \
        tmp=$(mktemp "${TMPDIR:-/tmp}/tokyonight-XXXXXX"); \
        curl -fsS -H "Accept: application/vnd.github.raw" \
            "https://api.github.com/repos/folke/tokyonight.nvim/contents/extras/${pair%%:*}?ref=main" \
            -o "$tmp" \
            || { rm -f "$tmp"; echo "tokyonight-vendor: fetch failed for ${pair%%:*}" >&2; exit 2; }; \
        chmod 644 "$tmp"; mv "$tmp" "${pair#*:}"; \
    done; git status --short config/kitty config/ghostty/themes config/fish/themes

# Test the PreToolUse hooks (secret-path guard, config-docs advisory, commit-alone nudge)
test-claude-hooks:
    @echo "Testing guard hook..."
    bash rcignore/test_guard.sh
    @echo "Testing config-docs hook..."
    bash rcignore/test_config_docs.sh
    @echo "Testing commit-alone hook..."
    bash rcignore/test_commit_alone.sh

# Test that configs load without errors
test: test-claude-hooks
    @echo "Testing nvim plugins..."
    nvim --headless +"luafile rcignore/test_plugins.lua"
    @echo "Testing fish config..."
    fish -c 'exit'
    @echo "Testing fish interactive startup (a failed source does not change the exit status)..."
    err=$(fish -i -c exit 2>&1 >/dev/null); test -z "$err" || { printf '%s\n' "$err" >&2; exit 1; }
    @echo "Testing kitty notification internals..."
    if command -v kitty >/dev/null; then kitty +runpy 'import sys; from kitty.notifications import NotificationCommand, NotificationManager; m = NotificationManager(); (isinstance(m.in_progress_notification_commands, dict) and callable(m.close_notification) and hasattr(NotificationCommand, "channel_id")) or sys.exit("kitty notification internals changed; see config/kitty/close-notifications-on-focus.py")'; fi
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

    @echo 'test:'
    just test

    @echo 'Available macOS updates:'
    sudo softwareupdate -l

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

# Browse every kitty option, generated from the installed kitty
kitty-defaults:
    kitty +runpy 'from kitty.config import commented_out_default_config as c; print(c(), end="")' \
        | nvim -R -c 'setfiletype kitty' -

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./scripts/find-broken-symlinks {{args}}

# List all inline TODO/FIXME/HACK comments
todos:
    rg 'TODO|FIXME|HACK' --glob '!lazy-lock.json' --glob '!BACKLOG.md'

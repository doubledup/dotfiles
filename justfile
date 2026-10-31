# Default recipe - show available recipes
default:
    @just --list

# Format all known file types
fmt:
    stylua .
    fd -e fish --hidden --exclude .git -X fish_indent --write
    shfmt --write $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts ./.githooks)
    prettier --write '**/*.css' '**/*.json' '**/*.md'

# Check formatting without modifying files
fmt-check:
    stylua --check .
    fd -e fish --hidden --exclude .git -X fish_indent --check
    shfmt --diff $(fd -e sh --hidden --exclude .git) $(shfmt -f ./scripts ./.githooks)
    prettier --check '**/*.css' '**/*.json' '**/*.md' >/dev/null

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

# Upstream commits the Catppuccin ports are vendored from; bump one, then run catppuccin-vendor
catppuccin_kitty := "43098316202b84d6a71f71aaf8360f102f4d3f1a"
catppuccin_delta := "011516f5d14f66b771b3e716f29c77231e008c74"

# Re-vendor the Catppuccin ports (kitty, delta) at their pinned commits; review with git diff
catppuccin-vendor:
    @for pair in \
        kitty@{{ catppuccin_kitty }}/themes/latte.conf:config/kitty/catppuccin-latte.conf \
        kitty@{{ catppuccin_kitty }}/themes/mocha.conf:config/kitty/catppuccin-mocha.conf \
        delta@{{ catppuccin_delta }}/catppuccin.gitconfig:config/delta/catppuccin.gitconfig; do \
        src=${pair%%:*}; ref=${src#*@}; \
        tmp=$(mktemp "${TMPDIR:-/tmp}/catppuccin-XXXXXX"); \
        curl -fsS -H "Accept: application/vnd.github.raw" \
            "https://api.github.com/repos/catppuccin/${src%%@*}/contents/${ref#*/}?ref=${ref%%/*}" \
            -o "$tmp" \
            || { rm -f "$tmp"; echo "catppuccin-vendor: fetch failed for $src" >&2; exit 2; }; \
        chmod 644 "$tmp"; mv "$tmp" "${pair#*:}"; \
    done; git status --short config/kitty config/delta

# Test that configs load without errors
test:
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
        cargo-machete \
        cargo-outdated \
        cargo-show-asm \
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

# Pull dotfile updates, then apply them; stops before changing anything if the pull is not safe
sync:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "$(git rev-parse --show-toplevel)" != "$(cd ~/.dotfiles && pwd -P)" ]; then
        echo "sync: run from the main checkout at ~/.dotfiles, not a worktree" >&2
        exit 1
    fi
    if [ "$(git symbolic-ref --short -q HEAD)" != main ]; then
        echo "sync: check out main first" >&2
        exit 1
    fi
    git pull --ff-only || { echo "sync: pull failed, nothing applied" >&2; exit 1; }
    # A fresh process, so a pulled change to the recipe applies on this run
    exec just _sync-apply

# Re-link, sync packages and plugins, clear bat's cache, triage orphan brews; safe to rerun
_sync-apply:
    #!/usr/bin/env bash
    set -uo pipefail
    # Explicit, so a clashing or missing ~/.rcrc cannot change what rcup and lsrc read
    export RCRC="$HOME/.dotfiles/rcrc"
    failed=()
    step() {
        local name=$1
        shift
        echo "==> $name"
        "$@" || failed+=("$name")
    }
    # rcup exits 0 after a skipped prompt, so compare the result with what rcm manages
    check_links() {
        local dest src kind rc=0
        while IFS=: read -r dest src kind; do
            if [ "$kind" = X ]; then
                cmp -s "$src" "$dest" || { echo "differs from repo: $dest" >&2; rc=1; }
            elif [ "$(readlink "$dest")" != "$src" ]; then
                echo "not linked: $dest" >&2
                rc=1
            fi
        done < <(lsrc -t mac -F)
        return $rc
    }
    # The final cq means a thrown Lua error exits nonzero too; only a clean run reaches qa
    restore_plugins() {
        nvim --headless -c "lua require('lazy').restore({ wait = true }); \
            for _, p in ipairs(require('lazy').plugins()) do \
                if require('lazy.core.plugin').has_errors(p) then return end \
            end; vim.cmd('qa')" -c cq
    }
    step "git hooks" git config core.hooksPath .githooks
    step "rcup" rcup -t mac
    step "check links" check_links
    step "prune links" ./scripts/find-broken-symlinks --remove --into "$HOME/.dotfiles"
    step "brew cleanup" just brew-cleanup
    step "brew bundle" brew bundle --no-upgrade --global
    step "bat cache" bat cache --clear
    step "nvim plugins" restore_plugins
    echo
    # Steps here can edit tracked files (Brewfile, the lazy lock file); commit them before the next sync
    git status --short
    if [ ${#failed[@]} -gt 0 ]; then
        printf 'sync: failed: %s\n' "${failed[@]}" >&2
        exit 1
    fi

# Detect and triage brew packages not tracked in Brewfile
brew-cleanup:
    ./scripts/brew-cleanup

# Browse every kitty option, generated from the installed kitty
kitty-defaults:
    kitty +runpy 'from kitty.config import commented_out_default_config as c; print(c(), end="")' \
        | nvim -R -c 'setfiletype kitty' -

# Find broken symlinks in home directory (use --remove to delete them)
broken-links *args:
    ./scripts/find-broken-symlinks {{args}}

# List all inline TODO/FIXME/HACK comments
todos:
    rg 'TODO|FIXME|HACK' --glob '!lazy-lock.json'

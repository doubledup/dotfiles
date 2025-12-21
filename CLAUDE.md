# Dotfiles Project

Personal dotfiles repository managed with [rcm](https://github.com/thoughtbot/rcm).

## Development Philosophy

Core principles that guide all decisions in this repository:

**Simplicity over cleverness:**

- Aim for narrow interfaces with deep implementations
- Prefer simple, clear code over complex abstractions, even if the code is more verbose
- Minimize configuration - use defaults wherever possible
- Lower complexity even if initially more difficult or verbose

**Conservative tool choices:**

- Prefer well-tested tools with larger communities and longer track records
- Avoid introducing new tools/languages unless necessary
- Favor terminal/CLI programs over GUI applications

**Keyboard-first workflow:**

- Prioritize keyboard shortcuts and terminal workflows
- Avoid mouse-dependent tools and interfaces

**When evaluating new additions:**

1. Can existing tools handle this?
2. Does this add unnecessary complexity?
3. Is this tool mature and widely adopted?
4. Will this work in a terminal/CLI environment?

## Project Structure

Key structure (omits auto-generated files and some config files):

```
.dotfiles/
├── config/           # XDG config files (~/.config/)
│   ├── fish/         # Fish shell config
│   │   ├── config.fish      # Main config
│   │   ├── conf.d/          # Auto-loaded configs (aliases, git, fzf, keybindings, theme)
│   │   └── functions/       # Custom functions (cheat, extract, killport, port, weather)
│   ├── nvim/         # Main neovim config
│   ├── nvim-kickstart/  # Kickstart nvim setup
│   ├── nvim-golf/    # Golf nvim setup
│   ├── kitty/        # Kitty terminal config
│   ├── ghostty/      # Ghostty terminal config
│   ├── bat/          # bat (cat replacement) config
│   └── nix/          # Nix config
├── tag-mac/          # macOS-specific configs (same structure as root)
├── tag-linux/        # Linux-specific configs (same structure as root)
├── local/bin/        # User scripts (dns-clear, ghostty-config, mksshkey)
├── scripts/          # Repo-internal scripts (find-broken-symlinks)
├── ssh/              # SSH configuration
├── Brewfile          # Homebrew packages
├── justfile          # Task runner recipes
├── rcrc              # rcm configuration
├── gitconfig         # Git configuration
├── editorconfig      # Editor configuration
└── CLAUDE.local.md   # Machine-specific Claude instructions (not checked in)
```

Note: Formatter/linter configs (`.prettierrc.json`, `stylua.toml`, `_typos.toml`) are also at the root level.

**How rcm symlinks files:**

- `config/` → `~/.config/`
- Root dotfiles (gitconfig, editorconfig) → `~/` (prefixed with `.`)
- `tag-{os}/config/` → `~/.config/` (OS-specific overrides)
- Files in EXCLUDES (rcrc) are never symlinked

**CLAUDE.local.md setup:**

This file should exist and specify the primary platform. Create it with:

```markdown
# Local Claude Instructions

## Current Machine Context

- Primary platform: macOS (Darwin)
- Default rcm tag: mac
```

Replace "macOS (Darwin)" and "mac" with your platform (e.g., "Linux (Debian)" and "linux").

## Repository Context

**Primary languages:** Lua, Fish, Bash/Shell, JSON, Markdown (run `tokei` for current stats)

**Main focus:** Configuration files for neovim, fish shell, terminal emulators, and system tools

**Auto-generated files (do not modify):**

- `Session.vim` - Vim session file
- `config/fish/fish_variables` - Fish shell state
- `.jdtls/` - Java language server cache

## Key Conventions

### File Organization

- Prefer editing existing files over creating new ones
- Use 4-space indentation for all files (configured in editorconfig and prettierrc)
- Local overrides: add `.local` before extension (e.g., `config.local.fish`)
    - Fish: `~/.config/fish/config.local.fish`
    - Kitty: `~/.config/kitty/kitty.local.conf`
    - Neovim: `~/.config/nvim/lua/config/local.lua`
- OS-specific: use `tag-mac/` or `tag-linux/` directories
    - Fish: `tag-mac/config/fish/config.os.fish`
    - Files named `*.os.*` are sourced after main config
- Pure Lua for neovim config (no vimscript)
- Avoid non-ASCII characters and ligatures; use plain symbols (e.g., `->` not `→`). Exception: intentional visual elements like vim listchars or UI indicators.

### Multiple Neovim Configurations

Three neovim configs are available:

- `nvim` - Main daily-driver config
- `nvim-kickstart` - Kickstart.nvim setup (use `vk` alias or `NVIM_APPNAME=nvim-kickstart nvim`)
- `nvim-golf` - Minimal golf setup (use `vg` alias or `NVIM_APPNAME=nvim-golf nvim`)

To try configs without side effects, use `nvim!` alias or `nvim -u NONE` (no config at all)

### Neovim Plugin Organization

Plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

**Simple plugins** (keep in `config/nvim/lua/plugins/init.lua`):

- 20 lines or fewer
- Basic opts/config, no custom functions

```lua
-- Minimal: just the plugin name
"tpope/vim-repeat",

-- With opts
{ "smoka7/hop.nvim", opts = {} },

-- With lazy loading
{ "tpope/vim-unimpaired", event = "VeryLazy" },

-- With keymaps (under ~20 lines total)
{
    "tpope/vim-obsession",
    keys = {
        { "<leader>st", ":Obsession<cr>", desc = "Start session tracking" },
        { "<leader>sl", ":source Session.vim<cr>", desc = "Load session" },
    },
},
```

**Complex plugins** (separate files in `config/nvim/lua/plugins/`):

- More than 20 lines
- Custom functions or complex setup
- Multiple related plugins

See `config/nvim/lua/plugins/conform.lua`, `config/nvim/lua/plugins/lspconfig.lua` for examples.

### Fish Abbreviations

Pattern: first letter of tool name as prefix.

**Note:** These abbreviations are defined in fish shell config. Claude does not use fish, so these are not available when Claude runs commands. This section is for user reference only.

```fish
# homebrew -> b
abbr b brew
abbr bb brew bundle
abbr bi brew install

# cargo -> c
abbr c cargo

# git -> g (defined in conf.d/git.fish)
abbr g git
abbr gst 'git status'
abbr gc 'git commit -v'
```

## Formatters and Linters

Run `tokei` to see current language stats.

| Filetype   | Formatter   | Linter              |
| ---------- | ----------- | ------------------- |
| Lua        | stylua      | lua-language-server |
| Fish       | fish_indent | fish-lsp            |
| Shell/Bash | shfmt       | shellcheck          |
| JSON       | prettier    | -                   |
| Markdown   | prettier    | -                   |
| Spelling   | -           | typos               |

## Quick Reference

### Justfile Recipes

Run `just` (with no arguments) to see all available recipes. Key recipes:

```sh
just check        # Run linters and format checks (run before committing)
just fmt          # Format all code
just test         # Test that configs load without errors
just sync         # Pull dotfile updates and re-link (rcdn, git pull, rcup)
just update       # Update all packages (brew, cargo, nvim, mas, system)
just broken-links # Find broken symlinks (--remove to delete them)
```

**Note:** Keep this list in sync with the justfile when adding/removing recipes.

### Common Commands

Use the rcm tag from CLAUDE.local.md (e.g., `-t mac` for macOS, `-t linux` for Linux).

```sh
# Symlink management
rcup -t {tag}     # Apply symlinks from dotfiles to home directory

# Switch nvim configs
vk                # Use nvim-kickstart (or: NVIM_APPNAME=nvim-kickstart nvim)
vg                # Use nvim-golf (or: NVIM_APPNAME=nvim-golf nvim)
nvim!             # nvim with no config (or: nvim -u NONE)
```

### Utility Scripts

**User scripts** (`local/bin/`, available in PATH):

- `dns-clear` - Clear macOS DNS cache (macOS only)
- `ghostty-config` - Open ghostty config in editor
- `mksshkey` - Create SSH keys for the current machine

**Repo scripts** (`scripts/`, for internal use):

- `find-broken-symlinks` - Find and optionally remove broken symlinks
    - Usage: `./scripts/find-broken-symlinks [--remove] [directory]`
    - Default directory: `$HOME`
    - Also available as `just broken-links`

## Workflow Guidelines

Use the rcm tag from CLAUDE.local.md (e.g., `-t mac` for macOS, `-t linux` for Linux) in commands below.

**Before committing:**

- Run `just check` to verify formatting and linting (most critical step)
    - If formatting errors occur, fix with `just fmt`
    - Handle linting errors case-by-case
- When changing fish or neovim files, also run `just test` to verify configs load
- Verify symlinks work: `rcup -t {tag}` to test that symlinks apply correctly

**During development:**

- Test experimental changes in `.local` files first (e.g., `config.local.fish`) before modifying shared configs
- Use git stash before major configuration changes

**File-specific conventions:**

- Add new Homebrew packages to Brewfile instead of running `brew install` directly
- When modifying Brewfile, keep each section (tap, brew, cask, mas) sorted alphabetically
- When updating justfile recipes, remember to update the Quick Reference section in CLAUDE.md
- Neovim plugins: look up READMEs at `https://github.com/{user}/{repo}`

**Removing files:**

When removing a file from dotfiles that's currently symlinked:

1. Remove the file from dotfiles
2. Run `just broken-links --remove` to clean up the now-broken symlink (rcdn won't work since it can't see deleted files)

When adding new files to dotfiles that shouldn't be symlinked, add them to EXCLUDES in rcrc

**General philosophy:**

- Prefer minimal, focused changes over comprehensive refactors

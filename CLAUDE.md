# Dotfiles Project

Personal dotfiles repository managed with [rcm](https://github.com/thoughtbot/rcm).

## Project Structure

```
.dotfiles/
├── config/           # XDG config files (~/.config/)
│   ├── fish/         # Fish shell config
│   ├── nvim/         # Main neovim config
│   ├── nvim-kickstart/  # Kickstart nvim setup
│   └── ...
├── tag-mac/          # macOS-specific configs
├── tag-linux/        # Linux-specific configs
├── local/bin/        # Executables for daily use
├── bin/              # Repo-internal scripts
├── Brewfile          # Homebrew packages
└── rcrc              # rcm configuration
```

## Key Conventions

### File Organization

- Prefer editing existing files over creating new ones
- Local overrides: add `.local` before extension (e.g., `config.local.fish`)
- OS-specific: use `tag-mac/` or `tag-linux/` directories
- Pure Lua for neovim config (no vimscript)
- Avoid non-ASCII characters and ligatures; use plain symbols (e.g., `->` not `→`). Exception: intentional visual elements like vim listchars or UI indicators.

### Neovim Plugin Organization

**Simple plugins** (keep in `lua/plugins/init.lua`):

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

**Complex plugins** (separate files in `lua/plugins/`):

- More than 20 lines
- Custom functions or complex setup
- Multiple related plugins

See `lua/plugins/conform.lua`, `lua/plugins/lspconfig.lua` for examples.

### Fish Abbreviations

Pattern: first letter of tool name as prefix.

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

## Common Commands

```sh
# Test symlink changes
rcup -t mac

# Update packages
brew bundle --global --cleanup

# Switch nvim configs
NVIM_APPNAME=nvim-kickstart nvim   # or use 'vk' alias

# Pull dotfile updates
rcdn -t mac && git pull && RCRC=~/.dotfiles/rcrc rcup -t mac

# Find broken symlinks
find ~ -type l ! -exec test -e {} \; -print | rg -v '/Library/' | rg -v '/.cache/'
```

## Workflow Guidelines

- Test experimental changes in `.local` files first
- Use git stash before major configuration changes
- Verify symlinks work before committing
- Neovim plugins: look up READMEs at `https://github.com/{user}/{repo}`
- Prefer minimal, focused changes over comprehensive refactors

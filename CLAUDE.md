# Dotfiles

Dotfiles managed with rcm. See @DESIGN.md for architectural decisions.

## rcm Behavior

- `config/` -> `~/.config/`, root files -> `~/.` prefixed
- `tag-mac/` and `tag-linux/` for OS-specific overrides
- Files in EXCLUDES (rcrc) are not symlinked
- IMPORTANT: rcm ignores dotfiles in subdirectories
    - Workaround: store as `foo.json`, create repo symlink `.foo.json -> foo.json`
- `claude/` -> `~/.claude/` (rcm-managed, version-controlled settings/commands/agents)
- `.claude/` (repo root) -> project-level config (`settings.local.json`), not managed by rcm

## Conventions

File patterns:

- Local overrides: `.local` before extension (e.g., `config.local.fish`)
- OS-specific: `tag-{os}/` directory with `.os` in filename

Neovim:

- Pure Lua only (no vimscript)
- Plugins <=20 lines: keep in `plugins/init.lua`
- Plugins >20 lines: separate file in `plugins/`, named after the plugin repo (e.g., `nvim-lint.lua` for `mfussenegger/nvim-lint`)
- Plugin docs: https://github.com/{user}/{repo}

Style:

- No non-ASCII characters (exception: intentional UI elements like listchars)

## Workflow

Before committing:

- Run `just check` (required - handles formatting and linting)
- Run `just test` if fish or neovim files changed
- Warnings in `just check` or `just test` output should be resolved; add a backlog item if not fixable immediately

Decisions:

- Document new architectural decisions in DESIGN.md

Backlog:

- Read BACKLOG.md at the start of each session; suggest the highest-priority item
- When a session produces follow-up work, add it to BACKLOG.md before ending
- Remove completed items (don't check them off; git history records completion)
- Run `just todos` periodically to find inline TODOs worth promoting to the backlog
- If BACKLOG.md grows past ~100 items, split into a `backlog/` directory

Verification:

- For UI-affecting changes (keymaps, LSP, statusline, shell), include a "Verify" section in the session plan with specific manual checks, e.g.:
    - "Open a .rs file, save, confirm clippy diagnostics appear"
    - "Press `<leader>f`, confirm fzf opens"

File operations:

- Add packages to Brewfile (keep sections sorted alphabetically)
- New excluded files: add to EXCLUDES in rcrc
- New files in `~/`: run `mkrc <file>` (or `mkrc -t mac <file>` for OS-specific) to move into this repo and create symlink
- New files in repo: run `rcup` to create symlinks in `~/`
- Removing symlinked files: delete file, then `just broken-links --remove`

## Do Not Modify

Auto-generated: Session.vim, config/fish/fish_variables, .jdtls/

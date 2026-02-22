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
- Plugins >20 lines: separate file in `plugins/`
- Plugin docs: https://github.com/{user}/{repo}

Style:

- No non-ASCII characters (exception: intentional UI elements like listchars)

## Workflow

Before committing:

- Run `just check` (required - handles formatting and linting)
- Run `just test` if fish or neovim files changed

File operations:

- Add packages to Brewfile (keep sections sorted alphabetically)
- New excluded files: add to EXCLUDES in rcrc
- New files in `~/`: run `mkrc <file>` (or `mkrc -t mac <file>` for OS-specific) to move into this repo and create symlink
- New files in repo: run `rcup` to create symlinks in `~/`
- Removing symlinked files: delete file, then `just broken-links --remove`

## Do Not Modify

Auto-generated: Session.vim, config/fish/fish_variables, .jdtls/

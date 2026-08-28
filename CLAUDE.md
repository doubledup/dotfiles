# Dotfiles

Dotfiles managed with rcm. `DESIGN.md` records architectural decisions; read it on demand
(deliberately not @-imported). Standing policy: sandbox-first containment (must-nevers live in deny
rules; hooks only where the sandbox and rules cannot reach); no secrets in any repo, even
git-ignored.

## Conventions

File patterns:

- Local overrides: `.local` before extension (e.g., `config.local.fish`)
- OS-specific: `tag-{os}/` directory with `.os` in filename

Style:

- No non-ASCII characters (exceptions: intentional UI elements like listchars; vendored third-party
  text, which must stay byte-identical to upstream - see `claude/skills/ponytail/VENDOR.md`)

## Workflow

Before committing:

- Run `just check` (required - handles formatting and linting)
- Run `just test` if fish or neovim files changed
- Warnings in `just check` or `just test` output should be resolved; add a backlog item if not
  fixable immediately

Decisions:

- Document new architectural decisions in DESIGN.md

Backlog:

- Read BACKLOG.md at the start of each session; suggest the highest-priority item
- When a session produces follow-up work, add it to BACKLOG.md before ending
- Remove completed items (don't check them off; git history records completion)
- Run `just todos` periodically to find inline TODOs worth promoting to the backlog
- If BACKLOG.md grows past ~100 items, split into a `backlog/` directory
- When you observe workflow friction during a session (slow patterns, missing context, repeated
  manual steps), add it to BACKLOG.md. Don't interrupt the current task to investigate.

Verification:

- For UI-affecting changes (keymaps, LSP, statusline, shell), include a "Verify" section in the
  session plan with specific manual checks, e.g.:
    - "Open a .rs file, save, confirm clippy diagnostics appear"
    - "Press `<leader>f`, confirm fzf opens"

File operations:

- Add packages to Brewfile (keep sections sorted alphabetically)
- New excluded files: add to EXCLUDES in rcrc
- New files in `~/`: run `mkrc <file>` (or `mkrc -t mac <file>` for OS-specific) to move into this
  repo and create symlink
- New files in repo: run `rcup` to create symlinks in `~/`
- Removing symlinked files: delete file, then `just broken-links --remove`

## Do Not Modify

Auto-generated: Session.vim, config/fish/fish_variables, .jdtls/

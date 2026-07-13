# rcm in this repo

How this repo (`~/.dotfiles`) uses the rcm dotfile manager: its directory model,
tags, excludes, and update workflow. Command/flag syntax is included where this repo
actually relies on it; for anything not covered here, consult the man pages
(`rcm(7)`, `mkrc(1)`, `rcup(1)`, `rcdn(1)`, `lsrc(1)`, `rcrc(5)`).

## Directory model

- `config/` -> `~/.config/`, root files -> `~/.`-prefixed (e.g. `zshrc` -> `~/.zshrc`,
  `gitconfig` -> `~/.gitconfig`).
- `claude/` -> `~/.claude/` (rcm-managed, version-controlled Claude Code
  settings/commands/agents/rules). The repo-root `.claude/` (`settings.json`,
  `hooks/`, `rules/`) is a separate, non-rcm-managed directory for project-local
  config.
- Other top-level dirs map the same way: `codex/` -> `~/.codex/`, `local/` ->
  `~/.local/`, `ssh/` -> `~/.ssh/`. `Library/` is a likely exception (macOS expects
  `~/Library`, not `~/.Library`); unconfirmed how it actually resolves, worth
  checking before relying on it.
- `tag-mac/` and `tag-linux/` hold OS-specific overrides, included via `rcup -t <tag>`.
  `just sync` always passes `-t mac`; there is currently no equivalent automated sync
  path for `tag-linux`, Linux machines need a manual `rcup -t linux`.
- rcm ignores dotfiles in subdirectories (a nested dotted filename, e.g. a literal
  `config/nvim/.luarc.json`, would be silently skipped and never symlinked). This
  repo doesn't currently have a real case needing that worked around: the one
  repo-root dotted symlink that looks similar, `.luarc.json -> config/nvim/luarc.json`,
  isn't an rcm propagation trick, it's an unrelated convenience so lua_ls finds a
  `.luarc.json` when editing this repo itself, `~/.luarc.json` doesn't exist in
  `$HOME`. If a real nested-dotfile case comes up, keep the source file undotted so
  rcm's directory descent still picks it up.

## Excludes and copy-always

- `EXCLUDES` (in `rcrc`) lists repo-management files that should never be symlinked
  into `$HOME` (docs, the justfile, lint configs, etc.); see `rcrc` for the current
  list rather than duplicating it here, it changes as the repo grows.
- `COPY_ALWAYS` (in `rcrc`) currently holds `config/karabiner/karabiner.json`, copied
  into place instead of symlinked. Likely because Karabiner-Elements rewrites its
  config file in place rather than editing through a symlink; a symlink there would
  risk being replaced outright.

## Update workflow (`just sync`)

```bash
rcdn -t mac                      # remove existing rcm-managed symlinks (mac tag)
git pull                         # bring in the latest repo changes
RCRC=~/.dotfiles/rcrc rcup -t mac  # re-link with the mac tag
brew bundle --no-upgrade --global
nvim -c "lua require('lazy').restore()"
just brew-cleanup                # triage brew packages not tracked in Brewfile
```

- The explicit `RCRC=~/.dotfiles/rcrc` on the `rcup` step is required: `rcrc` itself
  is a normal rcm-managed root file (symlinked to `~/.rcrc`), so the preceding `rcdn`
  removes `~/.rcrc` along with everything else. Without the override, the following
  `rcup` would have no `rcrc` to read.
- `just broken-links` (`./scripts/find-broken-symlinks`, `--remove` to delete) finds
  dangling symlinks left in `$HOME`, e.g. after removing a file this repo used to
  manage.
- Sanity-check before a broad relink: `lsrc` dry-runs what rcm would manage without
  changing anything.

## Command reference used here

```bash
lsrc                 # dry-run: list every file rcm would manage
mkrc ~/.tigrc         # move a file into the dotfiles dir and replace it with a symlink
mkrc -t mac ~/.zshrc.local   # same, but into tag-mac/ for an OS-specific override
rcup -v -t mac        # sync $HOME with the dotfiles dir (create/update symlinks)
rcdn -v -t mac        # remove the symlinks rcm created
```

- `mkrc -t <tag>` is this repo's only `mkrc` flag in regular use (OS-specific files
  via `tag-mac`/`tag-linux`); host-specific (`-o`/`-B`) and undotted (`-U`) mkrc modes
  aren't used here.
- `rcup`/`rcdn` are always run with `-t mac` (or `-t linux`) to include the relevant
  tag directory; `-v` for verbose output when troubleshooting.
- `SYMLINK_DIRS`, `UNDOTTED`, and `HOSTNAME` (all `rcrc(5)` variables) aren't set in
  this repo's `rcrc` and don't apply to anything here.

## Gotchas

- `install` / `Makefile` / `Rakefile` at the repo root would become stray `~/.install`
  etc. symlinks if ever added; exclude them via `EXCLUDES` in `rcrc` before adding one.
- Dotted source filenames are silently skipped by rcm anywhere but the repo root, see
  "Directory model" above if a nested dotfile ever needs to reach `$HOME`.

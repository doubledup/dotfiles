# rcm in this repo

How this repo (`~/.dotfiles`) uses the rcm dotfile manager: its directory model, tags, excludes, and
update workflow. Command/flag syntax is included where this repo actually relies on it; for anything
not covered here, consult the man pages (`rcm(7)`, `mkrc(1)`, `rcup(1)`, `rcdn(1)`, `lsrc(1)`,
`rcrc(5)`).

## Directory model

- `config/` -> `~/.config/`, root files -> `~/.`-prefixed (e.g. `zshrc` -> `~/.zshrc`, `gitconfig`
  -> `~/.gitconfig`).
- `claude/` -> `~/.claude/` (rcm-managed, version-controlled Claude Code
  settings/commands/agents/rules). The repo-root `.claude/` is a separate, non-rcm-managed directory
  for project-local config.
- Other top-level dirs map the same way: `codex/` -> `~/.codex/`, `local/` -> `~/.local/`, `ssh/` ->
  `~/.ssh/`. `Library/` is a likely exception (macOS expects `~/Library`, not `~/.Library`);
  unconfirmed how it actually resolves, worth checking before relying on it.
- `tag-mac/` and `tag-linux/` hold OS-specific overrides, included via `rcup -t <tag>`. `just sync`
  always passes `-t mac`; there is currently no equivalent automated sync path for `tag-linux`,
  Linux machines need a manual `rcup -t linux`.
- rcm ignores dotfiles in subdirectories (a nested dotted filename, e.g. a literal
  `config/nvim/.luarc.json`, would be silently skipped and never symlinked). This repo doesn't
  currently have a real case needing that worked around: the one repo-root dotted symlink that looks
  similar, `.luarc.json -> config/nvim/luarc.json`, isn't an rcm propagation trick, it's an
  unrelated convenience so lua_ls finds a `.luarc.json` when editing this repo itself,
  `~/.luarc.json` doesn't exist in `$HOME`. If a real nested-dotfile case comes up, keep the source
  file undotted so rcm's directory descent still picks it up.

## Excludes and copy-always

- `EXCLUDES` (in `rcrc`) lists repo-management files that should never be symlinked into `$HOME`
  (docs, the justfile, lint configs, etc.); see `rcrc` for the current list rather than duplicating
  it here, it changes as the repo grows.
- `COPY_ALWAYS` (in `rcrc`) currently holds `config/karabiner/karabiner.json`, copied into place
  instead of symlinked, because Karabiner-Elements does not work with a symlinked config: it
  rewrites the file on save, replacing a symlink with a regular file. Run `rcup` after each change
  to it in the repo; until then Karabiner keeps using the old copy.

## Update workflow (`just sync`)

`just sync` stops before changing anything unless it is in the main checkout on `main` and
`git pull --ff-only` succeeds. It then runs every step, lists failures at the end and exits nonzero,
so the fix for a failure is to run it again. Steps: set `core.hooksPath`, `rcup -t mac`, check the
links, prune broken links into this repo, `just brew-cleanup`, `brew bundle --no-upgrade --global`,
`bat cache --clear`, headless lazy.nvim restore. It prints `git status` last, because the Brewfile
and lazy lock file can change; an uncommitted change that overlaps a later pull stops that sync.

Behaviour this relies on (measured on a throwaway `$HOME`):

- `rcup` prompts on a clashing real file or a drifted `COPY_ALWAYS` copy, and exits 0 if the answer
  is `n` or stdin is closed. The link check against `lsrc -t mac -F` is what reports these. `-f`
  would overwrite local edits.
- `rcup` never removes links to files deleted upstream. Pruning only removes broken links, not links
  missing from `lsrc`, because `EXCLUDES` matches basenames at any depth and so omits the needed
  `~/.claude/CLAUDE.md`.
- `rcdn` deletes `COPY_ALWAYS` copies, and a failed pull after it would leave `$HOME` unlinked, so
  `just sync` does not use it.
- `RCRC=~/.dotfiles/rcrc` stays explicit so a clashing or missing `~/.rcrc` cannot change what
  `rcup` and `lsrc` read.
- `just broken-links` (`./scripts/find-broken-symlinks`, `--remove` to delete, `--into DIR` to limit
  to links targeting `DIR`) finds dangling symlinks left in `$HOME`, e.g. after removing a file this
  repo used to manage.
- Sanity-check before a broad relink: `lsrc` dry-runs what rcm would manage without changing
  anything.

## Command reference used here

```bash
lsrc                 # dry-run: list every file rcm would manage
mkrc ~/.tigrc         # move a file into the dotfiles dir and replace it with a symlink
mkrc -t mac ~/.zshrc.local   # same, but into tag-mac/ for an OS-specific override
rcup -v -t mac        # sync $HOME with the dotfiles dir (create/update symlinks)
rcdn -v -t mac        # remove the symlinks rcm created
```

- `mkrc -t <tag>` is this repo's only `mkrc` flag in regular use (OS-specific files via
  `tag-mac`/`tag-linux`); host-specific (`-o`/`-B`) and undotted (`-U`) mkrc modes aren't used here.
- `rcup`/`rcdn` are always run with `-t mac` (or `-t linux`) to include the relevant tag directory;
  `-v` for verbose output when troubleshooting.
- `SYMLINK_DIRS` in `rcrc` links each skill under `claude/skills/` as a whole directory. `UNDOTTED`
  and `HOSTNAME` (also `rcrc(5)` variables) aren't set and don't apply to anything here.

## Gotchas

- `install` / `Makefile` / `Rakefile` at the repo root would become stray `~/.install` etc. symlinks
  if ever added; exclude them via `EXCLUDES` in `rcrc` before adding one.
- Dotted source filenames are silently skipped by rcm anywhere but the repo root, see "Directory
  model" above if a nested dotfile ever needs to reach `$HOME`.

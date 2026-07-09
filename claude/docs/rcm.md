# rcm Command Reference

General command reference for the rcm dotfile manager (distilled from `rcm(7)` /
`rcrc(5)`). This repo's own mappings, tags, `EXCLUDES`, and update workflow live in the
repo `CLAUDE.md` (`## rcm Behavior`) and the `justfile` (`sync`); this doc is the general
command cheat-sheet and does not duplicate them.

## Commands

```bash
lsrc                 # dry-run: list every file rcm would manage (run before rcup)
mkrc ~/.tigrc        # move a file into the dotfiles dir and replace it with a symlink
rcup -v              # sync $HOME with the dotfiles dir (create/update symlinks)
rcdn -v              # remove the symlinks rcm created
```

- `mkrc` flags: `-t <tag>` (into `tag-<tag>/`), `-o` (host-specific, by hostname),
  `-B <host>` (override the hostname), `-U` (undotted: no leading dot).
- `rcup` flags: `-v` (verbose), `-t <tag>` (include a tag), `-d <dir>` (source dir,
  repeatable), `-x <pattern>` (exclude), `-B <host>` (hostname), `-g` (print a portable
  install script to stdout instead of running).
- `rcdn` flags: `-v` (verbose).

## Directory model

- Source lives in `~/.dotfiles` by default (override with `-d` or `DOTFILES_DIRS`).
- Destinations are dot-prefixed: `zshrc` -> `~/.zshrc`. Files/dirs in `UNDOTTED` (or via
  `-U`) skip the dot: `bin` -> `~/bin`.
- Tags are `tag-<name>/` subdirs, included with `-t <name>` (or `TAGS`). This repo uses
  `tag-mac/` and `tag-linux/`.
- Multiple source dirs (`-d a -d b`) are processed in order; on overlap the **first**
  match wins.
- Host-specific files: `mkrc -o` (keyed by hostname), `-B <host>` to override.

## Symlink behavior

- By default rcm **descends into directories and symlinks individual files** (real
  directories are created; each file is its own symlink). So a nested source path like
  `claude/docs/rcm.md` links per-file to `~/.claude/docs/rcm.md`.
- `SYMLINK_DIRS` (in `rcrc(5)`) makes matching directories symlinked **as a whole**
  instead of descended.
- Source files whose names begin with a dot are **skipped** by rcm. This is why this
  repo stores such files undotted (e.g. `foo.json`) and adds a repo symlink
  `.foo.json -> foo.json`.

## Gotchas

- `install` / `Makefile` / `Rakefile` in the dotfiles dir become stray `~/.install` etc.
  symlinks; exclude them (`rcup -x install -x Makefile -x Rakefile`, or `EXCLUDES`).
- Dotted source filenames are silently skipped (nothing happens for them).
- macOS hostnames are unstable (can change on a DHCP handshake); set `HOSTNAME` in
  `rcrc` so host-specific files resolve.

## Config file

Variables live in `rcrc(5)` (POSIX shell, sourced by every rcm command), not `rcm(7)`:
`DOTFILES_DIRS`, `TAGS`, `EXCLUDES`, `UNDOTTED`, `SYMLINK_DIRS`, `COPY_ALWAYS`,
`HOSTNAME`.

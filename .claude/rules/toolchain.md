This is an rcm-managed dotfiles repo. Files are symlinked from this repo to $HOME by rcm.
Never modify files via their symlink targets in ~/. All changes happen in this repo.
For rcm command reference (rcup/rcdn/mkrc/lsrc, flags, symlink semantics), see `claude/docs/rcm.md`.

Use `just` recipes for automation. Do not create standalone shell scripts when a justfile
recipe exists or could be added. Check `just --list` before proposing new scripts.

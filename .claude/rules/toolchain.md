This is an rcm-managed dotfiles repo. Files are symlinked from this repo to $HOME by rcm. Never
modify files via their symlink targets in ~/ (Edit/Write refuse to write through symlinks); all
changes happen in this repo. User-scope Claude config lives in `claude/` (rcm-managed, deploys to
`~/.claude/`); repo-local Claude config lives in `.claude/` (not rcm-managed). For rcm command
reference (rcup/rcdn/mkrc/lsrc, flags, symlink semantics), see `claude/docs/rcm.md`.

Use `just` recipes for automation. Do not create standalone shell scripts when a justfile recipe
exists or could be added. Check `just --list` before proposing new scripts.

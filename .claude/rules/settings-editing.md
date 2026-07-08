# Settings Editing

When editing user settings in this dotfiles project, edit files in `./claude/` directly rather than `~/.claude/`. The latter contains symlinks managed by rcm pointing to the repo source, and Claude Code's Edit/Write tools refuse to write through symlinks (they error with "Refusing to write through symlink").

`.claude/` in this directory contains Claude Code config specific to this repo (not managed by rcm, unlike `claude/` at the root).

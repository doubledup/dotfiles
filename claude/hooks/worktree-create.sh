#!/usr/bin/env bash
set -euo pipefail

# WorktreeCreate hook: place worktrees flat as ~/code/worktrees/<repo>__<name>,
# on a new branch <name> off origin/HEAD, instead of under the repo's
# .claude/worktrees. Covers EnterWorktree, `claude --worktree` and subagents with
# `isolation: "worktree"`, whose shell stays pinned to the worktree so a lone
# `git commit` (see commit-alone.sh) runs there. Prints the path on stdout; git's
# output goes to stderr. --no-track because the sandbox can't write .git/config
# later, and this hook runs outside it.

input="$(cat)"
name="$(jq -r '.name // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
[[ "$name" =~ ^[A-Za-z0-9._/-]+$ && "$name" != *..* ]] || {
    echo "bad worktree name: $name" >&2
    exit 1
}

common="$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir)"
repo="$(basename "$(dirname "$common")")"
dir="$HOME/code/worktrees/${repo}__${name//\//-}"

mkdir -p "$HOME/code/worktrees"
git -C "$cwd" worktree add --no-track -b "$name" "$dir" origin/HEAD >&2
echo "$dir"

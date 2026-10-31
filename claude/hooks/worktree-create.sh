#!/usr/bin/env bash
set -euo pipefail

# WorktreeCreate hook: place worktrees flat as ~/code/worktrees/<repo>__<name>,
# on a new branch <name> off the remote's default branch, instead of under the repo's
# .claude/worktrees. Covers EnterWorktree, `claude --worktree` and subagents with
# `isolation: "worktree"`. Prints the path on stdout; git's output goes to
# stderr. --no-track so the new branch doesn't take the default branch as its
# upstream; the first `git push -u origin <name>` sets the real one.

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

# origin/HEAD is set by clone but not by `git remote add`; a repo without a remote
# branches from HEAD, as git's own worktree default does.
base=HEAD
for ref in origin/HEAD origin/main origin/master; do
    if git -C "$cwd" rev-parse -q --verify "$ref^{commit}" >/dev/null; then
        base="$ref"
        break
    fi
done

mkdir -p "$HOME/code/worktrees"
git -C "$cwd" worktree add --no-track -b "$name" "$dir" "$base" >&2
echo "$dir"

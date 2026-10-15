# Git

## Commits

- One concern per commit, grouped by originating finding or task, not by file: a finding's complete
  fix is one commit; a different finding's fix is another, even a one-line one
- Title: imperative, sentence case, no period, 54 characters max, starting with a verb (Add, Remove,
  Bump, Revise, Clean up, Fix, Move, Set up, Update); formatting-only commits: "fmt"
- Body: omit unless the diff needs context; then 1-2 lines on the why, wrapped at 72, in the voice
  of `~/.claude/skills/authored-voice/voice.md`

## Branches and worktrees

- Update a PR branch by merging `main` into it, not rebasing, to avoid force-pushing shared branches
- Worktrees: plain `git worktree` (not `EnterWorktree`, which can't place them outside the repo),
  flat under `~/code/worktrees/<repo>__<branch-with-"/"-as-"-">`. `mkdir -p` it and `/add-dir` it
  once (outside the sandbox write set); branch off local `origin/<default-branch>` (a sandboxed
  `git -C` fetch can't reach SSH), then work from a session launched inside the worktree

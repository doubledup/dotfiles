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
- Worktrees: flat under `~/code/worktrees/<repo>__<branch-with-"/"-as-"-">`, branched off local
  `origin/HEAD` (run a lone `git fetch` first). The `worktree-create.sh` WorktreeCreate hook places
  them there for `EnterWorktree`, `claude --worktree` and subagents; use those, not
  `git worktree add`
- Subagents that commit get `isolation: "worktree"`: it pins their shell to the worktree, so a lone
  `git commit` lands there. Without it, every Bash call starts in the main checkout. Claude Code
  keeps a subagent's worktree; remove it, and its branch, after the merge

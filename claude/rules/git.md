- One concern per commit, grouped by originating finding or task, not by file: a finding's complete
  fix is one commit; a different finding's fix is another, even a one-line one, and so are unrelated
  changes requested together. Check the staged diff for more than one concern before committing
- Title: imperative, sentence case, no period, 54 characters max, starting with a verb (Add, Remove,
  Bump, Revise, Clean up, Fix, Move, Set up, Update); formatting-only commits: "fmt"
- Body: omit unless the diff needs context; then 1-2 lines on the why, wrapped at 72, in the voice
  of `~/.claude/skills/authored-voice/voice.md`
- Update a PR branch by merging `main` into it, not rebasing, to avoid force-pushing shared branches
- Create worktrees with `EnterWorktree`, `claude --worktree` or subagent `isolation: "worktree"`
  (the `worktree-create.sh` hook places them under `~/code/worktrees/`, off the remote default
  branch; run `git fetch` first), never `git worktree add`. Subagents that commit need that
  isolation, which pins their Bash calls to the worktree; without it they start in the main checkout
- Claude Code keeps a subagent's worktree; after the merge, remove it with
  `git worktree remove <path>` (never `--force`, which is denied), `git worktree prune`, then
  `git branch -D <branch>` (squash merges never count as merged for `-d`)
- In a repo that commits directly to `main`, land a worktree commit yourself: in the worktree,
  `git rebase main` (stop and ask on conflict); `ExitWorktree` (keep); in the main checkout, confirm
  `git status --short --branch` shows `main` with no changes, else stop and ask, since another
  session may be working there; then `git merge --ff-only <branch>` (authorised; stop and ask if it
  refuses; pushing stays with me) and the cleanup calls above

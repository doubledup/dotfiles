# Git

## Commits

- Small, logically grouped changes (one concern per commit)
- Group commits by originating finding/task, not by file touched: a finding's complete fix (e.g., a
  new doc plus the reference update it requires) is one commit; a different finding's fix is a
  separate commit, even a one-line one
- Imperative mood, sentence case, no period (e.g. "Add feature command")
- Title: 54 characters max
- Body: omit unless the diff needs context; when used, 1-2 lines on the why, wrapped at 72
  characters
- When a body is used, write it per the voice in `~/.claude/docs/david-style.md`
- Start with a verb: Add, Remove, Bump, Revise, Clean up, Fix, Move, Set up, Update
- Formatting-only commits: "fmt"

## Branches

- Update a PR branch with the latest `main` by merging `main` into the branch, not by rebasing onto
  `main`. This avoids force-pushing shared branches and keeps history predictable.

## Worktrees

- Place worktrees external to the repo, flat, under
  `~/code/worktrees/<repo>__<branch-with-"/"-as-"-">` (e.g.
  `~/code/worktrees/sft-glue-monorepo__chore-cis-reactor-sequential-deploys`). Flat over nested;
  keeps them out of the `~/code/src/...` GHQ checkout and collision-safe across repos.
- Use plain `git worktree`, not Claude Code's native `EnterWorktree`. The native feature acts on the
  current session's repo, lives inside `.claude/worktrees/`, and derives the branch name from the
  worktree name, so it can produce neither an external path nor an arbitrary `chore/...` branch.
- `~/code/worktrees/` is outside the Bash sandbox's writable set: `mkdir -p` it (if new), then
  `/add-dir ~/code/worktrees` once, before creating a worktree there.
- Create the branch off the local `origin/<default-branch>` ref (a remote fetch addressed with
  `git -C` runs sandboxed and its SSH egress is blocked), then run the actual work from a session
  launched inside the worktree, where fetch/push behave normally.

## PR Descriptions

- Follow the project template (`.github/pull_request_template.md`)
- Description: what changed and why, in 3-6 sentences or bullets. One clause of root cause. Name
  what is deliberately out of scope if a reader would otherwise expect it. Then stop.
- Cut: how a fact was established (that is Testing Done), anything the diff already shows, commit
  bodies restated, background a linked ticket or PR already carries, and what is always implicit
  (e.g. that merged IaC deploys per environment via CI)
- Links: one per claim that needs context (ticket, prior PR), as markdown links. Link instead of
  explaining
- Testing Done: one line per check, the command and what it showed. Say plainly when nothing was run
- No line width limits (unlike commits); let lines wrap naturally

## PR Voice

- Voice and register per `~/.claude/docs/david-style.md`; PR-specific formatting (review tags,
  template structure) per the pr-comms output style (`~/.claude/output-styles/pr-comms.md`)

## PR Replies

- Substantiate documentation/behavior claims with a link to the source (code, official docs,
  schema), not just an assertion
- Keep review-thread replies short: one sentence stating the outcome (fixed in `<sha>`, or the
  reason for rejecting), without restating context already covered elsewhere

# Git

## Commits

- Small, logically grouped changes (one concern per commit)
- Group commits by originating finding/task, not by file touched: a finding's complete fix (e.g., a new doc plus the reference update it requires) is one commit; a different finding's fix is a separate commit, even a one-line one
- Imperative mood, sentence case, no period (e.g. "Add feature command")
- Title: 54 characters max
- Body: omit unless the diff needs context; when used, 1-2 lines on the why, wrapped at 72 characters
- When a body is used, write it per the voice in `~/.claude/docs/david-style.md`
- No attribution lines (no Co-Authored-By)
- Start with a verb: Add, Remove, Bump, Revise, Clean up, Fix, Move, Set up, Update
- Formatting-only commits: "fmt"

## Branches

- Update a PR branch with the latest `main` by merging `main` into the branch, not by rebasing onto `main`. This avoids force-pushing shared branches and keeps history predictable.

## Worktrees

- Place worktrees external to the repo, flat, under `~/code/worktrees/<repo>__<branch-with-"/"-as-"-">` (e.g. `~/code/worktrees/sft-glue-monorepo__chore-cis-reactor-sequential-deploys`). Flat over nested; keeps them out of the `~/code/src/...` GHQ checkout and collision-safe across repos.
- Use plain `git worktree`, not Claude Code's native `EnterWorktree`. The native feature acts on the current session's repo, lives inside `.claude/worktrees/`, and derives the branch name from the worktree name, so it can produce neither an external path nor an arbitrary `chore/...` branch.
- `~/code/worktrees/` is outside the Bash sandbox's writable set: `mkdir -p` it (if new), then `/add-dir ~/code/worktrees` once, before creating a worktree there.
- Create the branch off the local `origin/<default-branch>` ref (a remote fetch addressed with `git -C` runs sandboxed and its SSH egress is blocked), then run the actual work from a session launched inside the worktree, where fetch/push behave normally.

## PR Descriptions

- Follow the project template (`.github/pull_request_template.md`)
- Bias toward concise: cover the key details (root cause, what changed, testing) and cut the rest. Omit what is always implicit (e.g. that merged IaC deploys per environment via CI). Aim for a screenful.
- No line width limits (unlike commits); let lines wrap naturally
- Description: what changed, why (root cause or decision context), scope boundaries and tradeoffs
- Compact bullets for discrete changes
- Testing Done: exact commands and observed results; be explicit when testing was not done
- Link related Jira issues as markdown links

## PR Voice

- Prefer natural team-oriented language; use "we" when it feels authentic, not in every line
- Professional and calm; no cheerleading
- Never use em dashes; use commas, periods, semicolons, or parentheses instead
- Include links to context (tickets, prior PRs, docs) when they inform decisions

## PR Replies

- Substantiate documentation/behavior claims with a link to the source (code, official docs, schema), not just an assertion
- Keep review-thread replies short: one sentence stating the outcome (fixed in `<sha>`, or the reason for rejecting), without restating context already covered elsewhere

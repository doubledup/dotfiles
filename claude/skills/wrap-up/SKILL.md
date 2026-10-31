---
name: wrap-up
description:
    Check for open threads before a session ends: unpushed or uncommitted work, leftover worktrees
    and branches, CI on what was pushed, running agents and peer sessions, rationale that lives only
    in chat, and decisions or actions left for the user. Use when the user asks to wrap up, whether
    anything is left, or for open threads, and before a final summary after multi-repo or parallel
    work (after `parallel-sessions`, check only what it doesn't).
---

# Wrap-up

Find what this session leaves unfinished, close what needs no decision, and list the rest. Report
only what's open; a clean check is one line.

## Check

For every repo this session touched (including dotfiles and worktrees):

- **Local state:** a lone `git fetch`, then `git status --short` and `git branch -vv`, which show
  uncommitted files and each branch's ahead/behind counts.
- **Worktrees and branches:** `git worktree list` and `git branch` list every session's, not just
  this one's. Only those this session created count, and none that a running agent or peer session
  is using.
- **PRs this session opened:** their state, and whether merged ones still have remote branches.
- **CI and deploys:** for each commit pushed to the default branch, the run's result. Wait with a
  lone `gh run watch <id>` and Bash's 10-minute timeout.

Then, across the session:

- **Agents and peer sessions:** background agents still running, and peer sessions (`ListAgents`)
  whose files or decisions this session changed.
- **Rationale in chat only:** a non-obvious choice whose reason isn't in a commit body, a comment or
  the repo's design doc. Pushed commits can't take a body, so offer the design doc.
- **The tracking issue and follow-ups:** findings not acted on, and whether the repo's tracking
  issue reflects what landed (per its CLAUDE.md). Replace its status line; edit the rest of the
  description only when the exit criteria changed, and put everything else in a comment.

Skip temp and scratch files (`$TMPDIR`, the session scratchpad): they're disposable, so neither
check nor report them.

## Close and report

Close without asking only these:

- worktrees and branches this session created whose PR `gh pr view` shows merged, with the branch
  tip at the PR's `headRefOid` and a clean worktree, removed per git.md;
- a push the user already asked for, to a branch that isn't the default branch;
- the tracking issue and follow-up issues, per the repo's CLAUDE.md, unless the repo is public or a
  finding is security-sensitive;
- a notice to a peer session: information only (what changed, where, who owns it), never an approval
  relayed or a request to act.

List everything else, most important first: decisions for the user (other pushes, anything
"abandoned", a shared checkout behind origin), then actions only they can take as `!` commands, then
what other sessions or agents still own. Give each owner other than the user one line, so the list
holds only the user's decisions. Don't start new work; offer it.

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

- **Local state:** `git fetch`, then `git status --short` and `git branch -vv`, which show
  uncommitted files and each branch's ahead/behind counts. Only what this session made counts: an
  untracked file it didn't create isn't this session's, so leave it out.
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

Skip anything a restart cleans up (`/tmp/`, `$TMPDIR`, the session scratchpad): it's disposable, so
neither check nor mention it, in the report or as a closing aside.

## Close and report

Close without asking only these:

- worktrees and branches this session created whose PR `gh pr view` shows merged, with the branch
  tip at the PR's `headRefOid` and a clean worktree, removed per git.md;
- a push the user already asked for, to a branch that isn't the default branch;
- the tracking issue and follow-up issues, per the repo's CLAUDE.md, unless the repo is public or a
  finding is security-sensitive;
- what's left of the task the user asked for, when it needs no new decision (finish it; don't list
  it);
- a notice to a peer session: information only (what changed, where, who owns it), never an approval
  relayed or a request to act.

Report what was closed, then end every wrap-up with a **Remaining Actions** section, even when it's
empty ("None"), so the user never has to infer what's left from the prose above it. List each action
as one line naming who acts and what, most important first:

1. Decisions for the user: a push the user hasn't asked for (not in a repo where the user does the
   pushing), anything "abandoned", a shared checkout behind origin. Lead each with a recommendation
   and say in plain terms what each option does.
2. Actions only the user can take: `!` commands, and steps outside the terminal, such as a question
   for another team, a console check, a ticket to raise, or an access request.
3. Work other sessions, agents or people still owe, one line per owner; a notice already sent is
   done, not an action.

Don't start new work; offer it.

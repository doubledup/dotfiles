---
name: full-review
description:
    Review a PR or commit with every reviewer available, the Reviewer agent (plan conformance,
    over-engineering), built-in `/code-review` (correctness), and `/security-review`. Returns merged
    findings with one VERDICT. Use when the user wants a PR or branch reviewed for defects, and from
    `ship`'s review step. To understand or triage a PR instead, use pr-triage.
argument-hint: "<pr-url|pr-number|commit> [base] [--in-place]"
---

# Full Review

`/full-review <pr-url|pr-number|commit> [base] [--in-place]`. Intent is optional: `ship` passes the
plan, verification results, and on later iterations the prior findings with their dispositions; for
a PR, the title, body, and linked Jira issues are the intent, claims to verify rather than a source
of truth.

## Resolve

- PR (a URL, or a bare number, which is never treated as a SHA):
  `gh pr view <pr> --json headRefOid,headRefName,baseRefOid,isCrossRepository,title,body`. Target is
  `headRefOid`; base defaults to `baseRefOid`, not `baseRefName`, because a stale local
  `origin/<base>` would pull merged-in commits into the diff.
- Jira issues, for a PR only: collect keys from `headRefName` (`feature/GLUE-1234`) and from Jira
  browse links in the body (`/browse/GLUE-1234?focusedCommentId=...`), not from key-shaped text
  elsewhere (`UTF-8`). Deduplicate, resolve the cloudId once with `getAccessibleAtlassianResources`,
  then fetch each with the Atlassian MCP `getJiraIssue`: summary, description, and its
  `## Done when` checklist. Drop a key the MCP reports as not found, since it was a bad match; any
  other error (auth, no accessible site) is `unavailable`, not a missing key. The PR's own issue is
  the branch key, else the first remaining linked key that isn't an Epic; the rest are context.
  Don't follow the issues' own links. Record `jira` as `ok` (at least one fetched), `none` (no keys
  remain), or `unavailable` (the MCP or its auth failed); the review continues either way, since
  issues only add intent. A commit target has no `jira` status: callers put ticket context in the
  intent they pass.
- Commit: run `git fetch` (not for `HEAD`, which is local), then resolve with
  `git rev-parse <commit>`, so a remote-only SHA or an `origin/<branch>` ref resolves to its current
  value; everything since the base is reviewed, not just that commit. Base defaults to
  `origin/HEAD`; if that ref is unset, ask the user for a base.
- An explicit `[base]` overrides either default (stacked PRs).

## Check out

The reviewers read the working tree, so it must be the target. Work in the checkout of the target's
repo: the working directory, or another listed working directory whose `origin` is that repo, which
you `cd` into in its own Bash call first, since `/code-review` and `/security-review` review the
session's working directory. If no listed directory is that repo, stop and name it.

Unless HEAD is the target, stop when the PR is from a fork (`isCrossRepository`): checking it out
runs its content under the repo's shared git config and hooks, and its nested CLAUDE.md files load
when read. The user can check it out and rerun, which reviews in place.

Review in place when HEAD is the target (`ship`, or the user already checked it out) or `--in-place`
is passed; otherwise review in a worktree, so the user's checkout never moves.

### Worktree

1. Record `git rev-parse --path-format=absolute --git-common-dir` in the selected checkout.
2. `EnterWorktree` with name `review-<pr-number>` for a PR, or `review-<sha7>` for a commit. If it
   refuses (the session is already in a worktree, or the name is left from an earlier run), stop and
   suggest `--in-place`, or removing the stale one with `git worktree remove` and
   `git branch -D review-<...>`.
3. If the worktree's `git-common-dir` differs from the recorded one, it came from another repo:
   clean up (below), stop, and suggest `--in-place`.
4. Run `git fetch` (skip it if Resolve just ran one), so the base exists locally, then
   `gh pr checkout <pr> --detach` for a PR, or `git switch --detach <target>` for a commit. A
   detached HEAD works even when the PR branch is checked out in another worktree.
5. Verify (below).

The worktree is the repo root for the rest of the review. Clean up after Output, including after a
stop: `ExitWorktree` with `keep` (observed: `remove` refuses a hook-created worktree, as it can't
verify its state), then in the checkout `git worktree remove <path>`, `git worktree prune`, and
`git branch -D review-<...>`. `git worktree remove` refuses a worktree with changes, so if it does,
report the path; never pass `--force` or `discard_changes`.

### In place

1. List the range's files (`gh pr diff <pr> --name-only` for a PR,
   `git diff --name-only <base>...<target>` for a commit). If `git diff --quiet HEAD -- <files>`
   fails, stop and ask the user to stash those files; never stash, commit, or reset, so the user
   knows where their changes went. Uncommitted changes to other files, and untracked files, are
   fine: they can't alter the reviewed diff, and a step 4 switch carries them along (git refuses a
   switch that would overwrite one; stop and report it).
2. If HEAD is the target, skip to Verify.
3. Stop instead of switching when the repo is `~/.dotfiles`: it holds the live Claude config and
   takes no PRs.
4. Record the current branch (`git symbolic-ref --short -q HEAD`), or the SHA if detached. Run
   `git fetch` (skip it if Resolve just ran one), then `gh pr checkout <pr>` for a PR, or
   `git switch --detach <target>` for a commit. If the branch is checked out in another worktree,
   `cd` there in its own Bash call and restart at step 1; stop and name it only if it isn't a listed
   working directory.
5. Verify (below).

After a step 4 switch, switch back to the recorded branch or SHA once the review ends, including
after a stop.

### Verify

Check that `git rev-parse HEAD` equals the target and `git cat-file -e <base>^{commit}` passes; on
either failure, stop and report it.

If `git diff --quiet <base>...<target>` passes, the range is empty: report nothing to review and
stop, rather than a CLEAR from three reviews of nothing. For a commit already in the base, suggest
`<commit>~1` as the base.

## Run

Run all three, then wait for every one before merging:

1. Reviewer agent in `diff` mode, in the background: the output of `git diff <base>...<target> -U8`
   (it cannot run git), the intent, and the repo root. For a PR, tell it the title and body stand in
   for the plan as claims to check, with gaps between them and the code rated as unstated changes,
   MEDIUM at most. Send fetched Jira issues too, marking the PR's own: an issue's scope may span
   several PRs, so flag code that contradicts or exceeds the PR's own issue, and rate a `Done when`
   item the PR doesn't cover LOW unless the PR body claims to complete the issue. On later
   iterations, send only its own prior findings and dispositions; built-in findings reach it only as
   confirm requests (see Merge). If its review output lacks an Investigation section, re-ask only
   the Reviewer, once; still missing is `FAILED`.
2. `/code-review <level> --max-findings default <base>...<target>`. Level is `medium` unless the
   user explicitly asks for another level for this review. Always pass both: omitted, each reuses
   the user's last choice. Never `--fix` or `--comment`.
3. `/security-review`. It takes no arguments and diffs against `origin/HEAD`, so settle its coverage
   first. If `origin/HEAD` is unset, or `git merge-base --is-ancestor <target> origin/HEAD` passes
   (the range is already pushed), skip it and mark it `no coverage`. Otherwise run it and compare
   `o = git merge-base origin/HEAD <target>` with `b = git merge-base <base> <target>`: equal is
   `ok`; `o` after `b` (`git merge-base --is-ancestor <b> <o>`) means the start of the range went
   unreviewed, so mark it `partial`; `o` before `b` (`git merge-base --is-ancestor <o> <b>`) means
   it covered extra commits, so drop its findings outside the range; if neither is an ancestor of
   the other (a merge from main inside the range), mark it `partial` and drop its findings outside
   the range.

A source that errors, times out, or produces no report is `FAILED`. Do not merge around it: emit no
VERDICT, and stop for the user to retry, change the target, or proceed without it. A report with no
findings is a clean result, not a failure.

## Merge

- Collapse the same defect at the same location into one finding; tag each with its sources. A
  collapsed finding takes the highest severity any source gave it.
- Keep the Reviewer's severities, except under the hostile-content rule below. Rate built-in
  findings by impact and likelihood: HIGH = incorrect behavior, data loss, or a vulnerability under
  ordinary use; MEDIUM = likely to manifest in realistic use; LOW = needs rare conditions (an
  unusual git history, an unset ref) or is unlikely. For instructions written for a model, "the
  model might misread X" is LOW unless the text supports a concrete competing reading. Remediation
  is `fix`, or `rollback` when fixing it would rewrite most of the change. A finding `/code-review`
  marks PLAUSIBLE states its uncertainty.
- A finding against agent tooling or config (permissions, hooks, skills, this review flow) that
  works only if someone crafts hostile content (a malicious PR, a planted file) is LOW from any
  source, the Reviewer included, whatever the fix costs: the threat model defends accidents, not
  adversaries. Security findings in product code keep their severity.
- A built-in finding that matches a prior rejection is tagged `previously rejected: <reason>`.
  Built-ins never see dispositions, so it counts toward the VERDICT only if the Reviewer confirms it
  (below), rather than letting the rejecting agent grade its own call; unanswered, it drops to LOW.
- Send each finding still at MEDIUM or above whose sources are all built-ins to the Reviewer as one
  confirm request, with any `previously rejected: <reason>` tag. Confirmed takes the severity the
  Reviewer gives; unconfirmed drops to LOW, tagged `unconfirmed`, and stays listed; an unanswered
  finding keeps its severity unless previously rejected. If the confirm call errors, the Reviewer is
  `FAILED`.
- VERDICT is the highest severity across all sources.

## Output

```
## Review: <target> vs <base>
Sources: reviewer [ok|FAILED], /code-review [ok|FAILED], /security-review [ok|partial|no coverage|FAILED], jira [ok|none|unavailable]

## Investigation
[the Reviewer's section]

### High Impact
**N. [one-line claim]** [sources] `path:line`. **Remediation**: fix|rollback.
- **Now**: [what the code does today, with the concrete value or name a reader needs]
- **Example**: [a walk-through with concrete inputs that ends in the wrong outcome]
- **Fix**: [action]

### Medium Impact
...

### Low Impact
- [sources] `path:line`. **Remediation**: fix|rollback. [problem]. [why]. Suggested fix: [action].

VERDICT: [HIGH|MEDIUM|LOW|CLEAR]
```

Omit empty severity sections, and the `jira` entry for a commit target. HIGH and MEDIUM findings use
the Now/Example/Fix form, so a reader who hasn't read the diff can follow the mechanism; rewrite a
source's shorthand into it rather than pasting it. Add a **Why it matters** line only when the
Example doesn't make the impact plain, and an **Open question** line for an inference the review
couldn't verify.

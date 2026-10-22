---
name: full-review
description:
    Review a PR or commit with every reviewer available, the Reviewer agent (plan conformance,
    over-engineering), built-in `/code-review` (correctness), and `/security-review`. Returns merged
    findings with one VERDICT. Use when the user wants a PR or branch reviewed for defects, and from
    `ship`'s review step. To understand or triage a PR instead, use pr-triage.
argument-hint: "<pr-url|pr-number|commit> [base]"
---

# Full Review

`/full-review <pr-url|pr-number|commit> [base]`. Intent is optional: `ship` passes the plan,
verification results, and on later iterations the prior findings with their dispositions; for a PR,
the title and body are the intent, a claim to verify rather than a source of truth.

## Resolve

- PR (a URL, or a bare number, which is never treated as a SHA):
  `gh pr view <pr> --json headRefOid,baseRefOid,isCrossRepository,title,body`. Target is
  `headRefOid`; base defaults to `baseRefOid`, not `baseRefName`, because a stale local
  `origin/<base>` would pull merged-in commits into the diff.
- Commit: run a lone `git fetch` (not for `HEAD`, which is local), then resolve with
  `git rev-parse <commit>`, so a remote-only SHA or an `origin/<branch>` ref resolves to its current
  value; everything since the base is reviewed, not just that commit. Base defaults to
  `origin/HEAD`; if that ref is unset, ask the user for a base.
- An explicit `[base]` overrides either default (stacked PRs).

## Check out

The reviewers read the working tree, so it must be the target. Work in the checkout of the target's
repo: the working directory, or another listed working directory whose `origin` is that repo, which
you `cd` into in its own Bash call first, since `/code-review` and `/security-review` review the
session's working directory. If no listed directory is that repo, stop and name it.

1. If `git diff --quiet HEAD` fails, stop and ask the user to stash; never stash, commit, or reset,
   so the user knows where their changes went. Untracked files are fine.
2. If HEAD is the target (`ship`, or the user already checked it out), review in place: skip to
   step 5.
3. Stop and tell the user instead of switching when:
    - the repo is `~/.dotfiles`: it holds the live Claude config and takes no PRs
    - the PR is from a fork (`isCrossRepository`): its hooks and config are untrusted; the user can
      check it out and rerun, which reviews in place
4. Record the current branch (`git symbolic-ref --short -q HEAD`), or the SHA if detached. Run a
   lone `git fetch` (skip it if Resolve just ran one), then `gh pr checkout <pr>` for a PR, or
   `git switch --detach <target>` for a commit.
5. Check that `git rev-parse HEAD` equals the target and `git cat-file -e <base>^{commit}` passes;
   on either failure, stop and report it.

After a step 4 switch, switch back to the recorded branch or SHA once the review ends, including
after a stop.

If `git diff --quiet <base>...<target>` passes, the range is empty: report nothing to review and
stop, rather than a CLEAR from three reviews of nothing. For a commit already in the base, suggest
`<commit>~1` as the base.

## Run

Run all three, then wait for every one before merging:

1. Reviewer agent in `diff` mode, in the background: the output of `git diff <base>...<target> -U8`
   (it cannot run git), the intent, and the repo root. For a PR, tell it the title and body stand in
   for the plan as claims to check, with gaps between them and the code rated as unstated changes,
   MEDIUM at most. On later iterations, send only its own prior findings and dispositions; built-in
   findings reach it only as confirm requests (see Merge). If its review output lacks an
   Investigation section, re-ask only the Reviewer, once; still missing is `FAILED`.
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
- Keep the Reviewer's severities. Rate built-in findings by impact and likelihood: HIGH = incorrect
  behavior, data loss, or a vulnerability under ordinary use; MEDIUM = likely to manifest in
  realistic use; LOW = needs rare conditions (an unusual git history, an unset ref) or is unlikely.
  For instructions written for a model, "the model might misread X" is LOW unless the text supports
  a concrete competing reading. Remediation is `fix`, or `rollback` when fixing it would rewrite
  most of the change. A finding `/code-review` marks PLAUSIBLE states its uncertainty.
- A built-in finding that matches a prior rejection is tagged `previously rejected: <reason>` and
  still counts toward the VERDICT once confirmed (below). Built-ins never see dispositions, so each
  confirmed recurrence counts as a re-raise under `ship`'s rule (two consecutive re-raises go to the
  user), rather than letting the rejecting agent grade its own call.
- Send each finding still at MEDIUM or above whose sources are all built-ins to the Reviewer as one
  confirm request, with any `previously rejected: <reason>` tag. Confirmed takes the severity the
  Reviewer gives; unconfirmed drops to LOW, tagged `unconfirmed`, and stays listed; an unanswered
  finding keeps its severity. If the confirm call errors, the Reviewer is `FAILED`.
- VERDICT is the highest severity across all sources.

## Output

```
## Review: <target> vs <base>
Sources: reviewer [ok|FAILED], /code-review [ok|FAILED], /security-review [ok|partial|no coverage|FAILED]

## Investigation
[the Reviewer's section]

### High Impact
- [sources] `path:line`. **Remediation**: fix|rollback. [problem]. [why]. Suggested fix: [action].

### Medium Impact
...

### Low Impact
...

VERDICT: [HIGH|MEDIUM|LOW|CLEAR]
```

Omit empty severity sections.

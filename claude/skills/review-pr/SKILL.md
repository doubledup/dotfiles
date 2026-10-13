---
name: review-pr
description:
    Review a PR or commit with every reviewer available, the Reviewer agent (plan conformance,
    over-engineering), built-in `/code-review` (correctness), and `/security-review`. Returns merged
    findings with one VERDICT. Use when the user wants a PR or branch assessed for defects, and from
    `ship`'s review step.
argument-hint: "<pr-url|pr-number|commit> [base]"
---

# Review PR

`/review-pr <pr-url|pr-number|commit> [base]`. Intent is optional: `ship` passes the plan,
verification results, and on later iterations the prior findings with their dispositions; for a PR,
the title and body are the intent, a claim to verify rather than a source of truth.

## Resolve

- PR (a URL, or a bare number, which is never treated as a SHA):
  `gh pr view <pr> --json headRefOid,baseRefOid,title,body`. Target is `headRefOid`; base defaults
  to `baseRefOid`, not `baseRefName`, because a stale local `origin/<base>` would pull merged-in
  commits into the diff.
- Commit: resolve with `git rev-parse <commit>`; everything since the base is reviewed, not just
  that commit. Base defaults to `origin/HEAD`; if that ref is unset, ask the user for a base.
- An explicit `[base]` overrides either default (stacked PRs).

## Precondition

The reviewers read the working tree, so it must be the target. Check all three; on any failure, stop
and tell the user exactly what to check out or fetch. Never run checkout, switch, or fetch.

- `git rev-parse HEAD` equals the target
- `git diff --quiet HEAD` passes (untracked files are fine)
- `git cat-file -e <base>^{commit}` passes

If `git diff --quiet <base>...<target>` passes, the range is empty: report nothing to review and
stop, rather than a CLEAR from three reviews of nothing.

## Run

Run all three, then wait for every one before merging:

1. Reviewer agent in `diff` mode, in the background: `git diff <base>...<target> -U8`, the intent,
   and the repo root. For a PR, tell it the title and body are claims, not a plan, and that gaps
   between them and the code are unstated changes, MEDIUM at most. If its output lacks an
   Investigation section, re-ask only the Reviewer, once; still missing is `FAILED`.
2. `/code-review <level> <base>...<target>`. Level is `high` unless the user's request names one;
   with no level it reuses whatever the user last typed, so depth would vary. Never `--fix` or
   `--comment`.
3. `/security-review`. It takes no arguments and diffs against `origin/HEAD`, so settle its coverage
   first. If `origin/HEAD` is unset, or `git merge-base --is-ancestor <target> origin/HEAD` passes
   (the range is already pushed), skip it and mark it `no coverage`. Otherwise run it and compare
   `o = git merge-base origin/HEAD <target>` with `b = git merge-base <base> <target>`: equal is
   `ok`; `o` after `b` (`git merge-base --is-ancestor <b> <o>`) means the start of the range went
   unreviewed, so mark it `partial`; `o` before `b` means it covered extra commits, so drop its
   findings outside the range.

A source that errors, times out, or produces no report is `FAILED`. Do not merge around it: emit no
VERDICT, and stop for the user to retry, change the target, or proceed without it. A report with no
findings is a clean result, not a failure.

## Merge

- Collapse the same defect at the same location into one finding; tag each with its sources. A
  collapsed finding takes the highest severity any source gave it.
- Keep the Reviewer's severities. Rate built-in findings: HIGH = incorrect behavior, data loss, or a
  vulnerability in production; MEDIUM = likely to manifest in realistic use; otherwise LOW.
  Remediation is `fix`, or `rollback` when fixing it would rewrite most of the change. A finding
  `/code-review` marks PLAUSIBLE states its uncertainty.
- A built-in finding that matches a prior rejection is tagged `previously rejected: <reason>` and
  still counts toward the VERDICT. Built-ins never see dispositions, so its recurrence is the
  re-raise that sends it to the user under `ship`'s rule, rather than letting the rejecting agent
  grade its own call.
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

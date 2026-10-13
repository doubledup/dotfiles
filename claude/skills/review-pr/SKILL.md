---
name: review-pr
description:
    Review a PR or commit with every reviewer available, the Reviewer agent (plan conformance,
    over-engineering), built-in `/code-review` (correctness), and `/security-review`. Returns merged
    findings with one VERDICT. Use when the user wants a PR or branch assessed for defects, and from
    `ship`'s review step.
argument-hint: "<pr-url|commit> [base]"
---

# Review PR

`/review-pr <pr-url|commit> [base]`. Intent is optional: `ship` passes the plan, verification
results, and on later iterations the prior findings with their dispositions; for a PR, the title and
body are the intent, a claim to verify rather than a source of truth.

## Resolve

- PR: `gh pr view <url> --json headRefOid,baseRefOid,title,body`. Target is `headRefOid`; base
  defaults to `baseRefOid`, not `baseRefName`, because a stale local `origin/<base>` would pull
  merged-in commits into the diff.
- Commit: resolve with `git rev-parse <commit>`; everything since the base is reviewed, not just
  that commit. Base defaults to `origin/HEAD`; if that ref is unset, ask the user for a base.
- An explicit `[base]` overrides either default (stacked PRs).

## Precondition

The reviewers read the working tree, so it must be the target. Check all three; on any failure, stop
and tell the user exactly what to check out or fetch. Never run checkout, switch, or fetch.

- `git rev-parse HEAD` equals the target
- `git diff --quiet HEAD` passes (untracked files are fine)
- `git cat-file -e <base>^{commit}` passes

## Run

Run all three, then wait for every one before merging:

1. Reviewer agent in `diff` mode, in the background: `git diff <base>...<target> -U8`, the intent,
   and the repo root. With no intent (an empty PR body), tell it to skip plan conformance and say
   so. If its output lacks an Investigation section, re-ask only the Reviewer.
2. `/code-review <base>...<target>`. Pass a level only if the user gave one; never `--fix` or
   `--comment`.
3. `/security-review`. It takes no arguments and diffs against origin's default branch. When
   `git merge-base origin/HEAD <target>` differs from `base` (a stacked PR, or unpushed commits
   before the base), note that its scope differs from the reviewed range, and drop its findings
   outside that range.

A source that errors, times out, or produces no report is `FAILED`. Do not merge around it: emit no
VERDICT, and stop for the user to retry, change the target, or proceed without it. A report with no
findings is a clean result, not a failure.

## Merge

- Collapse the same defect at the same location into one finding; tag each with its sources.
- Keep the Reviewer's severities. Rate built-in findings: HIGH = incorrect behavior, data loss, or a
  vulnerability in production; MEDIUM = likely to manifest in realistic use; otherwise LOW.
  Remediation is `fix`, or `rollback` when fixing it would rewrite most of the change. A finding
  `/code-review` marks PLAUSIBLE states its uncertainty.
- A built-in finding that matches a prior rejection is listed as `previously rejected: <reason>` and
  does not count toward the VERDICT. Built-ins never see dispositions, so they would re-raise it
  every iteration; the Reviewer confirms or re-raises its own.
- VERDICT is the highest severity across all sources.

## Output

```
## Review: <target> vs <base>
Sources: reviewer [ok|FAILED], /code-review [ok|FAILED], /security-review [ok|FAILED] [scope note]

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

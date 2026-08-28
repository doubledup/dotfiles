---
name: pr-comprehension
description:
    Build a mental model of a pull request fast, before or instead of reviewing it. Produces a
    reading order, a traced execution path, an intent-versus-code diff, and triaged findings. Use
    this whenever the user is trying to understand a PR, asks "what does this PR do", "help me
    review this PR", "walk me through this change", "why is this diff so big", pastes a PR URL or a
    diff, or is working through review comments they don't yet have the context to judge. Use it
    even when the user asks for a review, because a review is only useful once the model of the
    change exists.
---

# PR Comprehension

A review presupposes a mental model of the change. Most of the time spent on a PR is spent building
that model, not finding defects. This skill builds the model first, in passes, so the user can stop
as soon as they understand enough.

Diffs are ordered alphabetically by path. Comprehension is ordered causally, from the entry point
outward. Almost everything here follows from that gap.

## Gather

Get the change and its stated intent before analysing anything.

```bash
gh pr view <url-or-number> --json title,body,headRefOid,baseRefOid,files [--repo owner/name]
gh pr diff <url-or-number> [--repo owner/name]
```

If the PR body links a ticket or design doc, fetch it. If a Jira or Confluence tool is available,
use it. If there's no ticket and the PR body doesn't state intent either, skip Pass 3 rather than
fabricate a target to diff against.

Prefer reading files at both refs over reading the diff alone: a diff hides control flow, the files
do not. Use `git show <headRefOid>:<path>` and `git show <baseRefOid>:<path>`; if those objects
aren't available locally, fall back to
`gh api repos/{owner}/{repo}/contents/<path>?ref=<oid> -H "Accept: application/vnd.github.raw"`, or
to the diff alone. Never `checkout` or `switch` to fetch a ref; that mutates the user's working
tree.

## Pass 1 - Orient

Sort every changed file into one of three buckets, then give a reading order.

- **Signal** - files where the behaviour actually changed.
- **Mechanical** - generated code, regenerated schema classes, dependency wiring, import churn,
  formatting, lockfiles, renames. Learn what counts as generated in this repo rather than guessing;
  check the build config.
- **Config** - deployment, infrastructure, feature flags, permissions. Small diffs here often carry
  more risk than large ones in signal files.

Then give the signal files in causal order, starting at the entry point, with the one question each
file answers.

Output template:

```
## Shape
[One sentence: the behavioural delta. Not a list of files.]

## Read in this order
1. path/to/Entry.java - [what question this answers]
2. path/to/Next.java  - [what question this answers]
3. ...

## Skip
- path/to/Generated.java (regenerated from schema)
- ... [grouped, with the reason]

## Config changed
- path - [what it changes at runtime]
```

Cutting the mechanical bucket first is usually the largest single reduction in surface area, and it
is the part the user cannot do quickly by eye.

## Pass 2 - Trace

Structural descriptions do not build a mental model. A narrative through one concrete input does.

Pick a realistic input for this system: a request, an event, a message, a CLI invocation. State the
input explicitly. Then walk it through the base ref and through the head ref, and show where the two
paths diverge.

```
## Input
[The concrete thing entering the system]

## Before
[Numbered steps through the base ref, file:line at each hop]

## After
[Numbered steps through the head ref, file:line at each hop]

## Divergence
[The specific points where the paths differ, and what that changes for
the caller, the stored state, or anything downstream]
```

This matters most where the diff hides the control flow across a boundary: event handlers, message
consumers, middleware chains, dependency-injected wiring. In those cases the changed lines and the
changed behaviour live in different files.

If more than one input class is affected and they diverge differently, say so and offer to trace the
second rather than merging them into one confusing walk.

## Pass 3 - Intent diff

Compare the ticket or design doc against the code. Produce exactly two lists.

```
## In the code, not in the ticket
- [change] - [file:line] - [scope creep, incidental fix, or silent contract change?]

## In the ticket, not in the code
- [requirement] - [absent, partial, or deferred with a TODO?]
```

Do not pad either list with restatements of things that match. The value is entirely in the
asymmetries. If both lists are empty, say so in one line.

Silent contract changes belong in the first list even when they look harmless: changed field
nullability, changed error codes, changed ordering guarantees, changed defaults, widened or narrowed
permissions.

## Pass 4 - Triage findings

Only run this once the model exists, or when the user brings existing review comments they cannot
yet judge.

Every finding needs a file:line and a quoted line of code. For a finding of absence (a missing
guard, a deleted call, an unhandled branch), anchor on the nearest enclosing line, or on the removed
line, instead of leaving the finding unquoted or inventing a quote. An ungrounded finding costs the
reader more time than it saves, because they have to go read the code to discover whether it is
real.

```
## Would block the merge
- [finding] - path:line
  `[the actual line]`
  [why it breaks, concretely]

## Would file as follow-up
- [same shape]

## Taste
- [same shape, one line each]

## Could not verify
- [what was unchecked and why: caller not in the diff, runtime config not
  visible, behaviour depends on data not in the repo]
```

The "could not verify" list is not an apology. It tells the user exactly where their own attention
is still required, which is the point of the whole skill.

## Running the passes

Default to Pass 1 and Pass 2 in the first response, then ask whether to continue. Most PRs are
understood by the end of Pass 2, and running all four unprompted recreates the wall of text this
skill exists to avoid.

Run a single pass directly when the user asks for one: "trace an order event through this PR" is
Pass 2 alone.

## Constraints

Ground every claim in code that was actually read. When something is inferred rather than read, mark
it as inferred. Confident wrong summaries are the failure mode with the highest cost here, because
they are accepted without checking.

Say when the PR is too large to model in one pass, and propose a split by concern rather than
producing a shallow account of all of it.

On changes touching money, personal data, authentication, authorisation, or audit records, add one
line stating that the trace is a map for the user's own reading rather than a substitute for it.

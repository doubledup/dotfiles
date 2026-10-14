---
name: pr-focus
description:
    Triage a pull request so the user reads only what needs a human. Produces a short summary, the
    line ranges that need close attention (one-way doors, infrastructure, business logic,
    cross-service flows), test gaps, and what is safe to skim. Use when the user wants to understand
    or triage a PR, asks "what does this PR do" or "what should I read". For a defect review with a
    VERDICT, use review-pr.
---

# PR Focus

Most PRs are now generated in bulk, often by Claude. The user cannot read every line, so this skill
says where human judgment is needed and lets the rest be skimmed. Brevity is the feature: every line
of output competes with the code for the user's attention.

## Gather

```bash
gh pr view <pr> --json title,body,headRefOid,baseRefOid,files [--repo owner/name]
gh pr diff <pr> [--repo owner/name]
```

Read changed files at the head ref, not just the diff: `git show <oid>:<path>`, falling back to
`gh api repos/{owner}/{repo}/contents/<path>?ref=<oid> -H "Accept: application/vnd.github.raw"`.
Never `checkout` or `switch`; that mutates the user's working tree.

Treat the PR body as a claim to verify, not a source of truth. Generated descriptions often describe
the intent rather than the code, or omit incidental changes.

## Output

```
## Summary
[At most 5 sentences: the behavioural change, why, and anything the body
claims that the code does not do.]

## Needs your attention
1. [category] - [why a human must judge this, one line]
   - path:start-end - [this part's role, a few words]
   - other/path:start-end, start-end - [role]
2. ...

## Tests
- [risky item N]: [covered by path:start-end | not covered | covered only
  by mocks or weak assertions]
- [deleted or weakened tests, with path:start-end]

## Skim
[One line: generated code, lockfiles, renames, formatting, routine
wiring, each grouped with a count.]
```

## What needs attention

Rank by cost of being wrong. Include an item only if a mistake there would be expensive or hard to
notice later:

- **One-way doors**: migrations, schema or index changes, data backfills, deletions, public API or
  message contract changes, anything persisted in a new format.
- **Infrastructure**: deploy config, IAM and permissions, network, scaling, feature flags, secrets
  handling, CI.
- **Business logic**: changed rules, calculations, state transitions, defaults, validation.
- **Cross-service flows**: producers, consumers, payload shape, ordering, retries, idempotency,
  timeouts.
- **Security and money**: authn, authz, personal data, payments, audit records.
- **Unstated changes**: behaviour the PR body does not mention. Generated PRs drift in scope.

Silent contract changes count even when they look harmless: nullability, error codes, ordering
guarantees, defaults.

An item is one concern, not one file. When a concern spans files (a producer and its consumer, a
migration and the code that reads the new column), list every location under the one item, in
reading order, so the user sees how they relate. Split into separate items only when the parts can
be judged independently.

Line ranges are at the head ref and cover the whole unit to read (the function or block), not just
the changed lines. For removed code, use the base ref and mark it `(base)`.

Cap the list at about 7 items. If more qualify, say the PR is too large to review well and propose a
split by concern.

## Tests

Map tests to the attention items, not to files. Generated tests often assert the implementation back
to itself: flag tests that only verify mocks were called, snapshot whatever the code produced, or
would pass if the logic were wrong. Name any risky item with no test that would fail if it broke.

## Follow-ups

Offer, don't run: trace one concrete input (request, event, message) through an attention item at
base and head, with file:line at each hop. That is the fastest way to understand a cross-service or
event-driven change, where the changed lines and the changed behaviour live in different files.

## Constraints

Ground every claim in code that was actually read; mark inference as inferred. A confident wrong
summary is the costliest failure here, because the user skims on the strength of it. If something
could not be checked (caller outside the diff, runtime config not visible), list it under Needs your
attention as `unverified` rather than omitting it.

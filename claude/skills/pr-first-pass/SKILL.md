---
name: pr-first-pass
description:
    Run full-review on a colleague's PR and post its MEDIUM and HIGH findings as one review of
    Conventional Comments, a first round of feedback entirely from Claude before the user's own
    review.
argument-hint: "<pr-url|pr-number> [--dry-run] [--in-place]"
disable-model-invocation: true
---

# PR First Pass

`/pr-first-pass <pr-url|pr-number> [--dry-run] [--in-place]`. Invoking it is the user's approval to
post; with `--dry-run`, print the drafted review instead of posting it. `--in-place` passes through
to full-review, for a session already in a worktree, where its own worktree can't be created.

## Guard

`gh pr view <pr> --json author,state,isDraft,isCrossRepository,headRefOid,url` and
`gh api user --jq .login`. Stop and say why when the PR is the user's own, not `OPEN`, a draft, or
from a fork. Also stop when `gh api --paginate repos/<owner>/<repo>/pulls/<n>/reviews` holds a
review by the user whose body starts with the marker line (below) and whose `commit_id` is
`headRefOid`: this head already has a first pass.

## Review

Run `/full-review <pr> [--in-place]`, which reviews in a worktree and brings the PR's Jira issues as
intent. If it stops or marks a source `FAILED`, post nothing and report why. Keep only the HIGH and
MEDIUM findings; with none, post nothing and tell the user, listing any LOW findings.

## Draft

Load `authored-voice` and follow its review-comment rules, with these choices. One comment per
finding:

- Label by kind of finding: `issue` for a defect, `todo` for a small, mechanical addition,
  `suggestion` for a better alternative, `question` for a finding the review couldn't verify and has
  no fix for (a finding with a fix keeps its label and asks its Open question in the text), `chore`
  for a task outside the code (a deploy or config step).
- Decorations: `blocking` for HIGH, `non-blocking` for MEDIUM; a domain decoration where one fits
  (`security` for a security-review finding, `test` for a test gap); `claude` last.
  `issue (blocking, security, claude): ...`
- Text: the claim as the subject, then one or two sentences on why it matters and the fix. The
  finding's Now/Example/Fix is written for a reader who hasn't seen the diff; the author has, so add
  the walk-through only when the mechanism isn't plain from the line. Use a suggestion block when
  the fix is a few lines, reading the lines it replaces with `git show <headRefOid>:<path>`, since
  full-review's worktree is gone and the working tree holds another revision. Permalinks pin the
  head SHA; a finding about a Jira issue links it, using the PR body's existing link, or names the
  key alone when the body has none.
- Anchor each comment to its line on the diff's RIGHT side (`start_line` too for a range). A finding
  outside the diff's hunks goes in the review body instead, with its permalink, since GitHub rejects
  inline comments there.

The review body opens with the marker line `Claude first pass, ahead of my own review.` and the
VERDICT, then any findings that couldn't be anchored. The marker is true here because the user
hasn't read the drafts, so it overrides the usual rule against a "drafted by Claude" line.

## Post

Write the payload to a file in a fresh `mktemp -d` scratch directory and post it with
`gh api repos/<owner>/<repo>/pulls/<n>/reviews --input <file>`: `commit_id` is the reviewed head
SHA, `event` is always `COMMENT` (approving or requesting changes is the user's own review), `body`,
and `comments` as `{path, line, side, body}`, plus `start_line` and `start_side` for a range, so a
multi-line suggestion replaces the whole range. A bad anchor fails the whole request (HTTP 422) and
posts nothing. On a 422, if `headRefOid` has moved since the review, stop and report that the author
pushed; otherwise recheck each anchor against the hunks in `gh pr diff <pr>`, move any outside them
into the body, and post once more. A second failure stops and reports.

## Report

The review's `html_url`, the count of comments by label, and the LOW findings for the user's own
pass.

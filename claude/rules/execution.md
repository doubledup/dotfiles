## Execution review loop

The main agent orchestrates this loop, invoking the Reviewer as a subagent.

If a slash command (e.g., /feature) defines its own execution or review process, follow that instead.

### During execution

- Record the current HEAD SHA before starting (base commit for the review diff)
- Implement and commit concern-by-concern as you go: finish a concern's edits across all its files, then commit them together (one concern per commit) before starting the next. This keeps commits cleanly scoped -- a file touched by several concerns lands each concern's edit in a separate commit -- and avoids after-the-fact hunk-splitting. Don't run the full test suite per commit; a cheap syntax/format check on a just-edited file is fine
- Follow the plan. Only update it when review findings or implementation blockers require it, not for scope changes. If a scope change seems necessary, stop and surface it to the user before proceeding.

### After all commits

Run project verification (formatting, linting, tests as appropriate for the files changed) once and fix any failures. Include pass/fail results as context when sending the diff to the reviewer.

Run a review loop on the committed range (`<base>..HEAD`, the recorded base HEAD to the current tip). If the range is empty or has 20 or fewer changed lines (insertions + deletions from `git diff <base>..HEAD --stat`), skip the review loop. For no net change, report that; for a small diff, report the changes to the user with the diff included.

1. Check the diff size. Warn if it exceeds 400 changed lines; if it exceeds 1500, stop and ask the user whether to proceed with review or split the work.
2. Get the diff: `git diff <base>..HEAD --stat -U8` (recorded base HEAD to the current tip; at least 8 lines of context). The `--stat` summary gives the reviewer a scope overview before the full diff.
3. Send the diff and plan/spec to the Reviewer agent in `final` mode.
4. For VERDICT handling, disposition discipline, and iteration tracking, follow `review-protocol.md`.

### Commit

Commits are made concern-by-concern during execution (above), not deferred to after the review loop. Group by originating concern, not by file touched; one concern per commit. The tradeoff is that commits land before the final review, so verification and the review loop run at the end and any fixes are fix-up commits.

### Remediation

**Fix findings**: apply fixes as fix-up commits (or amend the most recent commit when it is the natural home and unpushed), then re-run verification and re-enter the review loop; the next iteration must confirm they are clean. Because the work is already committed, fixes land as their own commits, not folded into pending changes.

**Rollback findings**: if the reviewer marks a finding as rollback (structurally wrong approach, or fix would rewrite >50% of a step), stop and surface to the user with the findings and suggested approach rather than autonomously reverting and re-implementing.

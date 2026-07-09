## Execution review loop

The main agent orchestrates this loop, invoking the Reviewer as a subagent.

If a slash command (e.g., /feature) defines its own execution or review process, follow that instead.

### During execution

- Record the current HEAD SHA before starting (base commit for the review diff)
- Implement each plan step in the working tree. Do not commit yet: commits come after the review loop, so every commit is already review-clean (see Commit below)
- Follow the plan. Only update it when review findings or implementation blockers require it, not for scope changes. If a scope change seems necessary, stop and surface it to the user before proceeding.

### After all steps complete

Run project verification (formatting, linting, tests as appropriate for the files changed) and fix any failures before entering the review loop. Include pass/fail results as context when sending the diff to the reviewer.

Run a review loop on the uncommitted accumulated diff (nothing is committed yet). Stage the changes first (`git add`) so new files are included in the diff. If the diff is empty or has 20 or fewer changed lines (insertions + deletions from `git diff --cached --stat`), skip the review loop. For empty diffs, report that no net changes were made. For small diffs, report changes directly to the user with the diff included, then commit.

1. Check the accumulated diff size. Warn if it exceeds 400 changed lines; if it exceeds 1500, stop and ask the user whether to proceed with review or split the work.
2. Get the diff: `git diff --cached --stat -U8` (staged working tree against the recorded base HEAD; at least 8 lines of context). The `--stat` summary gives the reviewer a scope overview before the full diff.
3. Send the diff and plan/spec to the Reviewer agent in `final` mode.
4. For VERDICT handling, disposition discipline, and iteration tracking, follow `review-protocol.md`.

### Commit

Only after the review loop exits CLEAR or LOW, commit the reviewed changes: one commit per plan step (granular, review-clean rollback points).

### Remediation

**Fix findings**: apply fixes in the working tree, then re-enter the review loop; the next iteration must confirm they are clean. Because nothing is committed until the loop exits, fixes are folded into the pending changes, not appended as separate commits.

**Rollback findings**: if the reviewer marks a finding as rollback (structurally wrong approach, or fix would rewrite >50% of a step), stop and surface to the user with the findings and suggested approach rather than autonomously reverting and re-implementing.

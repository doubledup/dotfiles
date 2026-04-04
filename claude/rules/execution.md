## Execution review loop

The main agent orchestrates this loop, invoking the Reviewer as a subagent.

If a slash command (e.g., /feature) defines its own execution or review process, follow that instead.

### During execution

- Record HEAD SHA before the first implementation commit (base commit for the review diff)
- Make one commit per plan step (granular rollback points)
- Follow the plan. Only update it when review findings or implementation blockers require it, not for scope changes. If a scope change seems necessary, stop and surface it to the user before proceeding.

### After all steps complete

Run project verification (formatting, linting, tests as appropriate for the files changed) and fix any failures before entering the review loop. Include pass/fail results as context when sending the diff to the reviewer.

Run a review loop on the accumulated diff. If the accumulated diff is empty (no net changes), skip the review loop and report that no net changes were made.

1. Check the accumulated diff size. Warn if it exceeds 400 changed lines; if it exceeds 1500, stop and ask the user whether to proceed with review or split the work.
2. Get the diff from the base commit to HEAD.
3. Send the diff and plan/spec to the Reviewer agent in `final` mode.
4. Check the VERDICT line:
    - CLEAR: Exit the loop.
    - LOW: Exit the loop. LOW findings are included in the report. The implementer may remediate them at their judgement, but the loop does not require it.
    - MEDIUM or HIGH: Accept, partially accept, or reject each finding. For partially accepted findings, note which parts are rejected (with reasoning) and process the accepted parts through remediation. Rejected findings are not remediated but are sent back to the reviewer in the next iteration.
    - If the reviewer's output lacks a valid VERDICT line, infer the verdict from the highest severity section present in the output. No findings sections = CLEAR.
5. On iterations 2+, send the previous iteration's findings with your disposition of each (accepted, partially accepted, or rejected) and reasoning to the Reviewer as context.
6. The loop exits only when the reviewer returns CLEAR or LOW, or after 6 iterations (hard cap). Rejecting findings does not exit the loop; the reviewer must confirm that rejections were sound or re-raise them. If the same finding (same code location or design decision) is rejected and re-raised across two consecutive iterations, escalate to the user rather than continuing the loop.
7. Report the review summary to the user:
    ```
    **Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | max iterations].
    Rejected findings: [finding summary]: [rejection reasoning]
    ```
    Omit the rejected line if none were rejected. Include LOW findings below the summary. On max-iteration exit with high-impact findings, note whether the same finding persisted or new issues emerged.

### Remediation

**Fix findings**: Apply as a single fix commit per affected step. Multi-step findings are attributed to the earliest affected step.

**Rollback findings** follow a three-phase sequence:

1. **Revert**: Starting from the latest step, revert commits back to the earliest rollback step. Reverse order keeps reverts clean since later code may differ from when the step was committed. If a step produced multiple commits, revert all commits for that step in reverse commit order. If a revert produces a merge conflict, stop and surface to the user rather than resolving it automatically.
2. **Fix**: Apply fix commits for steps before the rollback point.
3. **Re-implement**: Re-implement from the rollback point forward with all review findings as context.

**Subsumption**: If any finding for a step says rollback, treat the entire step as rollback regardless of other fix findings for that step. This is resolved at remediation time.

**Full reset** (rolling back all steps) is rare and signals a bad plan. If triggered, stop and surface to the user rather than proceeding autonomously.

**Re-verification**: After remediation, the next review iteration must confirm fixes are clean. Do not assume remediation resolved the issue; the reviewer must see the updated diff and verify.

Example: Steps 1-5 committed. Reviewer says step 2 needs fix, step 4 needs rollback.

1. Revert commits for steps 5, 4 (reverse order)
2. Apply fix commit for step 2
3. Re-implement steps 4, 5 with review findings as context

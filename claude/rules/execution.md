## Execution review loop

The main agent orchestrates this loop, invoking the Reviewer as a subagent.

### During execution

- Record HEAD SHA before the first implementation commit (base commit for the review diff)
- Make one commit per plan step (granular rollback points)
- Follow the plan. Only update it when review findings or implementation blockers require it, not for scope changes. If a scope change seems necessary, stop and surface it to the user before proceeding.

### After all steps complete

Run a review loop on the accumulated diff:

1. Get the diff from the base commit to HEAD.
2. Send the diff and plan/spec to the Reviewer agent in `final` mode.
3. Check the VERDICT line:
    - CLEAR: Exit the loop.
    - LOW: Exit the loop. LOW findings are included in the report. The implementer may remediate them at their judgement, but the loop does not require it.
    - MEDIUM or HIGH: Accept, partially accept, or reject each finding. For partially accepted findings, note which parts are rejected (with reasoning) and process the accepted parts through remediation. Rejected findings are noted with reasoning but not remediated.
4. On iterations 2+, send the previous iteration's findings with your disposition of each (accepted, partially accepted, or rejected) and reasoning to the Reviewer as context.
5. Stop after 6 iterations regardless of verdict.
6. Report the review summary to the user:
    ```
    **Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | max iterations].
    ```
    Include LOW and rejected findings below the summary. On max-iteration exit with high-impact findings, note whether the same finding persisted or new issues emerged.

### Remediation

**Fix findings**: Apply as a single fix commit per affected step. Multi-step findings are attributed to the earliest affected step.

**Rollback findings** follow a three-phase sequence:

1. **Revert**: Starting from the latest step, revert commits back to the earliest rollback step. Reverse order keeps reverts clean since later code may differ from when the step was committed.
2. **Fix**: Apply fix commits for steps before the rollback point.
3. **Re-implement**: Re-implement from the rollback point forward with all review findings as context.

**Subsumption**: If any finding for a step says rollback, treat the entire step as rollback regardless of other fix findings for that step. This is resolved at remediation time.

**Full reset** (rolling back all steps) is rare and signals a bad plan. If triggered, stop and surface to the user rather than proceeding autonomously.

Example: Steps 1-5 committed. Reviewer says step 2 needs fix, step 4 needs rollback.

1. Revert commits for steps 5, 4 (reverse order)
2. Apply fix commit for step 2
3. Re-implement steps 4, 5 with review findings as context

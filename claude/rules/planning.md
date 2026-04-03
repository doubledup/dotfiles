## Plan review loop

When producing a plan with 3 or more implementation steps, run a review loop before presenting it to the user.

If a slash command (e.g., /feature) defines its own review process, follow that instead.

1. Send the plan to the Reviewer agent in `plan` mode. Include the full plan text and, if applicable, the problem statement or spec.
2. Check the VERDICT line:
    - CLEAR or LOW: Exit the loop.
    - MEDIUM or HIGH: Use your best judgement to fully accept, partially accept, or reject each finding. Revise the plan accordingly, then re-review.
3. On iterations 2+, include:
    - The previous iteration's findings with your disposition of each (accepted, partially accepted, or rejected) and reasoning
    - A bullet list of what changed in the plan since last review
4. Stop after 6 iterations regardless of verdict.

Present the review summary immediately before the plan:

```
**Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | max iterations].
```

If findings remain, list them below the summary grouped by severity. If max iterations reached with high-impact findings, note whether the same finding persisted or new issues emerged.

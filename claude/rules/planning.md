## Plan review loop

When producing a plan with 3 or more implementation steps, run a review loop before presenting it to the user. For plans with fewer steps, consider running a review if the changes involve security, deletion, or external-facing interfaces.

If a slash command (e.g., /feature) defines its own review process, follow that instead.

1. Send the plan to the Reviewer agent in `plan` mode. Include the full plan text and, if applicable, the problem statement or spec.
2. Check the VERDICT line:
    - CLEAR or LOW: Exit the loop. LOW findings are included in the review summary presented to the user.
    - MEDIUM or HIGH: For each finding, fully accept, partially accept, or reject it. Revise the plan for accepted/partially accepted findings.
    - If the reviewer's output lacks a valid VERDICT line, infer the verdict from the highest severity section present in the output. No findings sections = CLEAR.
3. On iterations 2+, include:
    - The previous iteration's findings with your disposition of each (accepted, partially accepted, or rejected) and reasoning
    - A bullet list of what changed in the plan since last review
4. The loop exits only when the reviewer returns CLEAR or LOW, or after 6 iterations (hard cap). Rejecting findings does not exit the loop; the reviewer must confirm that rejections were sound or re-raise them. If the same finding (same design decision or concern) is rejected and re-raised across two consecutive iterations, escalate to the user rather than continuing the loop.

### Disposition discipline

When evaluating reviewer findings about your own plan, apply a presumption of validity. For each finding:

- **To accept**: No justification required.
- **To partially accept**: State which parts you accept and which you reject, with reasoning for the rejection.
- **To reject**: Provide a specific, falsifiable reason (e.g., "the file already handles this at line 42" or "this pattern is established in X, Y, Z"). "I disagree" or "this is fine" is not sufficient. If you cannot articulate a concrete reason, accept the finding.

Present the review summary immediately before the plan:

```
**Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | max iterations].
Rejected findings: [finding summary]: [rejection reasoning]
```

Omit the rejected line if none were rejected. If findings remain, list them below the summary grouped by severity. If max iterations reached with high-impact findings, note whether the same finding persisted or new issues emerged.

## Diff size

Plans should target 400 or fewer changed lines. Warn at 400+; suggest splitting at 1500+.

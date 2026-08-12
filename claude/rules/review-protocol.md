## Review loop protocol

Shared mechanics for plan and execution review loops. Both `planning.md` and `execution.md` reference this file.

### VERDICT handling

- CLEAR or LOW: exit the loop. Include LOW findings in the report.
- MEDIUM or HIGH: for each finding, fully accept, partially accept, or reject it. Apply the mode-appropriate action for accepted findings (revise the plan, or apply remediation). Rejected findings are not remediated but are included with disposition in the next iteration.
- If the reviewer's output lacks a valid VERDICT line, infer from the highest severity section present. No findings sections = CLEAR.

### Output validation

- If the reviewer's output omits the Investigation section (plan and final modes), re-invoke with a reminder to investigate before assessing.

### Disposition discipline

Apply a presumption of validity to findings of **defect**: something is wrong, broken, or
factually incorrect.

- **To accept**: no justification required.
- **To partially accept**: state which parts you accept and reject, with reasoning for the rejected parts.
- **To reject**: provide a specific, falsifiable reason grounded in code (e.g., "handled at line N" or "matches the pattern in file X"). "I disagree" or "this is fine" is not sufficient. If you cannot articulate a concrete reason, accept the finding.

The presumption does **not** extend to findings of **omission**: a finding whose remedy is
to add code, config, documentation, or a guard must state what breaks without it. If it
cannot name a concrete failure, rejecting it needs no further justification.

Why: accepting is free and rejecting is expensive, so the cheapest path through the loop is
always to add. Findings overwhelmingly propose additions, which makes the loop a one-way
ratchet that terminates by accretion rather than by convergence. This clause is the
counterweight. Prefer the smallest change that resolves a finding, and say so when a
finding is accepted in a smaller form than proposed.

### Iteration tracking

- On iterations 2+, send the previous iteration's findings with your disposition of each (accepted, partially accepted, rejected) and reasoning.
- The loop exits only when the reviewer returns CLEAR or LOW, or after 6 iterations (hard cap). Rejecting findings does not exit the loop; the reviewer must confirm rejections were sound or re-raise.
- If the same finding is rejected and re-raised across two consecutive iterations, escalate to the user.

### Report format

Present the review summary to the user:

```
**Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | max iterations].
Rejected findings: [finding summary]: [rejection reasoning]
```

Omit the rejected line if none were rejected. Include LOW findings below the summary. On max-iteration exit with high-impact findings, note whether the same finding persisted or new issues emerged.

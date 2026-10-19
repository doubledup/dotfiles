---
name: ship
description:
    Plan, execute, and review a non-trivial change with approval gates and Reviewer loops. Use
    before implementing any change that modifies Claude Code configuration (rules, agents, skills,
    hooks, settings), touches security, deletion, or external-facing interfaces, or takes 3 or more
    steps, whether or not the user names this skill.
---

# Ship

Plan, get approval, execute concern by concern, review the diff. Change request: $ARGUMENTS

## 1. Plan

1. Explore first: read the relevant files, trace dependencies, note existing patterns. Ask only when
   the answer would change direction.
2. Draft the plan. The plan the user reads stays short; length is a review-quality tax. Default
   structure, and little else:
    - Files touched (a table)
    - The main design decision
    - At least one rejected alternative, with the reason
    - The assertions used to verify the change (for UI-affecting changes, specific manual checks)
3. Budget the diff: target 400 or fewer changed lines; suggest splitting at 400+; split at 1500+
   unless there is extraordinary justification.
4. If any trigger in this skill's description applies, run the review loop (below) with the Reviewer
   agent in `plan` mode. Send the full plan, the files it will modify or create, and the problem
   statement. On iterations 2+, also list what changed.
5. Compress after the loop exits: findings that only mattered to the reviewer do not belong in the
   plan. Cut restatement of the request, trailing summaries, and preamble.
6. Present the review summary, then the plan. **Stop until the user approves.**

## 2. Execute

- Record the current HEAD SHA as the review base before the first edit.
- Follow the plan. Update it only when a review finding or blocker requires it; stop and ask before
  any scope change.
- Commit concern by concern: finish one concern's edits across all its files, commit, then start the
  next. Don't run the full test suite per commit; a cheap check on a just-edited file is fine.
- If a step still fails after 2 debugging attempts, stop and ask.

## 3. Review

1. Run project verification (format, lint, tests for the files changed) once; fix failures and
   commit the fixes, since `/full-review` needs a clean working tree.
2. Size the range with `git diff <base>..HEAD --stat`. At 20 or fewer changed lines, skip review and
   show the user the diff. Warn above 400; above 1500, ask whether to review or split.
3. Run the review loop with `/full-review HEAD <base>`, passing the plan and verification results as
   intent. Every iteration reviews the full range with all three sources.
4. Land fixes as fix-up commits (or amend the latest commit if it is the natural home and unpushed),
   re-verify (committing any verification fixes), and re-enter the loop. If a finding is marked
   rollback, stop and surface it with the suggested approach rather than re-implementing.
5. Present the review summary, then what changed and any follow-ups (or that nothing changed).

## Review loop

- A source marked `FAILED` stops the loop: ask the user to retry, change the target, or proceed
  without it. Check this before reading any verdict.
- Verdict CLEAR or LOW exits; report LOW findings. MEDIUM or HIGH: accept, partially accept, or
  reject each finding, act on accepted ones, and re-invoke. No VERDICT line: infer from the highest
  severity section present. Missing Investigation section in the plan loop: re-invoke asking for it
  (`/full-review` handles this itself).
- Findings of defect (something wrong or broken) are presumed valid. Accept freely; reject only with
  a specific, falsifiable reason grounded in code ("handled at line N"). Partial accepts state what
  is rejected and why.
- Findings of omission (remedy adds code, config, docs, or a guard) must name what breaks without
  the addition; if they can't, reject without further justification. Otherwise the loop ends by
  accretion, not convergence. Prefer the smallest change that resolves a finding, and say so when
  accepting in a smaller form.
- On iterations 2+, send the previous findings with each disposition and its reasoning. Rejections
  do not exit the loop; the reviewer must confirm or re-raise. A finding rejected and re-raised in
  two consecutive iterations goes to the user.
- Cap: 3 iterations. On a cap exit with MEDIUM or HIGH findings, say whether they persisted or were
  new, and ask the user whether to run another 3 iterations. Repeat until nothing is at MEDIUM or
  above, or the user says to proceed.

Report format, immediately before the plan or final summary:

```
**Review loop**: N iteration(s). Exit: [all findings resolved | only low-impact remain | user said proceed at the cap].
Rejected findings: [finding summary]: [rejection reasoning]
Coverage gaps: [source]: [partial | no coverage]
```

Omit the rejected and coverage lines when empty; list LOW findings below it.

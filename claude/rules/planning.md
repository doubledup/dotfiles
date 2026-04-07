## Plan review loop

Run a review loop before presenting a plan to the user when any of these apply:

- Changes modify Claude Code configuration (rules, agents, commands)
- Changes involve security, deletion, or external-facing interfaces
- 3 or more implementation steps

The first two triggers apply regardless of plan size. Do not skip review for a 1-2 step plan that modifies rules, agents, or commands.

If a slash command (e.g., /feature) defines its own review process, follow that instead.

1. Send the plan to the Reviewer agent in `plan` mode. Include the full plan text, the list of files the plan will modify or create, and, if applicable, the problem statement or spec.
2. For VERDICT handling, disposition discipline, and iteration tracking, follow `review-protocol.md`.
3. On iterations 2+, also include a bullet list of what changed in the plan since last review.

Present the review summary (per `review-protocol.md` report format) immediately before the plan.

## Diff size

Plans should target 400 or fewer changed lines. Warn at 400+; suggest splitting at 1500+.

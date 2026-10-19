---
paths:
    - "**/backlog-doubledup/**"
---

# Backlog

Adding items is in the user CLAUDE.md Workflow. This covers working a backlog, which happens only
when asked ("continue the backlog"):

- `README.md` is the only place that orders items: Next holds exactly one item, the highest
  priority; Remaining is a flat list. Area prefixes, if any, are listed in the README
- If Next is empty, first promote the highest-priority Remaining item and say which
- Work the Next item, or the one the user names; follow the `ship` skill if it is non-trivial
- When done, delete the item file and its README line (backlogs have no history, so confirm the work
  landed first), then promote the highest-priority Remaining item to Next and say which
- Link related items by filename

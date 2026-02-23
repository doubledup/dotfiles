---
name: PR Comms
description: GitHub PR descriptions and review comments--direct, concrete, team-oriented
keep-coding-instructions: true
---

Voice (PR-specific):
- `we` language for team decisions and standards
- Professional and calm; no cheerleading
- Include links to context (tickets, prior PRs, docs) when they inform decisions

Review comments:
- Review tags: `nit:`, `suggestion:`, `question:`, `issue:`, `request:`
- Three-tier severity: `issue(blocking):` for merge blockers, `issue(non-blocking):` for important follow-ups, `nit:` for polish/consistency. Default non-blocking.
- One idea per comment
- When the fix is known, propose it directly; use suggestion blocks when helpful
- Prefer consistency with existing in-repo conventions unless there is a strong reason to diverge
- When listing multiple files, use bullet lists with link text shortened to filename + line
- When partially addressed, enumerate exactly what remains--name files, fields, lines. No vague "a few places" phrasing.
- Avoid directive close-out wording in non-blocking comments (e.g., "Let's close this out in this PR")
- Ask questions only when information is missing; otherwise recommend a change
- Brief rationale: why it matters (correctness, consistency, maintainability, operational risk)

PR descriptions:
- Follow the project's PR template (`.github/PULL_REQUEST_TEMPLATE.md` or similar) when one exists
- When no template exists, use: `## Description`, `## Related Issue(s)`, `## Testing Done`
- Description: what changed, why (root cause / decision context), scope boundaries and tradeoffs
- Compact bullets for discrete changes
- Testing Done: exact commands and validation; be explicit when testing was not done

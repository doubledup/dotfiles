---
name: authored-voice
description:
    Tone, register, and conventions for text written in the user's voice. Use before drafting or
    editing a PR description, a PR review comment or reply, a Slack message, Jira ticket text or
    comment, or hiring feedback.
---

Read [voice.md](voice.md) (tone and register) before drafting anything.

Voice (PR-specific):

- Prefer natural team-oriented language; use `we` when it feels authentic, not in every line.
- Professional and calm; no cheerleading
- Never use em dashes. Use commas, periods, semicolons, or parentheses instead.

Review comments:

- Review tags: `nit:`, `suggestion:`, `question:`, `issue:`, `request:`
- No bold in review comments, tags included: `nit: ...`, not `**nit:** ...`
- Three-tier severity: `issue(blocking):` for merge blockers, `issue(non-blocking):` for important
  follow-ups, `nit:` for polish/consistency (typos, naming). Default non-blocking.
- One idea per comment
- When the fix is known, propose it directly; use suggestion blocks when helpful
- Prefer consistency with existing in-repo conventions unless there is a strong reason to diverge
- Link every file mentioned with a permalink (blob URL pinned to the commit SHA, not a branch), with
  a line anchor (`#L44-L55`) when pointing at specific code
- When listing multiple files, use bullet lists with link text shortened to filename + line
- When partially addressed, enumerate exactly what remains--name files, fields, lines. No vague "a
  few places" phrasing.
- Avoid directive close-out wording in non-blocking comments (e.g., "Let's close this out in this
  PR")
- Ask questions only when information is missing; otherwise recommend a change
- Brief rationale: why it matters (correctness, consistency, maintainability, operational risk)

PR descriptions:

- Follow the project's PR template (`.github/pull_request_template.md` or similar) when one exists
- When no template exists, use: `## Description`, `## Related Issue(s)`, `## Testing Done`
- Description: what changed and why, in 3-6 sentences or bullets. One clause of root cause. Name
  what is deliberately out of scope if a reader would otherwise expect it. Then stop.
- Cut: how a fact was established (that is Testing Done), anything the diff already shows, commit
  bodies restated, background a linked ticket or PR already carries, and what is always implicit
  (e.g. that merged IaC deploys per environment via CI)
- Links: one per claim that needs context (ticket, prior PR), as markdown links. Link instead of
  explaining
- Testing Done: one line per check, the command and what it showed. Say plainly when nothing was run
- No line width limits (unlike commits); let lines wrap naturally

Replies:

- Substantiate documentation/behavior claims with a link to the source (code, official docs,
  schema), not just an assertion
- Keep review-thread replies short: one sentence stating the outcome (fixed in `<sha>`, or the
  reason for rejecting), without restating context already covered elsewhere

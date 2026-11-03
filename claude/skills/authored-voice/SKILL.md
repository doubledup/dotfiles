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

- Format comments per Conventional Comments (conventionalcomments.org):
  `<label> [decorations]: <subject>`, then an optional discussion paragraph
- Labels: `praise:`, `nitpick:`, `suggestion:`, `issue:`, `todo:`, `question:`, `thought:`,
  `chore:`, `note:`, `typo:`, `polish:`
- Decorations go in one pair of parentheses after a space, comma-separated: `issue (blocking):`,
  `suggestion (security,if-minor):`
- Bare labels are non-blocking; mark anything that must change before merge `(blocking)`, whatever
  the label. `(if-minor)` asks for the change only if it stays small
- No bold in review comments, labels included: `nitpick: ...`, not `**nitpick:** ...`
- Low-impact findings, when commented at all, are `nitpick:`, `typo:`, or `polish:`
- Use `praise:` for something specifically done well, in one line naming what and why
- With no blocking comments, approve and let the author decide what to take; with blocking comments,
  submit as a comment; request changes only when a blocking comment flags something that would break
  the system if merged
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

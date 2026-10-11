---
paths:
    - "**/*.md"
    - "**/.claude/**"
    - "**/claude/**"
---

# Durable Prose

Applies to prose that lives in a repo: docs, code comments, Claude Code config, rules files.

- Write timeless content: the standing rule, a representative example, and a concise justification.
  Nothing else earns its space.
- Don't describe past repo state. "X was removed", "an earlier hook used to catch this", "this was
  inert until the fix" all go stale and cost space on every future read. State what holds now and
  why.
- Rewrite history into the rule it produced. A bug worth documenting becomes "spell it this way,
  because the other way fails silently", not an account of when it was found.
- Keep provenance ("measured", "verified live") when a claim was expensive to establish or
  contradicts official docs. That is evidence for the claim, not history, and it tells the next
  reader the claim was tested rather than inferred.
- Prefer a link to the authoritative doc over restating it. Document only what the link doesn't
  cover: the local consequence, the exception, the thing that surprised us.

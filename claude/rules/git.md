# Git

## Commit Messages

- Small, logically grouped changes (one concern per commit)
- Imperative mood, sentence case, no period (e.g., "Add feature command")
- Title: 54 characters max
- Body: 72 characters max line width; omit unless the diff needs extra context
- No attribution lines (no Co-Authored-By)
- Start with a verb: Add, Remove, Bump, Revise, Clean up, Fix, Move, Set up, Update
- Formatting-only commits: "fmt"

## PR Descriptions

- Follow the project template (`.github/pull_request_template.md`)
- No line width limits (unlike commits); let lines wrap naturally
- Description: what changed, why (root cause or decision context), scope boundaries and tradeoffs
- Compact bullets for discrete changes
- Testing Done: exact commands and observed results; be explicit when testing was not done
- Link related Jira issues as markdown links

## PR Voice

- Prefer natural team-oriented language; use "we" when it feels authentic, not in every line
- Professional and calm; no cheerleading
- Never use em dashes; use commas, periods, semicolons, or parentheses instead
- Include links to context (tickets, prior PRs, docs) when they inform decisions

# Global Preferences

## Environment

- Shell: fish
- Editor: neovim
- Terminal: kitty
- OS: macOS primary, Linux occasionally
- Search: rg (ripgrep), fd (not grep/find)

## Communication

- Concrete examples or apt analogies over abstract explanations
- Make reasonable inferences; ask when the answer would meaningfully change direction

## Workflow

- Explore before coding: read files, understand existing patterns first
- Plan before implementing: propose approach, wait for approval on non-trivial changes
- Verify after changes: run tests, check compilation
- Smallest focused changes per commit--functional but minimal

## Session Discipline

- Keep sessions focused; start fresh for new topics
- When executing an approved plan, start immediately--don't re-explore
- Only modify files within the current task scope
- Before /compact: note modified files, current phase, key decisions
- When a session drifts, prefer /clear + handoff file over recovery

## Thinking

- Quick fixes: no trigger needed
- Design decisions: "think hard"
- Architecture, stuck loops, complex debugging: "ultrathink"
- Always explore and plan before ultrathink tasks

## Safety

- Never use `--no-verify` on commits
- Never commit `.env`, `.envrc`, secrets, or credentials
- Verify no secrets in diffs before committing
- Auto-allow only read-only Bash operations; write operations and web queries require user approval

## PR Communications

- Use the pr-comms output style (`~/.claude/output-styles/pr-comms.md`) for all PR descriptions and review comments

## Persistence

- Project-wide decisions, policies, and conventions go in repo-committed files (CLAUDE.md, .claude/rules/, DESIGN.md) so they're shared across machines
- Claude memory files (~/.claude/projects/.../memory/) are machine-local; use only for per-user preferences that don't belong in the repo

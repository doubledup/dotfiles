# Global Preferences

## Environment

- Shell: fish
- Editor: neovim
- Terminal: kitty
- OS: macOS primary, Linux occasionally
- Search: rg (ripgrep), fd (not grep/find)

## Communication

- Answer first, context after
- Senior developer technical level
- Short, clear sentences; Hemingway over academic
- Prose for explanations; bullets only for discrete items (steps, options, comparisons)
- Brevity by default; I'll ask for depth
- State uncertainty explicitly, no hedging or sycophancy
- Concrete examples or apt analogies over abstract explanations
- Distinguish facts from inference
- Make reasonable inferences; ask when the answer would meaningfully change direction
- Mention alternative approaches briefly when relevant
- Flag non-obvious risks or considerations, briefly

## Workflow

- Explore before coding: read files, understand existing patterns first
- Plan before implementing: propose approach, wait for approval on non-trivial changes
- Verify after changes: run tests, check compilation
- Smallest focused changes per commit--functional but minimal

## Thinking

- Quick fixes: no trigger needed
- Design decisions: "think hard"
- Architecture, stuck loops, complex debugging: "ultrathink"
- Always explore and plan before ultrathink tasks

## Safety

- Never use `--no-verify` on commits
- Never commit `.env`, `.envrc`, secrets, or credentials
- Verify no secrets in diffs before committing

## Extended Docs

@~/.claude/docs/git.md

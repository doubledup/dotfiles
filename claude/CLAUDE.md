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
- State uncertainty explicitly, no hedging
- Brevity by default; I'll ask for depth
- Concrete examples over abstract explanations

## Workflow
- Explore before coding: read files, understand existing patterns first
- Plan before implementing: propose approach, wait for approval on non-trivial changes
- Verify after changes: run tests, check compilation
- Smallest focused changes per commit—functional but minimal
- Ask once if unclear, then proceed with best judgment

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
<!-- Add @imports here as needed, e.g.: -->
<!-- @~/.claude/docs/rust.md -->
<!-- @~/.claude/docs/git.md -->

## Language Rules
<!-- Link to ~/.claude/rules/*.md files as needed -->

# Repository Guidelines

## Scope

This file applies at the repository root and below unless a deeper `AGENTS.md` overrides it.

## Non-Negotiables

- NEVER run the `claude` command (`claude`, `/opt/homebrew/bin/claude`, or wrappers/aliases).
- Do not request escalation or workarounds to execute `claude`.
- Do not run destructive commands unless explicitly requested (for example `git reset --hard`, broad `rm`, history rewrites).
- Do not manually edit generated state: `Session.vim`, `config/fish/fish_variables`, `.jdtls/`.

Enforcement note: this file is repository policy, not an OS sandbox. To hard-block `claude` in future sessions, disable or remove the binary at the environment level.

## Instruction Handling (Codex)

- Follow active system/developer/user instructions first.
- If higher-priority instructions force deviation from this file, follow them and state the deviation clearly.
- Keep edits minimal and aligned with existing patterns.
- Ask before ambiguous or high-impact changes (linking strategy, cross-OS behavior, package management, broad refactors).

## Canonical Project Guidance

`CLAUDE.md` is the canonical source for repository conventions (rcm behavior, naming conventions, Neovim layout rules, and workflow expectations). Do not duplicate or fork those rules here; update `CLAUDE.md` when conventions change.

Read additional context only when relevant:

- `README.md` for setup/usage.
- `justfile` for executable checks and workflows.
- `DESIGN.md` for architecture decisions.

## Validation and Final Response

After all edits (including docs-only):

- Run `just check`.
- Run `just test`.

Final response must include:

- Files changed.
- Verification commands run and key outcomes.
- Any failures, blockers, or unverified items.

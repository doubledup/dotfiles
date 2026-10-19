## Environment

- Shell: fish; editor: neovim; terminal: kitty; OS: macOS primary, Linux occasionally
- Search: rg and fd, not grep/find
- GitHub username: doubledup

## Communication

- Lead with the direct answer, then the reasoning; prose by default; expand only when tradeoffs
  require it or when asked
- Ask when the answer would meaningfully change direction
- State uncertainty and corrections plainly, without hedging or apology; distinguish facts from
  inference explicitly
- Briefly flag non-obvious risks or alternatives when relevant
- No em dashes

## Workflow

- Explore before coding; plan and get approval before non-trivial changes (procedure: `ship` skill);
  verify after changes; keep commits small and focused
- Record only follow-ups and friction of medium or higher impact (likely wrong behavior, lost work,
  a security gap, or recurring friction) without interrupting the task, as a file (`# Title`, what
  and why) in `backlog-doubledup/` plus a `- [Title](file.md)` line under Remaining in its
  `README.md` (create it with `# Backlog`, `## Next`, `## Remaining` if missing). Project items: at
  the main checkout root (`git rev-parse --path-format=absolute --git-common-dir`'s parent), so
  worktrees share it; user-config items (Claude Code, shell, editor, tools): in `~/.dotfiles/`. If a
  write is refused, list them for me; otherwise read a backlog only when asked ("continue the
  backlog")
- When I ask for design input or review, prefer deep modules (narrow interface, substantial
  implementation) [Ousterhout], check whether what I call easy complects concerns [Hickey], and
  justify novelty as a spent innovation token [McKinley]; say when a case warrants breaking one

## Safety

- Never use `--no-verify`; never commit `.env`, `.envrc`, secrets, or credentials; check diffs for
  secrets before committing
- Keep secrets in home config only, never in a repo (not even git-ignored): an in-tree secret is
  readable by search. Search contents with `rg` in Bash (sandboxed), not the denied `Grep` tool
- Never export, print, or write cloud credentials to env vars or files (no `export-credentials`, no
  `AWS_*` keys). Sign in-process with the named profile (botocore `Session(profile_name=...)`)
- Bash runs sandboxed; retry unsandboxed only when no in-sandbox fix exists. Suggest `!` for
  sandbox-blocked maintenance (brew, rustup, cargo, plugin sync)
- Use synthetic data only: never ask for, read, or paste real customer data, log exports, or table
  dumps. If debugging needs data, ask me for a synthetic reproduction
- If unsure whether a tool, command, or capability exists, say so rather than fabricating details
- Never send my email or other personal details to an outside service unless I ask: not in a
  User-Agent, header, URL, or payload. Where a service asks for contact details (crates.io), use the
  repo's URL

## Sandbox Mechanics

- Only `$TMPDIR` is writable for temp files: `mktemp "${TMPDIR:-/tmp}/name-XXXXXX"`, never bare
  `mktemp`. `diff` with a pipe or `/dev/null` fails the same way; diff two real files
- `excludedCommands` (`gh`, `git commit`) run unsandboxed only as a lone foreground call; a pipe,
  redirect, chain, loop, env prefix, or background run sandboxes them. Process output separately
- Bash can write in the working directory; prefer it over Write for byte-exact copies

## Repo Text and Persistence

- Docs, config, and comments state what holds now and why, never past state or comparisons with it
  ("was removed", "no longer", "now fetches"); history belongs in the commit message
- Project-wide decisions and conventions go in repo-committed files (CLAUDE.md, .claude/rules/,
  DESIGN.md); memory files are machine-local, only for per-user preferences

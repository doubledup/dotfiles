# Global Preferences

## Environment

- Shell: fish; editor: neovim; terminal: kitty; OS: macOS primary, Linux occasionally
- Search: rg and fd, not grep/find
- GitHub username: doubledup

## Communication

- Lead with the direct answer, then supporting reasoning
- Be concise and precise; Hemingway over academic; default to prose
- Make reasonable inferences; ask when the answer would meaningfully change direction
- Briefly flag non-obvious risks or alternative approaches when relevant
- State uncertainty and corrections plainly, without hedging or apology
- No preamble praise or filler; expand only when tradeoffs require it or when asked
- Distinguish facts from inference explicitly
- No em dashes
- Use pragmatic analogies that illuminate without over-explaining

## Workflow

- Explore before coding; plan and get approval before non-trivial changes (procedure: `ship` skill);
  verify after changes; keep commits small and focused

## Design Defaults

When I ask for design input or review (not unprompted), apply these; say so when a case warrants
breaking one. Prefer deep modules (narrow interface, substantial implementation) [Ousterhout].
"Easy" is not "simple"; check whether what I call easy complects concerns [Hickey]. New tech spends
an innovation token; justify novelty [McKinley].

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
- `raw.githubusercontent.com` is blocked; use `api.github.com` with
  `-H "Accept: application/vnd.github.raw"`
- Filename deny rules over-match: `Bash(*.env*)` blocks fetching `.env.example`
- `excludedCommands` (`gh`, `git commit`) run unsandboxed only as a lone foreground call; a pipe,
  redirect, chain, loop, env prefix, or background run sandboxes them. Process output separately
- Bash can write in the working directory; prefer it over Write for byte-exact copies

## Repo Text

- Docs, config, and code comments state what holds now and why. Don't describe past repo state or
  compare with an earlier version ("was removed", "no longer", "now fetches"); that belongs in the
  commit message

## Persistence

- Project-wide decisions and conventions go in repo-committed files (CLAUDE.md, .claude/rules/,
  DESIGN.md); memory files are machine-local, only for per-user preferences

# Global Preferences

## Environment

- Shell: fish
- Editor: neovim
- Terminal: kitty
- OS: macOS primary, Linux occasionally
- Search: rg (ripgrep), fd (not grep/find)
- GitHub username: doubledup

## Communication

- Lead with the direct answer, then supporting reasoning
- Be concise and precise; Hemingway over academic; default to prose
- Make reasonable inferences; ask when the answer would meaningfully change direction
- Briefly flag non-obvious risks or alternative approaches when relevant
- State uncertainty and corrections plainly, without hedging or apology
- No preamble praise or filler
- Expand only when tradeoffs require it or when asked
- Distinguish facts from inference explicitly
- Include confidence levels as percentages when answering questions
- No em dashes
- Use pragmatic analogies that illuminate without over-explaining

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

## Design Defaults

Apply these when I ask for design input or review; don't restructure toward them or reject libraries on their basis unprompted. They are defaults: when a case genuinely warrants breaking one, say so rather than ratifying it because it is listed.

- Prefer deep modules: narrow interface, substantial implementation; flag shallow ones. [Ousterhout]
- "Easy" (familiar/at-hand) is not "simple" (one concept, decoupled); when I call something easy, check whether it complects concerns. [Hickey]
- New tech spends an innovation token; justify novelty explicitly. [McKinley]

## Safety

- Never use `--no-verify` on commits
- Never commit `.env`, `.envrc`, secrets, or credentials
- Keep secrets in home config only, never in a repo (not even git-ignored): the sandbox bounds Bash reads of home secrets, but an in-tree secret is readable by search. The built-in `Grep` tool is denied (it bypasses the sandbox); search file contents with `rg` in Bash, where the sandbox applies
- Never export, print, or write cloud credentials to environment variables or files. No `aws configure export-credentials`, no `eval "$(... export-credentials ...)"`, no setting `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`/`AWS_SESSION_TOKEN`. To make signed requests, sign in-process with the named profile (e.g. botocore `Session(profile_name=...)`), which resolves SSO without materializing secrets
- Verify no secrets in diffs before committing
- Sandboxed Bash auto-runs without a prompt (`sandbox.autoAllowBashIfSandboxed: true`); the OS sandbox is the containment boundary. The `deny`/`ask` rules and the guard hooks still gate the dangerous subset (destructive verbs, secret reads, egress, `git push`), and a command that cannot be sandboxed fails rather than running unsandboxed
- Bash runs in a strict OS sandbox; deny rules bind and home/fixed-dir secret reads (`~/.env`, `~/.aws`, `~/.ssh`, `~/.gnupg`) are blocked. Run sandbox-blocked maintenance (brew, rustup, cargo, plugin sync) yourself via `!`, never via `dangerouslyDisableSandbox`
- If unsure whether a tool, command, or capability exists, say so rather than fabricating details

## Authored Voice

- For Slack messages, PR descriptions/comments, git commit messages, and Jira comments, calibrate tone, register, and directness per `~/.claude/docs/david-style.md`.
- Use the pr-comms output style (`~/.claude/output-styles/pr-comms.md`) for PR-specific formatting (review tags, template structure).

## Persistence

- Project-wide decisions, policies, and conventions go in repo-committed files (CLAUDE.md, .claude/rules/, DESIGN.md) so they're shared across machines
- Claude memory files (~/.claude/projects/.../memory/) are machine-local; use only for per-user preferences that don't belong in the repo

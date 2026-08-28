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

Apply these when I ask for design input or review; don't restructure toward them or reject libraries
on their basis unprompted. They are defaults: when a case genuinely warrants breaking one, say so
rather than ratifying it because it is listed.

- Prefer deep modules: narrow interface, substantial implementation; flag shallow ones. [Ousterhout]
- "Easy" (familiar/at-hand) is not "simple" (one concept, decoupled); when I call something easy,
  check whether it complects concerns. [Hickey]
- New tech spends an innovation token; justify novelty explicitly. [McKinley]

## Safety

- Never use `--no-verify` on commits
- Never commit `.env`, `.envrc`, secrets, or credentials
- Keep secrets in home config only, never in a repo (not even git-ignored): the sandbox bounds Bash
  reads of home secrets, but an in-tree secret is readable by search. The built-in `Grep` tool is
  denied (it bypasses the sandbox); search file contents with `rg` in Bash, where the sandbox
  applies
- Never export, print, or write cloud credentials to environment variables or files. No
  `aws configure export-credentials`, no `eval "$(... export-credentials ...)"`, no setting
  `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`/`AWS_SESSION_TOKEN`. To make signed requests, sign
  in-process with the named profile (e.g. botocore `Session(profile_name=...)`), which resolves SSO
  without materializing secrets
- Verify no secrets in diffs before committing
- Bash runs in a strict OS sandbox, the containment boundary, and auto-runs without a prompt.
  `deny`/`ask` rules and the guard hooks still gate the dangerous subset (destructive verbs, secret
  reads, egress, `git push`); a command that cannot be sandboxed fails rather than running
  unsandboxed. Run sandbox-blocked maintenance (brew, rustup, cargo, plugin sync) yourself via `!`,
  never via `dangerouslyDisableSandbox`
- If unsure whether a tool, command, or capability exists, say so rather than fabricating details

## Agent Authoring

- To guarantee a subagent has a skill's content, use the `skills:` frontmatter field, which injects
  the full skill body at startup. Not `Skill` in `tools` (grants every skill, and invocation is
  discretionary/best-effort), not a hook, not duplicating the content into the prompt
- Anything behind an instruction to load, fetch, or invoke is model-mediated. If it must always
  apply, it must always be in context

## Sandbox Mechanics

Operational gotchas, not policy. `$TMPDIR` points at a writable session temp dir; the system temp
dir (`/var/folders/.../T` on macOS) is not, so tools that ignore `$TMPDIR` fail with a cryptic
"Operation not permitted":

- `mktemp` with no template resolves the system temp dir. Always pass one:
  `mktemp "${TMPDIR:-/tmp}/name-XXXXXX"`
- `diff` copies non-seekable inputs to a system temp file, so `cmd | diff file -` and any
  `diff /dev/null ...` fail. Redirecting a real file (`diff file - < other`) works, since it is
  seekable. Write the input to `$TMPDIR` and diff two real files
- `raw.githubusercontent.com` is not in `allowedDomains`. Fetch file contents from `api.github.com`
  with `-H "Accept: application/vnd.github.raw"`, which also avoids base64 and jq
- Filename-matched deny rules fire on innocent paths: fetching `.env.example` is blocked by
  `Bash(*.env*)`
- Bash **can** write inside the working directory. Prefer it over Write for byte-exact work (copying
  vendored files, hashing) where transcription would risk error

Widening `sandbox.filesystem.allowWrite` to the system temp dir would fix the first two;
deliberately not done (shared with every app; the session dir exists to contain temp writes).

## Authored Voice

- For Slack messages, PR descriptions/comments, git commit messages, and Jira comments, calibrate
  tone, register, and directness per `~/.claude/docs/david-style.md`.
- Use the pr-comms output style (`~/.claude/output-styles/pr-comms.md`) for PR-specific formatting
  (review tags, template structure).

## Durable Prose

Applies to prose that lives in the repo: docs, code comments, Claude Code config, rules files.

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

## Persistence

- Project-wide decisions, policies, and conventions go in repo-committed files (CLAUDE.md,
  .claude/rules/, DESIGN.md) so they're shared across machines
- Claude memory files (~/.claude/projects/.../memory/) are machine-local; use only for per-user
  preferences that don't belong in the repo

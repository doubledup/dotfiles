# Permission model and checks

## Model

One judgment layer, a short list of hard stops, and one human gate. No OS sandbox, no enforcement
hooks.

- **Auto mode classifier** judges every action not settled by a rule: read-only actions and edits in
  the working directory are auto-approved, everything else is classified. It sees user messages,
  tool calls and CLAUDE.md, not tool results, so injected text in a file or ticket can't argue with
  it. `autoMode.environment` (user scope only) tells it where production and personal information
  live.
- **`deny`** for actions that are irreversible or expose credentials or customer data: secret paths,
  credential export, force/delete/prune pushes, `--no-verify`, recursive delete, remote-destroying
  CLI verbs, the main AWS write-verb families on every profile, destructive MCP runners.
- **`ask`** for actions a human must see first: config that steers or runs code in future sessions
  (CLAUDE.md, `.claude/` settings, hooks, skills, agents, commands, rules, workflows, output styles,
  docs, `.mcp.json`, `.pre-commit-config.yaml`, `.githooks/`, `~/.dotfiles/claude/`, and
  `git config` setting `core.hooksPath` or `core.fsmonitor`), publish steps (PR creation where it's
  the review gate, terraform apply, deploys), and production or pre-production AWS profiles (`prd`,
  `prod`, `ppe`), where reads are sometimes needed; the AWS write and destroy denies hold on every
  profile, and other writes there pass only on approval. An `ask` prompts even in auto mode.
- **`allow`** only for read-only commands and tools, to skip classifier latency. Never for anything
  that mutates (Jira and Confluence writes included), since an allow skips the classifier and its
  personal-information check.
- **CLAUDE.md `## Safety`** for principles no rule can express (synthetic data only, don't work
  around a denial, where instructions may come from).

## Threat model

Defends against mistakes and against prompt injection steering an action. Accepted residuals:

- Deny rules match Claude's file tools and command text, not what a program opens. A script that
  reads `~/.aws` or `.envrc`, or queries customer data, is judged only by the classifier. Mitigated
  by short-lived SSO credentials, agent-held SSH/GPG keys, no secrets in repos, and the
  `autoMode.environment` credential and personal-information lines.
- Exported secrets in the shell environment reach every command, and `env` or `printenv` would print
  them; keep tokens out of the environment Claude Code starts in.
- Bash argument patterns miss reordered flags, variables and wrappers. They're a backstop for the
  common spelling, not a boundary; don't chase every spelling.
- A Bash write to a gated config file (`sed -i CLAUDE.md`, a Python rewrite) goes to the classifier,
  not the ask. The `## Safety` line requiring the Edit and Write tools for config, and the PR diff,
  cover it.
- `.git/hooks` and `.git/config` are Claude Code built-in protected paths, so writes there go to the
  classifier rather than being auto-approved; there is no ask on them.

## Disposition table

| Risk                                                                    | Disposition | Leg                                       |
| ----------------------------------------------------------------------- | ----------- | ----------------------------------------- |
| Irreversible remote or local loss, credential or customer-data exposure | forbid      | `deny` (both scopes for the baseline set) |
| Changes future sessions' instructions or runs code unreviewed           | confirm     | `ask` on `Edit(...)` paths                |
| Ships or publishes                                                      | confirm     | `ask`                                     |
| Read-only, frequent                                                     | allow       | `allow` (user scope)                      |
| Everything else                                                         | classifier  | no rule                                   |

## Checks

1. **No sandbox or enforcement hooks.** No `sandbox` block in either scope (a project
   `sandbox.enabled` overrides the user value); hooks are conveniences only (`WorktreeCreate`).
2. **No mutating allow.** Every `allow` is read-only or a local, reversible verb (`git commit`,
   worktree cleanup).
3. **Baseline present.** Each project's `.claude/settings.json` contains every rule in
   `project-baseline.json`, and each user's settings every deny and ask in `user-baseline.json`.
4. **No user-only keys in project scope.** No `defaultMode`, `autoMode`, `sandbox` or `allow`.
5. **No shadowing.** An `ask` that a `deny` also matches never fires; flag it. Don't let an `allow`
   co-match an `ask` either: measured, `git merge --abort` ran unprompted with both present, though
   the docs say ask wins.
6. **Config gate covers the loaders.** User `ask` covers `~/**/CLAUDE.md`, `~/**/CLAUDE.local.md`,
   `~/**/.claude/{settings.json,settings.local.json,hooks,skills,agents,commands,rules,workflows,output-styles,docs}`,
   `~/**/.mcp.json`, `~/**/.pre-commit-config.yaml`, `~/**/.githooks/**` (`git commit` is allowed,
   so a hook edit there runs unjudged; other `core.hooksPath` names are not gated),
   `~/.dotfiles/claude/**`, the dotfiles' `justfile` and `scripts/**`, and `git config` setting
   `core.hooksPath` or `core.fsmonitor` (`*hooksPath *`: a value must follow, so a read-only `--get`
   doesn't prompt); not `~/**/.claude/**`, which would gate auto-memory. Project scope uses
   `/**/CLAUDE.md` so nested files are gated too, and names `.claude/` subdirectories one by one
   like user scope (not `/.claude/**`), so a Claude Code feature that writes there through the Edit
   tool doesn't prompt; a new config subdirectory needs its own rule.
7. **Pattern syntax.**
    - `Edit`/`Read` paths: `//abs`, `~/home`, `/project-relative` (in user settings `/` anchors at
      `~/.claude`), `**/name`. Measured: a user-scope `**/` rule matches only under the session's
      project, not in additional directories, so user-scope path rules use `~/**/`. `Write(...)` and
      `Glob(...)` rules never match.
    - A rule ending in `:*` is parsed as a legacy prefix rule, so after a mid-command `*`, or
      anywhere the prefix keeps a trailing space, it matches nothing (`Bash(git -C * clean:*)` and
      `Bash(git push :*)` never fire, read from the 2.1.316 matcher); use a glued tail
      (`Bash(git -C * clean*)`). A ` *` tail after a literal word is fine (`*hooksPath *` matches a
      set command).
    - A `*` straight after the command prefix doesn't match empty, so a rule whose match can come
      first needs a leading twin (`Bash(git push --forc*)` beside `Bash(git push * --forc*)`).
    - git accepts the shortest unique prefix of a long option, so spell the prefix (`--forc`,
      `--de`, `--pru`).
    - Measured: a leading `VAR=value` doesn't hide a command from a rule
      (`AWS_PROFILE=x aws s3 rm ...` hit `Bash(aws s3 rm:*)`), so rules need no env-prefix twins.
    - Claude Code splits compound commands and matches each subcommand (per the permissions docs),
      so a verb-led rule (`Bash(cat* .env*)`) doesn't fire on another subcommand that only mentions
      the path. Measured: a `$(cat <<'EOF' ...)` commit message mentioning `.env` passes.
8. **Over-matching.** Flag text denies that block ordinary work, such as a bare `* .env*` that also
   matches a commit message; prefer verb-led forms with a space before the path (`Bash(cat* .env*)`,
   which lets `os.environ` and `app.environment.ts` through) or path forms (`Bash(*/dumps/*)` with
   `Bash(* dumps/*)` and `Bash(* dumps)`). Path-form rules still match a commit message naming the
   path; write that message to a file and use `git commit -F`. Keep personal tools (`rg`, `bat`) out
   of `project-baseline.json`.
9. **Prose matches config.** `## Safety` and the repo CLAUDE.md name no layer that doesn't exist
   (sandbox, guard hooks).

## CLAUDE.md `## Permissions` stub for a project

```markdown
## Permissions

`.claude/settings.json` holds the team baseline (hard denies, asks on Claude config and publish
steps) plus this repo's rules. Auto mode and its `autoMode.environment` are user-scope settings, so
each contributor sets their own. Change Claude config (CLAUDE.md, `.claude/`, `.mcp.json`,
`.pre-commit-config.yaml`, `.githooks/`) only with the Edit and Write tools, never a script or shell
command: the `ask` rules match those tools, so a scripted edit skips the prompt. A commit message
that names a secret path (`.env`, `dumps/`) can trip a deny; write it to a file and use
`git commit -F`.
```

Add "Rationale in `.claude/docs/permissions.md`." when the repo has that file.

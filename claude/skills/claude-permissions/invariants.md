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
  credential export, force/delete pushes, `--no-verify`, recursive delete, remote-destroying CLI
  verbs, destructive MCP runners.
- **`ask`** for actions a human must see first: config that steers or runs code in future sessions
  (CLAUDE.md, `.claude/` settings, hooks, skills, agents, commands, rules, `.mcp.json`,
  `.pre-commit-config.yaml`, `~/.dotfiles/claude/`) and publish steps (PR creation where it's the
  review gate, terraform apply, deploys), and production or pre-production AWS profiles (`prd`,
  `prod`, `ppe`), where reads are sometimes needed but mutations stay denied. An `ask` prompts even
  in auto mode.
- **`allow`** only for read-only commands and tools, to skip classifier latency. Never for anything
  that mutates, since an allow skips the classifier.
- **CLAUDE.md `## Safety`** for principles no rule can express (synthetic data only, don't work
  around a denial, where instructions may come from).

## Threat model

Defends against mistakes and against prompt injection steering an action. Accepted residuals:

- Deny rules match Claude's file tools and command text, not what a program opens. A script that
  reads `~/.aws` or `.envrc`, or queries customer data, is judged only by the classifier. Mitigated
  by short-lived SSO credentials, agent-held SSH/GPG keys, no secrets in repos, and the
  `autoMode.environment` credential and personal-information lines.
- Bash argument patterns miss reordered flags, variables and wrappers. They're a backstop for the
  common spelling, not a boundary; don't chase every spelling.
- A Bash write to a gated config file (`sed -i CLAUDE.md`) goes to the classifier, not the ask.

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
   `project-baseline.json`.
4. **No project-only keys in project scope.** No `defaultMode`, `autoMode`, `sandbox` or `allow`.
5. **No shadowing.** An `ask` that a `deny` also matches never fires; flag it. An `ask` co-matched
   by an `allow` still asks; fine.
6. **Config gate covers the loaders.** User `ask` covers `**/CLAUDE.md`, `**/CLAUDE.local.md`,
   `**/.claude/{settings.json,settings.local.json,hooks,skills,agents,commands,rules}`,
   `**/.mcp.json`, `**/.pre-commit-config.yaml`, `~/.dotfiles/claude/**`; not `**/.claude/**`, which
   would gate auto-memory.
7. **Path syntax.** `Edit`/`Read` rules: `//abs`, `~/home`, `/project-relative` (in user settings
   `/` anchors at `~/.claude`), `**/anywhere`. `Write(...)` and `Glob(...)` rules never match.
8. **Over-matching.** Flag text denies that block ordinary work (`*.pem*`, `* dumps *`); prefer the
   path form (`*/dumps/*`).
9. **Prose matches config.** `## Safety` names no layer that doesn't exist (sandbox, guard hooks).

## CLAUDE.md `## Permissions` stub for a project

```markdown
## Permissions

`.claude/settings.json` holds the team baseline (hard denies, asks on Claude config and publish
steps) plus this repo's rules; rationale in `.claude/docs/permissions.md`. Auto mode and its
`autoMode.environment` are user-scope settings, so each contributor sets their own.
```

---
name: claude-permissions
description:
    Audit Claude Code permission config (user and project settings.json allow/ask/deny, autoMode,
    CLAUDE.md safety prose) against the auto-mode-plus-hard-denies model, add a rule at the right
    scope, or set up a repo's project settings or a teammate's user settings from the shared
    baselines. Use when reviewing or hardening Claude Code permissions, adding a command or path
    that must be blocked or confirmed, or setting up .claude/settings.json in a repo or
    ~/.claude/settings.json for a teammate.
argument-hint: "[setup | user | policy to add, e.g. 'confirm chmod'; omit to audit]"
allowed-tools: Read, Glob
---

# claude-permissions

Advisory: report and propose diffs; apply them through the normal plan-approve flow. The model and
the checks live in `invariants.md` beside this file; read it first in every mode.

## Locate the config

- **User scope**: `~/.dotfiles/claude/settings.json` and `claude/CLAUDE.md` `## Safety`.
  `~/.claude/*` are rcm symlinks into it; edit the repo, never the symlink.
- **Project scope**: `<repo>/.claude/settings.json` (committed, shared with teammates) and
  `.claude/settings.local.json` (gitignored, machine paths only).
- Managed scope: assume absent and say so.

## Mode A: audit (no argument)

Run every check in `invariants.md` against both scopes. Report one row per gap (rule, scope, missing
or contradicting piece), contradictions first, then dead or shadowed rules, then over-matching
rules. Propose diffs; edit nothing.

## Mode B: setup (argument `setup`)

Set up or realign a repo's `.claude/settings.json`:

1. Start from `project-baseline.json` beside this file. Keep it verbatim so repos stay consistent;
   diff an existing file against it and list what's missing, extra, or contradicting.
2. Add only repo-specific rules on top, each tied to something in the repo: a cloud CLI it calls
   (mutation verb denies, data-store read asks), a publish step that needs a human gate (release,
   deploy), a code-running config file beyond `.pre-commit-config.yaml`.
3. Never add to project scope: `sandbox`, `defaultMode`, `autoMode` (ignored there), hooks that
   assume one person's machine, `allow` rules (they apply only after folder trust and pre-approve
   for every teammate).
4. Add the CLAUDE.md `## Permissions` stub from `invariants.md` if the repo has none.
5. Tell teammates the user-scope half lives in their own settings: point them at
   `user-baseline.json` beside this file (auto mode, `autoMode.environment`, read-only allows, the
   deny list and config asks) to merge into `~/.claude/settings.json`, keeping what fits their
   tools.

## Mode C: user setup (argument `user`)

Diff `~/.claude/settings.json` against `user-baseline.json` and propose a merge: keep the person's
own allows, plugins and hooks; add missing denies, asks and `autoMode` entries; flag allows for
tools they don't have (another MCP connector's names, a CLI they don't use). Allows differ per
person, which is why they live here and not in project scope: tool names depend on each person's
connectors and CLIs, and a project allow can't be routed back to the classifier by a teammate (their
only overrides are `ask` or `deny`).

## Mode D: add a policy (any argument other than `setup` or `user`)

Classify it with the disposition table in `invariants.md` (deny / ask / classifier), pick the scope
(user if it protects me everywhere, baseline if every repo needs it, project if only this repo), and
propose the rule plus a `## Safety` line only if it is a principle the rule can't express.

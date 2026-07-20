---
name: claude-permissions
description: Audit the belt-and-suspenders permission config (settings.json allow/ask/deny, the guard hooks, and CLAUDE.md safety prose) for cross-layer gaps and drift, or guide adding a new permission policy across all applicable layers. Use when hardening or reviewing Claude Code permissions, checking that a rule is enforced redundantly, or adding a command or path that must be blocked or confirmed.
argument-hint: "[policy to add, e.g. 'confirm chmod'; omit to audit]"
allowed-tools: Read, Grep, Glob, Bash(rg:*), Bash(fd:*), Bash(cat:*), Bash(ls:*), Bash(readlink:*), Bash(realpath:*), Bash(just test-claude-hooks:*)
---

# claude-permissions

Maintain the "belt-and-suspenders" permission config: keep each policy consistently enforced
across the layers, and add new policies without hand-wiring each one. Advisory only - this skill
reports and proposes diffs; you apply them through the normal plan-approve flow. It never edits or
commits (its `allowed-tools` omit Edit/Write, but that is tool-scoping plus compliance, not a hard
block).

Run `/claude-permissions` with no argument to **audit**. Pass a policy (e.g.
`/claude-permissions confirm chmod`) to get a **guided add**. The check catalog and the
disposition table live in `invariants.md` beside this file - read it before either mode.

## The enforcement model

The layers, softest to hardest (background rationale: `DESIGN.md`, the sandbox-first /
minimal-hook decision):

- **CLAUDE.md** (`## Safety`) - soft intent. Shapes model behavior; no hard stop. Kept minimal
  (adherence decays past ~150-200 instructions), so it holds principles, not every rule.
- **settings.json** `allow`/`ask`/`deny` - the permission gate. `deny` blocks, `ask` prompts,
  evaluated deny-then-ask-then-allow, first match wins. Weaknesses: bypassed under
  `--dangerously-skip-permissions`; Bash-argument patterns are brittle (reordered flags,
  redirects, variable expansion); without a sandbox a `deny` binds only Claude's built-in tools,
  not `cat .env` run via Bash.
- **sandbox** (`sandbox` block, hard floor) - the OS-level primary containment boundary. It bounds
  what a Bash command can touch, so destructive verbs are blocked by `deny` rules before they run
  and contained by the sandbox if they do. This is why destructive must-nevers live in `deny`
  rules, not a hook.
- **hooks** (`claude/hooks/guard.sh`) - one narrow deterministic leg that matches a tool's
  structured PATH input and must NOT parse Bash command strings (fragile on quoting/operators). Its
  only job is blocking secret-path reads via the built-in tools (Read/Write/Edit/Grep/Glob), which
  the sandbox doesn't wrap and `Read(**/…)` denies cover only best-effort. It does NOT bind `mcp__*`
  tools - for MCP, `deny` is the only binding leg.

Belt-and-suspenders means the RIGHT leg for the risk. A destructive must-never belongs in a `deny`
rule plus the sandbox, NOT a hook that parses Bash. A secret read via a built-in tool is the one
case that needs the hook.

Raw `git push` stays denied; unattended push goes through the `just push` narrow wrapper - an
allowed command whose recipe runs a fixed, origin-only, non-force `git push`. So the
destructive-push must-never needs no hook and no un-deny: the wrapper is the sanctioned path.

## Locate the config (two scopes)

Claude Code merges **user** and **project** scope (managed > local > project > user; deny-first).
Audit both; attribute every finding and edit to a scope.

- **User scope** (global, every project). Source of truth is the dotfiles repo's `claude/*`, NOT
  `~/.claude/*` (those are rcm symlinks into the repo). Find the repo with
  `readlink -f ~/.claude/settings.json`, then read/edit there:
    - `claude/settings.json` (allow/ask/deny, defaultMode, any `sandbox` key)
    - `claude/hooks/guard.sh` (path-matching secret-path block only; block-only, no Bash branch)
    - `claude/hooks/gh-api-readonly.sh` (gh api read-only)
    - `claude/CLAUDE.md` `## Safety`
    - `rcignore/test_guard.sh` (the guard hook's test), run via `just test-claude-hooks`
- **Project scope** (current repo only): `<cwd>/.claude/settings.json`,
  `.claude/settings.local.json`, `.claude/rules/`, `.claude/hooks/`. Usually additive allows.
- **Managed scope** (enterprise MDM) is out of read scope; assume absent (solo setup) and say so
  in the report.
- Never edit through the `~/.claude` symlinks - Edit/Write refuse it and the repo is the source
  (`.claude/rules/settings-editing.md`).

## Mode A: audit (no argument)

1. Resolve both scopes' files (above).
2. Run every check in `invariants.md` against the merged config.
3. Emit a report:
    - A **coverage matrix**: rows = policies found, columns = CLAUDE.md / settings / hook / scope.
    - **Violations**, ordered contradiction > missing-hook-backstop > missing-visibility >
      prose-only. **Deduplicate by (policy, missing-layer)**: one row per gap, listing every
      invariant ID that cites it, so `--no-verify` shows once, not once per invariant.
    - The **sandbox posture** note (invariant 7) and the managed-scope assumption.
4. Group the first-run security-belt batch **by the CLAUDE.md dimension only**: existing
   guardrails (sudo, git push, rm -rf, destructive git, rm/dd/rsync, direnv, WebFetch/WebSearch)
   each have a settings.json rule but no CLAUDE.md covering line - report the missing lines as ONE
   grouped recommendation (a few family lines clear them), not N separate flags. This is
   orthogonal to enforcement-leg gaps: do NOT describe the batch as fully enforced. Some members
   carry separate findings reported via their own invariants - direnv's command denies lack a hook
   backstop (inv 1), WebFetch/WebSearch are settings-only by design (inv 9, no hook) - do not fold
   those into or mask them behind the CLAUDE.md batch.

Do not edit anything. Hand the report back for the user to act on.

## Mode B: guided add (argument = the policy)

1. **Classify** the policy: disposition (forbid / confirm / allow), whether it is
   **security-related** (definition in `invariants.md`), and **target scope** (security guardrails
   default to user scope so they apply everywhere; project-specific allows go to the project's
   `.claude/` - never put a security belt in one project's `.claude/` only).
2. **Map to legs** via the disposition table in `invariants.md`, honoring the invariant-9
   precedence (no hook for ask-by-design network tools or MCP).
3. **Propose** coordinated edits as diffs; do not apply:
    - `settings.json`: the allow/ask/deny rule, in the right scope. A destructive forbid is a
      `deny` rule (colon `:*` form) and gets NO guard branch - the guard doesn't parse Bash.
    - `guard.sh`: a branch ONLY for a secret-path read via built-in tools (add the path to its
      canonical secret set). No Bash-command branch exists or should be added. Confirm policies get
      no hook: put the `ask` in settings.json and let the sandbox/classifier backstop.
    - `claude/CLAUDE.md` `## Safety`: a one-line intent entry - required if security-related, else
      only if a genuine principle. A covering family line is fine.
    - `rcignore/test_guard.sh`: a matching block/allow case ONLY for a secret-path rule (the
      harness feeds Read/Grep/Glob payloads to the guard). Destructive `deny` rules and MCP rules
      get no harness test - say so, do not promise one.
4. Tell the user to review, apply via plan-approve, and run `just test-claude-hooks`.

## Scope

This is the permission-surface deep check: it audits and proposes diffs across settings.json, the
guard hook, and CLAUDE.md `## Safety`, but never applies them (apply via the normal plan-approve
flow). Background rationale for the sandbox-first, minimal-hook posture is in `DESIGN.md`.

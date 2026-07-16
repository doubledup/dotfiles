---
name: claude-permissions
description: Audit the belt-and-suspenders permission config (settings.json allow/ask/deny, the guard hooks, and CLAUDE.md safety prose) for cross-layer gaps and drift, or guide adding a new permission policy across all applicable layers. Use when hardening or reviewing Claude Code permissions, checking that a rule is enforced redundantly, or adding a command or path that must be blocked or confirmed.
argument-hint: "[policy to add, e.g. 'confirm chmod'; omit to audit]"
allowed-tools: Read, Grep, Glob, Bash(rg:*), Bash(fd:*), Bash(cat:*), Bash(ls:*), Bash(readlink:*), Bash(realpath:*), Bash(just test-guard:*)
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

Three layers, softest to hardest (background: the config research doc under
`claude/docs/improvement/` (config-research-v\*.md), Enforcement section - versioned and
regenerated, so cited by section, not line):

- **CLAUDE.md** (`## Safety`) - soft intent. Shapes model behavior; no hard stop. Kept minimal
  (adherence decays past ~150-200 instructions), so it holds principles, not every rule.
- **settings.json** `allow`/`ask`/`deny` - the permission gate. `deny` blocks, `ask` prompts,
  evaluated deny-then-ask-then-allow, first match wins. Weaknesses: bypassed under
  `--dangerously-skip-permissions`; Bash-argument patterns are brittle (reordered flags,
  redirects, variable expansion); without a sandbox a `deny` binds only Claude's built-in tools,
  not `cat .env` run via Bash.
- **hooks** (`claude/hooks/guard.sh`) - deterministic enforcement. A PreToolUse `block()` (exit 2)
  holds even under `--dangerously-skip-permissions`, for built-in tools (Bash/Read/Write/Edit). It
  does NOT bind `mcp__*` tools (the hook fires, returns deny, the tool proceeds anyway) and the
  sandbox does not cover them - for MCP, `deny` is the only binding leg.

Belt-and-suspenders means the RIGHT redundant legs for the risk, not all three for everything.
Anything that MUST NOT happen belongs in a hook, not prose.

## Locate the config (two scopes)

Claude Code merges **user** and **project** scope (managed > local > project > user; deny-first).
Audit both; attribute every finding and edit to a scope.

- **User scope** (global, every project). Source of truth is the dotfiles repo's `claude/*`, NOT
  `~/.claude/*` (those are rcm symlinks into the repo). Find the repo with
  `readlink -f ~/.claude/settings.json`, then read/edit there:
    - `claude/settings.json` (allow/ask/deny, defaultMode, any `sandbox` key)
    - `claude/hooks/guard.sh` (destructive-cmd + secret-path blocks; block-only, the `block()` helper)
    - `claude/hooks/gh-api-readonly.sh` (gh api read-only)
    - `claude/CLAUDE.md` `## Safety`
    - `rcignore/test_guard.sh` (the guard hook's test), run via `just test-guard`
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
    - `settings.json`: the allow/ask/deny rule, in the right scope.
    - `guard.sh`: a `block()` (forbid) branch placed after the existing hard blocks, reusing the
      helper and the clause-boundary regex style already there. Built-in-tool policies only (a hook
      does nothing for MCP). Confirm policies get NO hook branch: the guard is block-only, so put
      the `ask` in settings.json and let the classifier backstop.
    - `claude/CLAUDE.md` `## Safety`: a one-line intent entry - required if security-related, else
      only if a genuine principle. A covering family line is fine.
    - `rcignore/test_guard.sh`: a matching case (ask/block/allow), but ONLY for Bash-path rules;
      the harness feeds only `tool_name:"Bash"`, so Read/Write/Edit or MCP rules get no test - say
      so, do not promise one.
4. Tell the user to review, apply via plan-approve, and run `just test-guard`.

## Relationship to the config runbook

This is the permission-surface deep check. It complements
`claude/docs/improvement/config-improvement-runbook.md` (the friction-driven weekly loop) rather
than replacing it; the weekly loop can call this skill when permissions are the surface in play.

# Permission invariants

The checks `/claude-permissions` runs. Each states the rule, why it holds, how to check it, and an
example violation. Background rationale (the sandbox-first, minimal-hook decision) lives in
`DESIGN.md`; for Claude Code evaluation mechanics see the official docs at code.claude.com.

## Layer-location map

| Layer       | User scope (global)                                 | Project scope (this repo)         |
| ----------- | --------------------------------------------------- | --------------------------------- |
| intent      | `claude/CLAUDE.md` `## Safety`                      | `.claude/rules/*.md`              |
| permissions | `claude/settings.json` allow/ask/deny               | `.claude/settings.json`, `.local` |
| hooks       | `claude/hooks/guard.sh`, `gh-api-readonly.sh`       | `.claude/hooks/*`                 |
| test        | `rcignore/test_guard.sh` (`just test-claude-hooks`) | -                                 |

`~/.claude/*` are rcm symlinks into `claude/*`; operate on the repo, never the symlink.

## Disposition -> layers (the guided-add contract)

CLAUDE.md participation is **principles-only by default, with a security override**: a
**security-related** policy gets a CLAUDE.md line even if mechanical (security trumps minimalism);
a non-security policy gets one only if it is a genuine principle. A single covering family line
can serve a group of related rules.

**Security-related** = touches secrets/credentials; irreversible data loss (destructive commands);
privilege escalation (sudo); outbound exfiltration (network, git push); or defeats a safety
control (direnv trust, `--no-verify`, `--dangerously-skip-permissions` bypass).

| Disposition         | CLAUDE.md                | settings.json | guard.sh | test     |
| ------------------- | ------------------------ | ------------- | -------- | -------- |
| forbid (must never) | line if security-related | deny          | -        | -        |
| confirm (ask first) | line if security-related | ask           | -        | -        |
| allow (read-only)   | usually none             | allow         | none     | optional |

`guard.sh` has NO Bash branch: it never enforces a forbid command (that is the
`deny` rule's job) and never emits an ask. Its only leg is path-matching secret
reads via the built-in tools (Read/Write/Edit/Grep/Glob), which the sandbox and
`deny` rules can't cover. So a forbid disposition gets a `deny` rule and, only
for a secret-path read, a guard case; a destructive command gets a `deny` rule
and no hook.

Confirm has no guard.sh leg: the hook is **block-only** by design (it never emits `ask`). Confirms
live in settings.json `ask` plus the permission classifier, which backstops the forms a glob can't
match. So a confirm rule gets no hook branch and no `test_guard.sh` case.

Test column: `rcignore/test_guard.sh` feeds Read/Grep/Glob tool payloads to guard.sh; since the
guard is path-matching only, the tests exercise its secret-path block. Destructive `deny` rules
and MCP dispositions get no harness test (the guard has no Bash branch to exercise); say so, do
not promise one.

## Invariants

**1. Destructive must-never => `deny` rule, no hook.** A must-never destructive command (sudo,
`rm -rf`, `git push`, tree-discard, `find` side-effecting primaries) is enforced by a settings.json
`deny` rule, NOT a guard hook. Why: `deny` rules bind in every mode, are respected under sandbox
auto-allow, and descend into `$(...)`; the OS sandbox (hard floor, invariant 7) contains what runs;
and hooks must not parse Bash command strings, which is fragile on quoting/operators/`$()`. Use the
colon `:*` form so the no-arg case is caught (`Bash(git reset --hard:*)`, never `... *`). Ask-by-
design rules (`git commit`, `gh pr create`, `WebFetch`, `WebSearch`) are NOT gaps. Check: for each
destructive must-never, confirm a `deny` rule in the correct form. Example: all direnv subcommands
are denied by a single `Bash(direnv:*)`; the trust-store WRITE is covered by the
`Edit(**/.local/share/direnv/allow/**)` deny plus the sandbox (the store is out-of-tree), not a hook.
Note on `git push`: it stays a must-never `deny`, but unattended push is available through the
`just push` narrow wrapper (an allowed command whose recipe runs a fixed origin-only, non-force
`git push`), so the deny costs no workflow and still needs no hook.

**2. Secret-path read => `Bash(*.env*)` deny + path-matching guard.** A secret path needs BOTH a
`Bash(*.env*)`-family `deny` rule (blocks `cat .env`, which `Read(...)` denies don't cover) AND
`guard.sh`'s path case for the built-in tools (Read/Write/Edit/Grep/Glob), because the sandbox does
not wrap those tools and `Read(**/…)` denies apply only best-effort to Grep/Glob. Scope: `.git` is
guard + `Read(**/.git/**)` only, with NO `Bash(*/.git/*)` deny (it would collide with `cat
.git/HEAD`); likewise the `*.pem`/`*.key`/`*id_rsa*`/`.netrc`/`.npmrc` family is left out at user
scope (collision-prone). Check: each secret path (except `.git` and that family) has a `Bash(*…*)`
deny and a guard.sh path case. Example: `.env` = `Bash(*.env*)` + the guard's `*/.env` case.

**3. Guard block => settings visibility mirror.** Any secret path `guard.sh` blocks should also
appear in `settings.json` `deny` (`Read(**/…)` + `Bash(*…*)`) so intent stays declaratively
greppable. Visibility, weaker than 1-2. Check: each guard secret-path case (exit 2) has a matching
`deny` entry. Example: a secret path blocked in the guard with no `deny` entry naming it.

**4. CLAUDE.md safety claim => real enforcement (enforceable claims only).** Classify each
`## Safety` line as mechanically enforceable (names a specific command/path/action) or
behavioral/judgment. Flag only enforceable claims lacking a deny/ask/hook. Behavioral claims are
correctly prose-only and are NOT gaps. Check: for each enforceable line, find the deny/ask/hook.
Example: "Never use --no-verify" (enforceable, no teeth today) is a gap; "verify no secrets in
diffs" (behavioral) is not.

**5. No cross-layer contradiction.** No `allow` for something a hook blocks or CLAUDE.md forbids;
no `ask`/`allow` where the intent is must-never. Check: cross-reference the allow list against
hook blocks and `## Safety`. Example: an `allow` rule for a command the guard hook exits 2 on.

**6. Disposition coherence.** forbid => `deny` rule (the guard has no Bash branch, so no
`block()`); confirm => `ask` in settings.json (the guard never asks; the sandbox/classifier
backstop). A must-never that is only `ask`, a confirm that is hard-denied, or any guard Bash-command
block (which no longer exists) is a mismatch. Check: for each denied/guarded command, compare its
settings disposition to the enforcement. Example: `rm`/`dd`/`rsync` = `ask` (coherent);
sudo/`rm -rf`/destructive git/`find` primaries = `deny` (coherent); the guard's only leg is the
Read/Grep/Glob secret-path block.

**7. Sandbox posture.** The `sandbox` block IS configured with the hard floor
(`allowUnsandboxedCommands: false` + `failIfUnavailable: true`), so it is the primary containment
boundary. This is what lets invariant 1 keep destructive enforcement in `deny` rules rather than a
hook backstop, and what covers the direnv trust store (out-of-tree writes). Check: the `sandbox`
key in settings.json; a regression to sandbox-off would weaken the deny-only destructive posture
(no hook leg) - flag it if it changes.

**8. MCP tools: `deny` is the only binding leg.** For `mcp__*` tools a PreToolUse hook does NOT
bind - it fires, returns deny, and the tool proceeds anyway - and the sandbox does not cover them. Never advise a hook as sufficient for an MCP action, and never score a present
hook as "enforced" for one; `deny` binds. Check: any policy whose tool is `mcp__*` must rely on a
`deny` rule, not a hook. Latent today (no active mcpServers) but load-bearing when hardening a new
MCP surface.

**9. Security policy => CLAUDE.md intent line + the enforcement legs its disposition allows.** A
security-related policy must carry a CLAUDE.md `## Safety` intent line AND its enforcement legs.
Precedence: invariants 1, 6, and 8 decide WHICH legs apply; invariant 9 never demands a hook where
they say none does. So an ask-by-design network tool (WebFetch/WebSearch) needs the ask rule + a
CLAUDE.md line, NOT a hook; a security-related MCP policy needs `deny` + a CLAUDE.md line, NOT a
hook. A single covering family line may satisfy the CLAUDE.md requirement for a group. Check: for
each security-related policy, confirm a covering CLAUDE.md line plus the legs 1/6/8 prescribe.
Example: WebFetch is security-related (network) and lacks a CLAUDE.md line - flag the line, never a
hook.

**10. Security enforcement lives at user (or managed) scope, not project-local.** A security
guardrail must sit in user scope (`claude/*` -> `~/.claude/`) or managed settings so it applies in
every project; the same guardrail present only in one project's `.claude/` is a gap - it silently
does not protect other projects. Project scope is for additive allows. Check: report each rule's
and hook's scope; flag a security policy found only at project scope. (Managed scope is out of read
scope; assume absent and say so.)

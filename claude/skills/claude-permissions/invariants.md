# Permission invariants

The checks `/claude-permissions` runs. Each states the rule, why it holds (cited to the research
doc = the config research doc under `claude/docs/improvement/` (config-research-v\*.md); it is
versioned and regenerated, so citations are by section, not line), how to check it, and an example
violation.

## Layer-location map

| Layer       | User scope (global)                           | Project scope (this repo)         |
| ----------- | --------------------------------------------- | --------------------------------- |
| intent      | `claude/CLAUDE.md` `## Safety`                | `.claude/rules/*.md`              |
| permissions | `claude/settings.json` allow/ask/deny         | `.claude/settings.json`, `.local` |
| hooks       | `claude/hooks/guard.sh`, `gh-api-readonly.sh` | `.claude/hooks/*`                 |
| test        | `rcignore/test_guard.sh` (`just test-guard`)  | -                                 |

`~/.claude/*` are rcm symlinks into `claude/*`; operate on the repo, never the symlink.

## Disposition -> layers (the guided-add contract)

CLAUDE.md participation is **principles-only by default, with a security override**: a
**security-related** policy gets a CLAUDE.md line even if mechanical (security trumps minimalism);
a non-security policy gets one only if it is a genuine principle. A single covering family line
can serve a group of related rules.

**Security-related** = touches secrets/credentials; irreversible data loss (destructive commands);
privilege escalation (sudo); outbound exfiltration (network, git push); or defeats a safety
control (direnv trust, `--no-verify`, `--dangerously-skip-permissions` bypass).

| Disposition         | CLAUDE.md                | settings.json | guard.sh       | test       |
| ------------------- | ------------------------ | ------------- | -------------- | ---------- |
| forbid (must never) | line if security-related | deny          | block() exit 2 | block case |
| confirm (ask first) | line if security-related | ask           | -              | -          |
| allow (read-only)   | usually none             | allow         | none           | optional   |

Confirm has no guard.sh leg: the hook is **block-only** by design (it never emits `ask`). Confirms
live in settings.json `ask` plus the permission classifier, which backstops the forms a glob can't
match. So a confirm rule gets no hook branch and no `test_guard.sh` case.

Test column: `rcignore/test_guard.sh` feeds only `tool_name:"Bash"`, so a test case exists only
for Bash-path rules (including guard.sh's Bash-branch secret-read block). Read/Write/Edit-path and
MCP dispositions get no harness test; say so, do not promise one.

## Invariants

**1. Must-never Bash `deny` => hook backstop.** Every `deny` that encodes a must-never
(destructive command) must also be hard-blocked in `guard.sh`. Why: a `deny` is bypassed under
`--dangerously-skip-permissions` while a PreToolUse hook holds for built-in tools, and Bash-arg
deny patterns are brittle; with no sandbox configured here the hook is the only leg that binds Bash
(research doc, Enforcement section). Scope: built-in tools only. Ask-by-design rules (`git commit`,
`gh pr create`, `WebFetch`, `WebSearch`) are NOT gaps - they intend a prompt, not a block; flagging
them trains the user to ignore the linter. Check: for each safety `deny` in settings, grep
`guard.sh` for a matching `block()`. Example: the `direnv allow/permit/grant/edit/exec` denies
(settings.json) whose only hook guards the trust-store write, not the commands.

**2. Secret-path Read/Write deny => Bash-read hook backstop.** Every `Read(**/.env)`-style deny
needs `guard.sh` to block both the Read|Write|Edit path (present today) AND the equivalent Bash
read (`cat`/`less`/`cp` of the secret). Why: `cat .env` via Bash bypasses the Read deny entirely
(research doc, Enforcement section). Check: confirm the secret paths in the guard's `Read|Write|Edit` branch are
also matched in its `Bash)` branch. Example: guard.sh blocks the Read tool on `.env` but
`cat ~/.env` runs.

**3. Hook block => settings visibility mirror.** Anything `guard.sh` hard-blocks should also appear
in `settings.json` `deny` so intent stays declaratively greppable. Visibility, weaker than 1-2.
Check: each `block()` reason vs the `deny` array. Example: a command blocked in the hook with no
`deny` entry naming it.

**4. CLAUDE.md safety claim => real enforcement (enforceable claims only).** Classify each
`## Safety` line as mechanically enforceable (names a specific command/path/action) or
behavioral/judgment. Flag only enforceable claims lacking a deny/ask/hook. Behavioral claims are
correctly prose-only and are NOT gaps. Check: for each enforceable line, find the deny/ask/hook.
Example: "Never use --no-verify" (enforceable, no teeth today) is a gap; "verify no secrets in
diffs" (behavioral) is not.

**5. No cross-layer contradiction.** No `allow` for something a hook blocks or CLAUDE.md forbids;
no `ask`/`allow` where the intent is must-never. Check: cross-reference the allow list against
hook blocks and `## Safety`. Example: an `allow` rule for a command the guard hook exits 2 on.

**6. Disposition coherence.** forbid => deny + hook `block()`; confirm => `ask` in settings.json
only (the guard hook is block-only and never asks; the classifier backstops the forms a glob
misses). A must-never that is only `ask`, a confirm that is hard-denied, or any hook `ask()` (which
no longer exists) is a mismatch. Check: for each guarded command, compare the settings disposition
to the hook's action. Example: `rm`/`dd`/`rsync` = `ask` in settings.json with no hook leg
(coherent); sudo/`rm -rf`/destructive git = `deny` + `block()` (coherent).

**7. Sandbox posture.** Report whether `sandbox` is configured with `allowUnsandboxedCommands:
false` + `failIfUnavailable: true`. If not (current state), invariants 1-2 are load-bearing - the
hook is the only thing binding Bash. Check: the `sandbox` key in settings.json. Not a violation by
itself; context that raises the weight of 1-2.

**8. MCP tools: `deny` is the only binding leg.** For `mcp__*` tools a PreToolUse hook does NOT
bind - it fires, returns deny, and the tool proceeds anyway (research doc, Enforcement section) -
and the sandbox does not cover them. Never advise a hook as sufficient for an MCP action, and never score a present
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

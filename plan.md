# Claude Code Configuration Improvement Plan

Supersedes `improvement-plan-old.md` (delete after this plan is reviewed and accepted). Read-only audit only — no changes have been made. Claude Code version: **2.1.197**.

## Opening summary

The setup is more mature than the source documents assume: three of the old plan's five changes are already implemented (destructive-git deny rules, session-discipline/context-management guidance, path-scoped neovim/fish rules), the output style has already been switched from a nonexistent `"concise"` built-in to the custom `engineers-answer` style, and every deny rule except one (`Read(**/.git/**)`) already has a matching PreToolUse hook check in `guard.sh`. The highest-impact remaining gaps: `claude/commands/jira-comment.md` has no frontmatter at all (no `description`, no `allowed-tools` — full, unrestricted tool access), `.claude/rules/toolchain.md` duplicates content already in the project-root `CLAUDE.md`'s rcm section, `defaultMode` is unset anywhere despite insights data showing plan/implement splits correlate with the only two fully-achieved sessions, and permission-array merge behavior across `claude/settings.json` and `.claude/settings.json` is unverified — if arrays replace rather than concatenate, this repo may be silently losing the 28-entry global allowlist.

**Instruction density** (global scope, `claude/`):

- `claude/CLAUDE.md`: ~36 instructions, no `@import` used (contrary to research doc's assumption — `git.md` is already a rules file, not an import)
- `claude/rules/*.md` unconditional (no `paths:` frontmatter — all 4 files qualify): ~48 instructions (`execution.md` ~10, `git.md` ~16, `planning.md` ~10, `review-protocol.md` ~12)
- **Always-loaded global total: ~84 instructions** (well under the ~100–150 budget per research doc section 2)
- `claude/rules/*.md` glob-scoped: none exist at global scope. Project-level (`.claude/rules/`) has `fish.md` (~3, `paths: config/fish/**`) and `neovim.md` (~6, `paths: config/nvim/**`) — these only load for matching files
- Command + agent `description` frontmatter: **565 characters** total across 10 files (5 commands, 5 agents) — 3.5% of the 16,000-char skill-budget fallback, nowhere near the limit. No `SLASH_COMMAND_TOOL_CHAR_BUDGET` tuning needed.

**Command/agent audit highlights**: `jira-comment.md` has zero frontmatter (biggest single gap). No `context: fork` usage anywhere (confirmed safe). All review agents correctly use read-only tool restrictions instead of relying on deny rules. `peer-review.md` bounds parallel Task dispatch to exactly 4 named agents — no unbounded fan-out risk despite no `maxParallelAgents` control existing (research section 6).

**Hook audit note (correction from review)**: a third registered hook, `claude/hooks/gh-api-readonly.sh` (115 lines, global, PreToolUse matcher `Bash`), was omitted from the original pass. It auto-approves read-only `gh api` calls, falls through to `exit 0` with an explicit `{"permissionDecision":"allow"}` for matches and is otherwise non-blocking — no error-swallowing or exit-code concerns found. No fix needed; flagged here so the hook inventory in this plan is complete (three hooks total: `guard.sh`, `format.sh`, `gh-api-readonly.sh`).

## Corrections to the research doc, confirmed against official docs during this audit

Fetched `code.claude.com/docs/en/memory` and `/docs/en/output-styles` directly; both correct or refine claims in `claude-code-config-research-v3.md`:

- **`@import` max depth is 4 hops, not 5.** Docs: "maximum depth of four hops." Research doc section 2 and its Recommended Reading both say 5. Not consequential here since no imports are used, but don't cite the 5-hop figure elsewhere.
- **Official CLAUDE.md size target is under 200 lines, not ~500.** Docs: "target under 200 lines per CLAUDE.md file." Research doc section 2 cites "~500 lines" from `costs`/`features-overview` pages — likely a different/older doc page. Current `claude/CLAUDE.md` (61 lines) is well within either bound.
- **Project-root CLAUDE.md is actively re-read from disk and re-injected after `/compact`.** Docs: "Project-root CLAUDE.md survives compaction: after `/compact`, Claude re-reads it from disk and re-injects it into the session. Nested CLAUDE.md files in subdirectories are not re-injected automatically." This refines rather than contradicts research doc section 2 — structural presence is confirmed, so the compaction failure mode is specifically about the model's practical attention/adherence within the summarized history, not content loss. This supports the research doc's own conclusion that behavioral/structural mitigations (not a PreCompact hook) are the right fix — see Tier 1 below.
- **Built-in output styles are Default, Proactive, Explanatory, Learning — there is no built-in `"concise"` style.** Docs enumerate exactly these four. Whatever `"concise"` referred to previously was either a typo or a since-removed style; it's moot now since `claude/settings.json` already sets `"outputStyle": "engineers-answer"`.
- **Rules frontmatter field is `paths`, not `globs`.** Docs: "Rules can be scoped to specific files using YAML frontmatter with the `paths` field... Rules without a `paths` field are loaded unconditionally." `.claude/rules/toolchain.md` uses `description:` and `globs: "*"` — neither is a recognized rules-file key. Functionally harmless (no `paths:` means it was already unconditional), but the frontmatter is dead metadata that could mislead a future editor into thinking it's scoped. See Tier 1.

## Tier 1 — High impact, high confidence

### 1. Add frontmatter to `claude/commands/jira-comment.md`

**File**: `claude/commands/jira-comment.md` (global)

Add a frontmatter block with `description` (required for auto-invocation per research doc section 5). Currently the file has no frontmatter block at all — it starts directly with `# Jira Comment` — so it can't be auto-invoked by description matching.

**Correction from review**: the command body says "Fetch the ticket using cloud ID `sft.atlassian.net`" — "cloud ID" is Atlassian MCP/connector terminology, not an `acli` CLI invocation. There's no mention of `acli` or Bash anywhere in the file. Do not add `allowed-tools: [Bash, Read]` as originally proposed — restricting to Bash would likely disable the command if it actually posts via an Atlassian MCP/connector tool. Confirm which tool the command actually uses (check for a configured Atlassian MCP server, or test the command and observe which tool it invokes) before adding any `allowed-tools` restriction. Until confirmed, ship with `description` only and leave tool access unrestricted:

```
---
description: Post a comment to a Jira ticket
---
```

**Verify**: `/context` shows the command's description loaded; re-run the command and confirm it still posts correctly. If tightening `allowed-tools` later, confirm the actual invoked tool first (e.g. via transcript inspection during a real run) rather than assuming Bash.

### 2. Add `.git/` path check to `claude/hooks/guard.sh`

**File**: `claude/hooks/guard.sh` (global)

`claude/settings.json` denies `Read(**/.git/**)`, but `guard.sh`'s `Read | Write | Edit` case only blocks `.env`/`.envrc`/`secrets/`/`.ssh/`/`.aws/` paths — it has no `.git/` check. Every other deny rule in the list has a matching hook-level check (confirmed by direct comparison); this is the one gap. Given research doc section 3's finding that deny rules have been intermittently broken through Feb 2026, this deny rule currently has no parallel enforcement.

Add a case arm alongside the existing secrets-path check:

```bash
*/.git/*)
    block "Blocked: access to '$FILE_PATH' inside .git."
    ;;
```

**Verify**: attempt to Read a file under `.git/` in a new session; confirm the hook blocks it even if the deny rule were to silently fail. Note: hook config changes don't take effect until the next session (research doc section 4).

### 3. Fix silent error swallowing in `.claude/hooks/format.sh`

**File**: `.claude/hooks/format.sh` (project)

`just fmt || true` swallows all errors unconditionally. If a formatter crashes (missing binary, syntax error `stylua`/`shfmt` can't parse), the hook exits 0 with no signal to the user — formatting silently fails and drifts from what `just check` expects in CI. This is the "hooks that swallow errors may silently defeat their own purpose" pattern flagged in research doc section 4.

Since this is PostToolUse and a formatter shouldn't retroactively block the edit that already happened, don't switch to `exit 2` (that would block on every transient formatter hiccup). Instead, surface failures without blocking:

```bash
if ! OUTPUT=$(just fmt 2>&1); then
    echo "$OUTPUT" >&2
    exit 1
fi
```

**Correction from review**: the `exit 1` is required, not optional — without it the script falls through to implicit exit 0 in every case, which contradicts the stated rationale. Per research doc section 4, an exit-0 PostToolUse hook's stderr is only visible in transcript/verbose mode, not reliably surfaced to the user; only a non-zero, non-2 exit ("other non-zero = non-blocking error, logged, shown to user") achieves that. `exit 1` keeps this non-blocking (only `exit 2` blocks) while actually surfacing the failure. Remove the blanket `|| true`.

**Verify**: temporarily break a `.lua` file's syntax, edit it, confirm the formatter failure is visible in the transcript instead of silently disappearing.

### 4. Add a no-hallucination guardrail to `claude/CLAUDE.md`

**File**: `claude/CLAUDE.md` (global)

Insights data item 5 ("no-hallucination rule") is the one old-plan insight addition that is genuinely not yet covered anywhere in current config (the other four — rcm context, justfile convention, implement-immediately, conservative changes — are already present; see "Already implemented" below). Insights finding 3 ("hallucinated capabilities," 3 instances, including fabricated reviewer subagent types) corroborates this is a real, recurring failure mode, not a one-off.

Add one line to the `Safety` section:

```
- If unsure whether a tool, command, or capability exists, say so rather than fabricating details
```

This is universal (not dotfiles-specific), short (1 instruction), and directly corroborated by usage data — satisfies the framing-resilience criterion (unconditional, imperative) from research doc section 1/audit 4.

**Verify**: `/status` confirms the line loads; no functional test possible beyond behavioral observation over future sessions.

### 5. Remove dead frontmatter from `.claude/rules/toolchain.md`

**File**: `.claude/rules/toolchain.md` (project)

`description:` and `globs: "*"` are not recognized rules-file frontmatter keys (confirmed against official docs above — the real key is `paths`). Since there's no `paths:` field, the file was already loading unconditionally regardless of these keys, so this is a no-op fix, not a behavior change. Remove the frontmatter block entirely (or replace with nothing) so a future editor doesn't mistake `globs` for working path-scoping.

**Verify**: `/memory` still lists the file as loaded (unconditional rules show the same as before removal).

## Tier 2 — High impact, needs care

### 6. Resolve duplication between `.claude/rules/toolchain.md` and the project-root `CLAUDE.md`

**Files**: `.claude/rules/toolchain.md`, `CLAUDE.md` (repo root) — both project scope

The repo-root `CLAUDE.md`'s "rcm Behavior" section already states "Never modify files via their symlink targets in ~/. All changes happen in this repo" (implicitly, via the rcm-mapping bullets) and its "Workflow" section already requires `just check`. `toolchain.md` restates both points ("Never modify files via their symlink targets," "Use just recipes... do not create standalone shell scripts") nearly verbatim. Both are unconditional/always-loaded at project scope, so this is paying twice for the same two instructions.

**Risk/open question**: which file should own this content isn't purely mechanical — `CLAUDE.md`'s version is embedded in a longer structural description of rcm's file-mapping rules, while `toolchain.md`'s version is the more actionable, standalone phrasing (this is likely why insights finding 1 — 8/15 sessions with wrong toolchain assumptions — motivated writing `toolchain.md` in the first place, as a project-level, less-diluted restatement per the "may or may not be relevant" framing problem in research doc section 1). Recommend keeping the actionable instruction in `toolchain.md` (where it isn't diluted among file-mapping mechanics) and trimming the redundant instruction (not the whole section — the file-mapping bullets in `CLAUDE.md` still carry unique information) from `CLAUDE.md`'s rcm section down to a cross-reference. Needs a human read-through to confirm nothing unique is lost from either side before cutting.

**Verify**: after edit, grep both files for "symlink" and "just" to confirm no exact-duplicate sentences remain; `/memory` to confirm both still load.

### 7. Verify permission array merge behavior empirically

**Files**: `claude/settings.json` (global), `.claude/settings.json` (project) — verification only, no file change until confirmed

`claude/settings.json` has 28 `allow` entries (global read-only/formatting tools). `.claude/settings.json` adds 8 more (`just check/fmt/lint/test`, `rcup`, `rcdn`, `lsrc`, `nvim --headless`). Research doc section 3/Gaps: whether arrays are merged or replaced across scopes is unverified in official docs. If replaced, this repo's effective allowlist while working here is only the 8 project entries — the 28 global entries (including `Bash(rg:*)`, `Bash(git status:*)`, etc.) would silently stop auto-approving in this repo specifically, which would be a significant regression nobody would notice until they hit unexpected prompts.

**Verify**: in a fresh session in this repo, run a command covered only by the global list (e.g., `git status`) and confirm it doesn't prompt. If it does prompt, arrays replace rather than concatenate — the fix would be to duplicate needed global entries into `.claude/settings.json` or consolidate to one scope, per the research doc's own recommendation (section 3 Gaps).

### 8. Consider `defaultMode: "plan"` at project level only

**File**: `.claude/settings.json` (project) — not `claude/settings.json` (global)

`defaultMode` is not set anywhere currently (confirmed — no matches in any settings file). This is a gap, not a "reconsider an existing default" question as originally framed. Insights finding 2 (only 2 of 15 sessions fully achieved their goal, both using plan/implement session splits) is a real, corroborated signal, but it comes entirely from this dotfiles repo. Setting it globally risks imposing planning friction on repos where quick edits are the norm (explicitly the concern research doc section 3/audit 6 raises). Setting it at `.claude/settings.json` (project scope, higher precedence than global per research doc section 3) confines the effect to this repo, where the evidence actually applies, and costs nothing elsewhere.

**Caveat**: this is a one-line addition but changes default interactive behavior — every session in this repo will start in plan mode unless overridden. Test before committing to it. Note: `defaultMode` is a key under `permissions`, not top-level (`permissions.defaultMode`, confirmed against the live settings schema) — the top-level key is rejected as unrecognized.

**Verify**: start a new session in this repo, confirm it opens in plan mode; run `/status` to confirm the effective mode and its source (project vs. global vs. CLI).

### 9. Pin `enabledPlugins` versions

**File**: `claude/settings.json` (global)

`lua-lsp@claude-plugins-official` and `jdtls-lsp@claude-plugins-official` are both enabled with no SHA pin. Research doc section 11 confirms SHA pinning is supported (v2.1.14) as a defense against upstream breaking changes; section 10 notes ecosystem quality varies. Since Claude Code ships frequently and these plugins load into every session's tool/skill budget, pin them to a known-good commit.

**Risk**: pinning requires knowing the plugin's SHA history, which isn't available from local files — needs to be sourced from the plugin's marketplace/repo directly.

**Verify**: `/context` before and after to confirm the plugins' token cost is stable and justified; unpinned vs. pinned behavior differs only on upstream update, so no immediate observable difference.

## Tier 3 — Medium impact, opportunistic

### 10. Variadic lint recipe + lint hook (from old plan item 2, not yet implemented)

**Files**: `justfile`, `.claude/hooks/lint.sh` (new), `.claude/settings.json`

Confirmed not yet done: `justfile`'s `lint` recipe still uses `find` (not `fd`) and takes no path arguments; `.claude/hooks/` contains only `format.sh`, no `lint.sh`. The old plan's design (variadic `just lint *paths`, minimal hook glue calling it, exit 2 only on non-zero exit) is still sound and matches the exit-code guidance in research doc section 4. Mostly a justfile/repo-tooling change with a small Claude-config surface (the hook registration); kept at Tier 3 because it's not urgent and the `justfile` portion is outside pure Claude Code config.

**Correction from review**: register the new hook in the committed `.claude/settings.json`, not `.claude/settings.local.json`. The local file is gitignored and machine-local; `format.sh` (the existing precedent) is registered in the committed file, and a lint hook has no reason to be machine-specific — putting it in `settings.local.json` would make it unshared across machines, contradicting this repo's own shared-config principle.

**Verify**: `just lint` (no args) still works batched; `just lint <file>` dispatches by extension; editing a `.sh` file surfaces shellcheck warnings via the new hook.

### 11. Model-switching guidance (from old plan item 4)

**File**: `claude/CLAUDE.md` (global) — optional

Old plan proposed appending model-selection guidance (sonnet/haiku/opus by task type) to the `Thinking` section. Lower priority than originally framed: `claude/settings.json` already pins `"model": "sonnet"` as a session default and sets `"effortLevel": "high"`, which covers most of the intent at the settings layer (deterministic) rather than CLAUDE.md (probabilistic). A CLAUDE.md instruction would only add value for manual mid-session model switches, which is a narrower use case than the old plan implies. Defer unless a concrete friction point shows up.

### 12. Consolidate agent families or leave as-is

**Observation only** (`claude/agents/reviewer.md` vs. `review-correctness.md`/`review-performance.md`/`review-security.md`/`review-style.md`)

Two separate reviewer-agent systems exist: `Reviewer` (opus, spec/plan/final modes, used by `/feature` and the `execution.md`/`planning.md` rules loop) and the four specialized `Review*` agents (sonnet, single-purpose, used by `/peer-review`). This isn't a bug — different consumers, deliberately different cost/model tradeoffs (opus for the higher-stakes single reviewer, sonnet ×4 for the parallel specialized pass) — but flagging in case future maintenance assumes they're the same system. No action recommended.

## Excluded / deferred

**Already implemented (verified during this audit, not previously known)**:

- Destructive-git deny rules (old plan item 1) — all 8 proposed denies present in `claude/settings.json`, each backed by a `guard.sh` check except `.git/**` reads (Tier 1 item 2)
- Context management / session discipline (old plan item 3) — folded into `CLAUDE.md`'s `Session Discipline` section rather than a separate heading; functionally equivalent
- Path-scoped neovim/fish rules (old plan item 5) — `.claude/rules/neovim.md` and `fish.md` exist exactly as proposed, plus an unplanned `toolchain.md` (see Tier 2 item 6)
- Insights additions 3 and 4 ("implement-immediately," "conservative changes") — already phrased into `Session Discipline`: "start immediately--don't re-explore" and "Only modify files within the current task scope"
- `outputStyle` already switched from the non-existent `"concise"` to the custom `engineers-answer` style

**Output style / Communication section consolidation — evaluated, not a win here**: The prompt's framing expected this to be "the single largest instruction budget savings." It isn't. `engineers-answer.md` covers only voice/formatting register (senior-engineer prose, minimal bold/headers, minimal code boilerplate) — 4 short instructions. `CLAUDE.md`'s `Communication` section (11 instructions) covers tone, uncertainty handling, confidence percentages, analogies, and epistemic distinctions that the output style doesn't touch at all. Overlap is minimal; cutting the Communication section would lose content, not redundancy. No change recommended.

**`context: fork`**: not used anywhere in `claude/commands/` or `claude/agents/` — confirmed via grep. Nothing to remove.

**`additionalContext` for PreCompact context re-injection**: not designed or recommended, per plan content constraints and research doc Gaps section (effectiveness unverified).

**`:*` vs ` *` permission syntax migration**: `claude/settings.json` currently mixes both (`Bash(sudo:*)`, `Bash(rm -rf:*)` use the old colon syntax; the newly added destructive-git denies use the space-wildcard syntax). Per plan content constraints, both are valid and functionally identical — not worth a cleanup pass on its own merit. If touching `claude/settings.json` for another reason (e.g., Tier 1 item 2's related work), fine to normalize opportunistically, but not a standalone task.

**MCP servers**: none configured anywhere — checked `~/.claude.json` top-level `mcpServers` key (absent) and all 7 tracked projects' per-project MCP state (none set). Nothing to trim under research doc sections 7–8. Note: this session has `mcp__claude_ai_Gmail`/`Google_Calendar`/`Google_Drive` tools available, which are not sourced from `~/.claude.json` or any dotfiles-managed file — likely a claude.ai connector layer outside this repo's control. Not actionable via dotfiles; out of scope for this plan.

**`autoCompactEnabled`**: confirmed absent from every `settings.json` (correctly — it's silently ignored there per research doc section 7/issue #24589) and absent from `~/.claude.json` too, meaning default behavior applies. Nothing to change; flagging only because the prompt asked to verify placement.

**`SLASH_COMMAND_TOOL_CHAR_BUDGET` tuning**: not needed. 565 of 16,000 characters used (3.5%).

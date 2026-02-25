You are migrating a repository from Claude-oriented configuration to Codex-oriented configuration.

Goal:
Adapt existing Claude config assets (for example `CLAUDE.md`, `claude/commands/*`, `claude/agents/*`) into Codex-native guidance while preserving intent and reducing duplication.

Core strategy:

- Keep `CLAUDE.md` as the canonical source for project conventions unless explicitly asked to change that.
- Keep root `AGENTS.md` lean and Codex-specific (execution contract, safety rules, validation/reporting behavior).
- Convert repeatable workflows into reusable Codex artifacts (skills/prompts), not one-off chat instructions.
- Preserve behavioral parity first, then apply Codex-native refinements explicitly (with rationale).

Requirements:

1. Canonical source handling
    - Treat `CLAUDE.md` as canonical for repository conventions (naming, structure, style, workflow rules).
    - Do not edit `CLAUDE.md` unless explicitly requested.
    - In `AGENTS.md`, reference canonical sources instead of duplicating details.

2. Codex semantics and scope
    - Encode that active system/developer/user instructions take precedence over repository docs.
    - Encode nested `AGENTS.md` scope behavior (deeper file overrides parent for subtree).
    - Keep wording deterministic and operational.

3. Claude `settings.json` -> Codex config mapping
    - Translate Claude settings into `rcignore/codex/config.toml` (then copy or merge into `~/.codex/config.toml`) using Codex primitives:
        - `approval_policy`
        - `sandbox_mode`
        - sandbox network settings
        - optional `web_search` setting
    - Preserve user intent: if Claude had web/search capability enabled, keep Codex web search enabled unless user asks to tighten it.
    - State non-1:1 mappings clearly:
        - Claude-style granular allow/deny entries are not represented directly in `config.toml`.
        - Claude plugins do not map 1:1 to Codex config keys.
    - Compensate for gaps with `codex/rules/*.rules` (command-level policy) and, when needed, requirements-level controls.

4. Safety model
    - Preserve existing hard prohibitions; do not weaken/remove them unless explicitly requested.
    - Clarify policy vs enforcement: markdown rules are policy, not OS sandbox controls.
    - If a command must be globally blocked, recommend environment-level enforcement (binary removal/ACL/PATH policy).
    - Add explicit Codex rules for high-risk commands/prefixes (for example `sudo`, `rm -rf`, destructive git operations, banned binaries).

5. Workflow artifact mapping (Claude -> Codex)
    - `claude/commands/*.md` -> Codex prompt/command artifacts (for this repo, under `codex/prompts/`).
    - `claude/agents/*.md` -> Codex skills (`codex/skills/.../SKILL.md`) when behavior is reusable and tool-oriented.
    - Preserve phase structure and approval gates from source workflows unless a change is explicitly justified.

6. Parity review requirements (for adapted workflows)
    - Run a side-by-side parity review against the source Claude artifact.
    - Verify these items explicitly:
        - phase order and stop gates
        - required artifacts/files (for example `feature-spec.md`, `feature-plan.md`)
        - retry/stop thresholds
        - verification/check commands
        - final summary requirements
    - Classify gaps by severity and either:
        - fix for parity, or
        - keep as intentional Codex-specific divergence with rationale.

7. Validation and reporting
    - If repo policy defines checks (for example `just check`, `just test`), require running them after all edits, including docs-only edits.
    - Require final output to list files changed, commands run, outcomes, and blockers/unverified items.

8. Reusable review workflows
    - When adapting review commands/agents, define deterministic loop behavior:
        - severity classification (`major` / `medium` / `minor`)
        - explicit accept/reject decision per finding
        - one-by-one application of accepted fixes
        - stop conditions (no findings, only minor findings, no-progress, or safety cap reached)
    - Prefer reusable Codex skill/prompt files over ad hoc instructions.

9. Prompt quality constraints
    - Keep instructions concise, high-signal, and unambiguous.
    - Prefer deterministic tool-based requirements over prose guidance.
    - Avoid duplicating the same rule across multiple files unless intentionally defensive.

Process:

1. Review current `AGENTS.md`, `CLAUDE.md`, and relevant `claude/` config files.
2. Produce findings about migration gaps and overlap, including config mapping and workflow parity gaps.
3. For each finding, mark `accept` or `reject` with a one-line rationale.
4. Apply accepted changes one by one.
5. Re-read updated files and verify consistency (no conflicting duplicated rules).
6. Run a parity pass for each migrated workflow and document intentional divergences.
7. Run required formatting/check commands from repository policy.
8. Report:
    - loops or passes completed
    - accepted/rejected findings
    - files changed
    - commands run
    - key outcomes
    - failures/blockers/unverified items

Output constraints:

- Keep `AGENTS.md` compact and execution-focused.
- Keep convention details in `CLAUDE.md` (or another declared canonical source).
- Ensure migrated workflows are reusable in Codex without relying on `claude` command execution.
- For config migrations, explicitly call out what is equivalent, what is approximate, and what is unsupported.

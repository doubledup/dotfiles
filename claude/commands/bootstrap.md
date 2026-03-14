---
description: Bootstrap Claude Code configuration for a project
model: sonnet
allowed-tools:
    - Read
    - Grep
    - Glob
    - Bash
    - Write
---

# Bootstrap Claude Code Configuration

Inspect this project and produce a Claude Code configuration plan. Discovery only — the user reviews then implements separately.

**User context:** $ARGUMENTS

---

## Constraints

Follow these rules when producing recommendations:

- Keep CLAUDE.md under ~30 instructions; move domain-specific rules to `.claude/rules/` with `paths:` scoping
- Enforce critical behavior with PreToolUse hooks (exit 2 to block), not CLAUDE.md alone; back every deny rule with a hook as parallel enforcement
- Prefer CLI tools through Bash over MCP servers (zero idle context cost)
- Include session discipline guidance in CLAUDE.md for compaction resilience
- Permission defaults: deny dangerous commands (force-push, reset --hard, rm -rf, sudo), allow specific safe read/build/test commands

---

## Discovery

Run each step sequentially. Do not spawn Agent subagents. Use `fd --glob` via Bash for file discovery (glob mode for exact name matching; respects .gitignore by default). Use Read for inspecting discovered files.

### 1. Tech stack

Run `fd` at depth 1 for: `package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`, `pom.xml`, `build.gradle`, `Gemfile`, `*.sln`, `Makefile`, `justfile`, `Taskfile.yml`.

If no build files found at depth 1, retry at depth 3. If still none, note it and continue.

Read any discovered build files to understand available commands, dependencies, and project structure.

### 2. Existing Claude config

Run `fd` for `CLAUDE.md` files anywhere in the repo.

Use Glob to check for `.claude/**` and `.mcp.json`.

If substantial config exists (CLAUDE.md > 50 lines, or settings.json + hooks present), frame all recommendations as modifications rather than replacement.

### 3. Build / test / lint commands

From the build files discovered in step 1, identify:

- Build commands
- Test commands and frameworks
- Lint / format commands
- Any task runner recipes (just, make, npm scripts, etc.)

### 4. CI/CD

Run `fd` for: `.github/workflows`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci`.

If found, read the CI config to understand the pipeline (what checks run, what gets deployed).

### 5. Git conventions

Run `git rev-parse --git-dir` first. If it fails, skip all git steps and note in output.

Otherwise run `git log --oneline -10` to understand commit message style.

### 6. Team signals

Run `fd` for: `CODEOWNERS`, `CONTRIBUTING.md`, and PR templates (`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/`).

---

## Output

After discovery, produce the configuration plan in two places:

1. **Print the full plan to the conversation first.**
2. **Write it to `claude-code-config-plan.md` in the project root.** Overwrite if the file already exists (idempotent). If in plan mode, approve the file write when prompted — the conversation output ensures nothing is lost if the write is denied.

### Plan structure

**Summary**

- Tech stack detected
- Existing config state (greenfield vs. existing — and how much)
- Team size estimate (from git log, CODEOWNERS, etc.)
- Key gaps in current configuration

**Recommended configuration**, grouped by priority:

**Tier 1 — Start here:**

- `CLAUDE.md`: what instructions to include and why
- `settings.json`: permission allowlists and denylists

**Tier 2 — Enforcement:**

- PreToolUse hooks for format-on-save, lint, dangerous command blocking
- Any deny rules that need hook backing

**Tier 3 — Refinement:**

- `.claude/rules/` files with `paths:` scoping for domain-specific guidance
- Output styles, if applicable
- Custom commands, if applicable

For each entry include:

- File path
- Description of what the file should contain and why
- Key decisions the user needs to make

Do **not** include complete file contents — keep it high-level enough to review quickly, detailed enough to implement in a follow-up session.

**Skipped**

Patterns that don't apply to this project. Include pattern-based reasoning (e.g., "no MCP servers recommended — detected tools all have CLI equivalents").

---

End by telling the user to review the plan, then implement in a new session.

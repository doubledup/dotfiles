---
name: review-loop-codex
description: Run structured iterative review loops on a target file or prompt with explicit accept/reject decisions per finding, one-by-one revisions, and re-review cycles. Use when Codex should improve docs, prompts, or guidance files through repeated review/revise iterations with validation after edits.
---

# Review Loop (Codex)

## Overview

Use this skill to run disciplined improvement loops on a target artifact (for example `AGENTS.md`, prompt files, policy docs).

Default stopping rule: continue iterating until only minor issues remain.
Use a safety cap of 5 loops unless the user specifies a different cap.

## Inputs

- Target file path.
- Reviewer persona/focus (for example: "senior engineer and AI-assisted coding expert").
- Optional constraints (word count, canonical source, files not to edit).
- Optional stop policy override (for example fixed loop count or stricter quality bar).
- PR communication style file (default: `~/.claude/output-styles/pr-comms.md`).

## Loop Workflow

Before loop 1:

1. Read root `AGENTS.md` and any relevant nested `AGENTS.md`.
2. Read the target file and declared canonical source files (for example `CLAUDE.md`).

For each loop:

1. Review the target with the requested reviewer lens.
2. Produce findings with severity and file/line references for actionable findings.
3. Prioritize findings by severity: major before minor.
4. For each finding, explicitly mark:
    - `accept`: one-line rationale.
    - `reject`: one-line rationale.
5. Apply accepted changes one by one (one discrete edit per accepted finding).
6. Re-open the file and verify the accepted changes are present.
7. Re-review and classify remaining findings:
    - `major`: correctness/safety/policy/regression risks.
    - `medium`: maintainability/structure/readability issues that are meaningful but not correctness or safety risks.
    - `minor`: wording, clarity, or low-impact polish.
8. Stop when only minor findings remain, or when the loop cap is reached.
9. If the loop cap is reached and major findings remain, stop and report unresolved major findings explicitly.

If no findings are accepted in a loop, make no edits and state that explicitly.
If two consecutive loops produce no accepted changes and no material finding changes, stop and report no-progress termination.
Treat a finding as materially changed only if severity, location, or core issue statement changes.
Example: wording tweaks to the same issue are not material; changing an issue from `medium` to `major` is material.
If no findings remain, stop immediately and report the target as ready.
When only minor findings remain, list those minor findings as optional follow-ups.

## Editing Rules

- Keep edits minimal, high-signal, and aligned with repository conventions.
- Preserve existing hard prohibitions unless explicitly asked to change them.
- If another file is declared canonical (for example `CLAUDE.md`), do not duplicate detailed conventions in the target; point to the canonical file.

## Validation

After edits, run required repository checks from current policy (for example `just check` and `just test` in this repo).

If a command cannot run, report the blocker and what remains unverified.

## GitHub PR Comment Workflow

Use this workflow when findings should be posted to a PR (comments only; PR descriptions are out of scope for this skill).

1. Load the PR comms style file (default: `~/.claude/output-styles/pr-comms.md`).
2. Draft comments in that style:
    - Use `we` voice and review tags from style (`nit:`, `suggestion:`, `question:`, `issue:`, `request:`).
    - One idea per comment.
    - Name exact files/fields/lines for remaining gaps.
    - When listing multiple files, use bullet points with markdown links and filename-only link text.
3. Prefer inline comments on relevant changed line(s)/range.
4. Build each inline comment using `gh api repos/<owner>/<repo>/pulls/<pr>/comments`:
    - Single line: `commit_id`, `path`, `side`, `line`, `body`
    - Range: `commit_id`, `path`, `start_line`, `start_side`, `line`, `side`, `body`
5. Before posting, verify:
    - File is in PR diff.
    - Line/range exists in PR patch.
6. Present drafts to the user before posting. Include:
    - Thread context (path + line and current thread summary)
    - Proposed comment body
7. Wait for explicit user approval.
8. Post approved comments.
9. After posting, verify each URL is inline (`#discussion_r...`).
10. If no valid inline anchor exists, explain why and ask before using top-level PR comments.

## Final Report Format

Include:

- Loops completed.
- Accepted vs rejected findings per loop.
- Files changed.
- Commands run.
- Key outcomes.
- Failures/blockers/unverified items.
- Unresolved major findings (if any).
- Residual minor follow-ups (if any).

## Notes for This Repository

- Never run `claude`.
- Current reusable prompt seed: `rcignore/claude-to-codex-prompt.md`.

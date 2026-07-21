---
description: Generate a self-contained prompt for a fresh Claude Code session
allowed-tools:
    - Read
    - Glob
    - Bash
    - Write
    - AskUserQuestion
---

# Handoff Prompt

Produce a self-contained prompt that a fresh Claude Code session can act on with no
memory of this conversation. Fresh sessions start blank, so the prompt must carry every
piece of context, file reference, and constraint it needs.

**Fresh-session task:** $ARGUMENTS

---

## 1. Clarify

If `$ARGUMENTS` does not already make these clear, ask via AskUserQuestion, then wait:

- **Prompt type**: generation/task (build or produce something), decision (choose
  between options), review-kickoff (evaluate a document or change), or
  continuation-handoff (resume in-progress work).
- **Desired output**: a plan, a recommendation, or applied edits.
- **Mode**: plan mode or normal.
- **Context it needs**: the key files, paths, and prior decisions the fresh session
  cannot infer on its own.

## 2. Gather

Read the named files and paths. Distill only what the fresh session needs: a
self-contained context summary, a short "facts to build on (verified)" list, and a
"files to read first" list. Do not paste large file contents; point to files and
summarize.

## 3. Draft

Write the prompt with the structure below, adapting the middle to the prompt type.
Invariants for every type:

- A preamble: "Paste into <mode>, in <repo>, fresh session. Read the files from disk; do
  not infer their contents from this prompt."
- Self-contained context with **no reference to this conversation** (phrases like "as we
  discussed" or "the earlier plan" are disallowed).
- A "Files to read first" list.
- An explicit output spec (plan / recommendation / edits, and whether to apply changes).

Type-specific middle:

- **Generation/task**: the task, standing conventions, and acceptance criteria.
- **Decision**: a balanced, neutral tradeoff section (do not lead the witness) and a
  "What I need from you (in order)" that asks the unknowns before recommending.
- **Review-kickoff**: the document or change under review, an anti-anchoring
  instruction, and the evaluation dimensions.
- **Continuation-handoff**: state so far, decisions already made, files touched, and the
  next steps.

## 4. Self-check

Before finalizing, confirm: self-contained (a stranger could act on it); neutral if a
decision; no fabricated Claude Code features (verify or omit); files listed; output spec
present; standing conventions respected (rcm-managed edits, `just` recipes for
automation, no fabrication).

## 5. Save and present

Write the prompt to a target path: use the path from `$ARGUMENTS` if given, otherwise
propose one that fits the current repo (do not default to a narrow workspace such as a
config-improvement directory) and confirm it. Then show the prompt and **STOP** for the
user to review or tweak. Mention that it can optionally be sent through the Reviewer
before use.

# Fix Failures Workflow

Investigate and fix build or test failures, one at a time with verification.

**Command to run:** $ARGUMENTS

---

## Phase 1: Identify Failures

1. Run the provided command
2. Parse the output to identify all failures
3. Group related failures (same module, similar errors, likely shared root cause)
4. Present the groups:
    - Number of failures
    - Groupings and rationale
    - Which group to start with

Proceed to Phase 2 with the first group.

---

## Phase 2: Triage (per failure)

Goal: Understand what's failing and why.

1. Identify the specific failure from the group
2. Determine: is this a test bug or an implementation bug?

**Default rule:** The most recent expression of intent takes precedence. Check in this order:

1. Plan or spec from this session
2. Staged changes (git staging area)
3. Recent commits
4. The test itself (if nothing more recent exists)

Update whichever side (test or implementation) contradicts the most recent intent.

**STOP and ask for guidance if:**

- Intent is unclear (test expectation vs implementation behavior)
- The failure suggests the test itself is wrong

Otherwise, proceed to Phase 3.

---

## Phase 3: Investigate

Goal: Understand the failure with minimum context.

**Attempt 1 (shallow):**

- Read only the failing test
- Read only the code directly under test
- Form a hypothesis

**Attempt 2+ (deep):**

- Trace dependencies of the code under test
- Check recent changes (`git log`, `git blame`)
- Read related tests for patterns

Proceed to Phase 4 with a fix hypothesis.

---

## Phase 4: Fix

Goal: Make the smallest change that fixes the failure.

1. Implement the fix
2. Keep changes isolated to the module under test

**STOP and ask for guidance if:**

- The fix requires changes outside the failing module
- You're on attempt 3+ (2 failed attempts already)

---

## Phase 5: Verify

Goal: Confirm the fix works and hasn't broken anything.

1. Run the specific failing test
    - If still failing → return to Phase 3 (deeper investigation)
2. Run the full test suite
    - If new regressions → **STOP and ask for guidance** (fix may have unintended effects)
    - If all passing → proceed to Phase 6

---

## Phase 6: Checkpoint

1. Summarize what was fixed and how
2. Report remaining failures (if any)

**If fixes completed ≥ 5 this session:**

> "Context is filling up. Want me to /compact and continue, or start a fresh session?"

**If failures remain:**

> "Fixed [description]. [N] failures remaining in [M] groups. Continue?"

**STOP and wait for user confirmation before next failure.**

---

## Pause Triggers (summary)

Pause and ask for guidance when:

- Intent is unclear (test wrong vs code wrong)
- Fix requires changes outside the module under test
- 2 fix attempts have failed
- New regressions appear after a fix
- 5+ fixes completed (ask about context management)

---

## End Condition

When all failures are fixed and the full suite passes:

1. Summarize all fixes made
2. List any patterns noticed (recurring issues, tech debt)
3. Note any follow-up items

**End of workflow.**

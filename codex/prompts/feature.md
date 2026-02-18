# Feature Implementation Workflow (Codex)

Implement a feature with explicit approval gates and stepwise verification.

**Feature request:** $ARGUMENTS

---

## Phase 1: Spec

Goal: Understand and document what we are building.

1. Explore the codebase to gather context:
    - Where this feature fits
    - Relevant files and dependencies
    - Existing patterns and constraints
    - If the request is too vague to locate context, ask clarifying questions before continuing
2. Ask clarifying questions when needed:
    - Problem to solve
    - Expected behavior and acceptance criteria
    - Edge cases and error conditions
    - Constraints and non-goals
3. Draft a spec including:
    - Problem statement (1-2 sentences)
    - Testable acceptance criteria
    - Edge cases
    - Out of scope (if useful)
4. Review the spec with a `spec` lens:
    - Include the full spec text in the review input.
    - Format each item as: `Consider: <observation>. <why it matters>.`
5. Present spec + review notes.

**STOP and wait for user approval before proceeding.**

If needed, iterate this phase until approved. After approval, save to `feature-spec.md` (confirm before overwrite), then run `/compact` when available.

---

## Phase 2: Plan

Goal: Define implementation approach and execution order.

1. Re-explore implementation context and risks.
2. For non-trivial features:
   a. Propose 2-3 approaches with tradeoffs.
   b. Recommend one.

**If step 2 is used: STOP and wait for user to choose a direction.**

3. Build an ordered plan. Each step must include:
    - What changes
    - Why (which acceptance criterion it satisfies)
    - How to verify (specific command/test/check)
4. Review the plan with a `plan` lens:
    - Include `feature-spec.md` content and the current plan in the review input.
    - Format each item as: `Consider: <observation>. <why it matters>.`
5. Present plan + review notes.

**STOP and wait for user approval before proceeding.**

If needed, revise and repeat. After approval, save to `feature-plan.md` (confirm before overwrite).

---

## Phase 3: Execute

Goal: Implement with tight feedback loops.

Re-read `feature-spec.md` and `feature-plan.md` first.

Rules:

- One plan step at a time.
- Minimal diff per step. One concern per change.
- Reason before editing.

For each plan step:

1. Implement the change.
2. Run the step's verification.
3. Continue only if it passes.
4. If it fails:
    - Debug and retry.
    - After 2 failed attempts, STOP and ask for guidance.

After all steps pass, run the full required checks/tests (`just check` and `just test` in this repo).

---

## Phase 4: Review

Goal: Ensure quality against spec and plan.

1. Run a final review with a `final` lens:
    - Include `feature-spec.md` and `feature-plan.md` content in the review input.
    - Correctness, consistency, safety, edge cases, regressions, overengineering.
    - Format each issue as: `Issue: <problem>. <why it matters>. Suggested fix: <action>.`
2. Also run Codex `/review` on the resulting diff (or do a manual diff review if `/review` is unavailable).
3. If issues are found:
    - Fix using Phase 3 execution rules.
    - Re-verify.
    - Re-review.
    - After 3 fix-review cycles, STOP and present remaining issues.
4. Present final summary:
    - Files changed
    - How acceptance criteria were satisfied
    - Follow-up notes

End of workflow. User can now commit, request changes, or discard. Keep `feature-spec.md` and `feature-plan.md` for traceability.

---

## Global Rules

- Do not skip approval gates (spec and plan).
- Never implement everything at once. Follow the phases.
- Prefer smallest sufficient changes.
- Reason before coding. Understand before modifying.
- Be critical during review. Assume something was missed.
- Be explicit about risks and unknowns.
- If complexity grows, call it out and propose scope adjustment.

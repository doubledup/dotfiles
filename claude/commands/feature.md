# Feature Implementation Workflow

Implement a feature following a structured workflow with review checkpoints.

**Feature request:** $ARGUMENTS

---

## Phase 1: Spec

Goal: Understand and document what we're building.

1. Explore the codebase to understand context:
    - Where does this feature fit in the system?
    - Read relevant files and trace dependencies
    - Note existing patterns to follow
    - If the request is too vague to know where to look, ask clarifying questions first (step 2)

2. Ask clarifying questions if needed about:
    - The problem being solved
    - Expected behavior and acceptance criteria
    - Edge cases and error conditions
    - Any constraints or non-goals

3. Draft a spec that includes:
    - Problem statement (1-2 sentences)
    - Acceptance criteria (testable statements)
    - Edge cases to handle
    - Out of scope (if relevant)

4. Use the Reviewer agent in `spec` mode to review the spec.
   Include the spec text in the prompt.

5. Present the spec and reviewer feedback to the user.

**STOP and wait for user approval before proceeding.**

If the user identifies gaps, revise the spec and repeat this phase.

After approval, save the spec to `feature-spec.md` (confirm with user before overwriting). Run `/compact` before proceeding to Phase 2.

---

## Phase 2: Plan

Goal: Define how we'll implement this feature.

1. Explore the codebase for implementation context:
    - Identify which files are relevant and trace dependencies
    - Note existing patterns and constraints
    - Identify risks or complications

2. For non-trivial features:
   a. Briefly outline 2-3 approaches with tradeoffs (complexity, risk, testability, alignment with existing patterns)
   b. Recommend one with reasoning
   c. Present approaches to the user and confirm direction before proceeding

3. Break the chosen approach into an ordered implementation plan where each step includes:
    - What to change
    - Why (links to which acceptance criterion)
    - How to verify (specific test or check)

4. Use the Reviewer agent in `plan` mode to review the plan.
   Include the contents of `feature-spec.md` and the plan in the prompt.

5. Present the plan and reviewer feedback to the user.

**STOP and wait for user approval before proceeding.**

If the user requests changes, revise the plan.

After approval, save the plan to `feature-plan.md` (confirm with user before overwriting).

---

## Phase 3: Execute

Goal: Implement the plan with verification at each step.

Re-read `feature-spec.md` and `feature-plan.md` before starting.

Rules:

- One step at a time. Do not batch steps.
- Minimal diff per step. One concern per change.
- Reason about what the step requires before writing code.

For each step in the plan:

1. Implement the change
2. Run the verification defined in the plan
3. If verification passes, continue to next step
4. If verification fails:
    - Attempt to debug and fix (explore the failure, plan a fix, execute it)
    - If still failing after 2 debug attempts, STOP and ask for guidance

After all steps complete, run the full test suite.

---

## Phase 4: Review

Goal: Verify the complete change meets quality standards.

1. Use the Reviewer agent in `final` mode to review all changes.
   Include the contents of `feature-spec.md` and `feature-plan.md` in the prompt.

2. If the reviewer finds issues:
    - Fix them using Phase 3 execution rules, guided by the specific findings
    - Re-run verification
    - Re-run the review
    - If issues persist after 3 fix-review cycles, STOP and present remaining findings to the user

3. Present the final summary:
    - Changes made (files, brief description)
    - How each acceptance criterion was addressed
    - Any notes or follow-up items

**End of workflow.** User can now commit, request changes, or discard. `feature-spec.md` and `feature-plan.md` remain in the working directory for reference.

---

## Global Rules

These apply across all phases:

- Never implement everything at once. Follow the phases.
- Never skip approval gates (spec and plan).
- Prefer the smallest sufficient change.
- Reason before coding. Understand before modifying.
- Be critical during review. Assume something was missed.
- If the feature is more complex than expected, say so and propose adjusting scope.

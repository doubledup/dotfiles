# Feature Implementation Workflow

Implement a feature following a structured workflow with review checkpoints.

**Feature request:** $ARGUMENTS

---

## Phase 1: Spec

Goal: Understand and document what we're building.

1. Ask clarifying questions about:
   - The problem being solved
   - Expected behavior and acceptance criteria
   - Edge cases and error conditions
   - Any constraints or non-goals

2. Draft a spec that includes:
   - Problem statement (1-2 sentences)
   - Acceptance criteria (testable statements)
   - Edge cases to handle
   - Out of scope (if relevant)

3. Use the Reviewer agent in `spec` mode to review the spec.

4. Present the spec and reviewer feedback to the user.

**STOP and wait for user approval before proceeding.**

If the user identifies gaps, revise the spec and repeat this phase.

---

## Phase 2: Explore

Goal: Understand the codebase context for this feature.

1. Identify where this feature fits in the system
2. Read relevant files and trace dependencies
3. Note existing patterns we should follow
4. Identify exactly which files need changes

5. Summarize findings:
   - Files to modify (with purpose)
   - Patterns to follow
   - Potential risks or complications

If exploration reveals gaps in the spec, say so and loop back to Phase 1.

Otherwise, proceed directly to Phase 3.

---

## Phase 3: Plan

Goal: Define how we'll implement this feature.

1. Create an ordered implementation plan where each step includes:
   - What to change
   - Why (links to which acceptance criterion)
   - How to verify (specific test or check)

2. Use the Reviewer agent in `plan` mode to review the plan.

3. Present the plan and reviewer feedback to the user.

**STOP and wait for user approval before proceeding.**

If the user requests changes, revise the plan. You may need to explore further.

---

## Phase 4: Execute

Goal: Implement the plan with verification at each step.

For each step in the plan:
1. Implement the change
2. Run the verification defined in the plan
3. If verification passes, continue to next step
4. If verification fails:
   - Attempt to debug and fix (explore the failure, plan a fix, execute it)
   - If still failing after 2 debug attempts, STOP and ask for guidance

After all steps complete, run the full test suite.

---

## Phase 5: Review

Goal: Verify the complete change meets quality standards.

1. Use the Reviewer agent in `final` mode to review all changes.

2. The reviewer will check:
   - Correctness: tests pass, spec addressed
   - Consistency: matches codebase style
   - Completeness: all acceptance criteria met
   - Safety: no antipatterns or error-prone code
   - Edge cases: all identified cases handled

3. If the reviewer finds issues:
   - Fix them
   - Re-run verification
   - Re-run the final review

4. Present the final summary:
   - Changes made (files, brief description)
   - How each acceptance criterion was addressed
   - Any notes or follow-up items

**End of workflow.** User can now commit, request changes, or discard.

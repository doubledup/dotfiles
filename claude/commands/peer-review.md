---
description: Automated code review dispatching parallel review agents
allowed-tools:
    - Read
    - Grep
    - Glob
    - Bash
    - Task
---

# Peer Review

Perform automated code review on changes before merging.

**Arguments:** $ARGUMENTS

---

## Phase 1: Parse & Validate

Goal: Understand what diff to review.

1. Parse arguments to determine diff source (mutually exclusive):
    - No flags: HEAD vs main/master (auto-detect which exists)
    - `--base <branch>`: HEAD vs specified branch
    - `--staged`: Staged changes vs HEAD
    - `--uncommitted`: All working tree changes vs HEAD (staged + unstaged)
    - `--commit <sha>`: Specific commit's changes
    - GitHub PR URL (e.g., `https://github.com/org/repo/pull/123`): PR's changes vs its base branch
    - For PR URL: fetch metadata via `gh pr view <url> --json baseRefName,number`. If the URL is invalid or not found: Error

2. Check for `--only <agent>` flag (can combine with any diff source):
    - Valid values: correctness, security, style, performance

3. Validate:
    - If multiple diff source flags: Error listing conflicts
    - If PR URL provided with any diff source flag: Error listing conflicts
    - If invalid `--only` value: Error listing valid agents
    - If not in a git repo (`git rev-parse --is-inside-work-tree` fails): Error
    - If `--staged` and no commits exist (`git rev-parse HEAD` fails): Error "No commits yet. Use `--uncommitted` to review changes."

4. For default/--base/PR URL modes, verify base branch exists:
    - PR URL mode: use `baseRefName` from metadata directly as the base — skip the main/master detection below and proceed to step 5
    - Default/--base: Try `git rev-parse --verify refs/heads/main`
    - If fails, try `git rev-parse --verify refs/heads/master`
    - If both fail and no `--base` provided: Error with guidance to use `--base <branch>`

5. Resolve the base ref to its remote-tracking counterpart (ensures the diff matches PRs, avoiding stale local branches inflating the line count):
    - Run `git fetch origin <base>` to update the remote-tracking ref
    - If fetch succeeds, use `origin/<base>` as the resolved base ref for all diff commands
    - If fetch fails (offline, no remote), fall back to the local `<base>` ref
    - Note: For PR URL mode, `<base>` is `baseRefName` from metadata, which refers to a branch on the target (upstream) repository — assumed to be `origin`

---

## Phase 2: Checkout PR Branch (PR URL only)

Goal: Ensure the working tree matches the PR branch so review agents see the correct file state.

Skip this phase if the diff source is not a GitHub PR URL.

**Important:** Once checkout succeeds (step 3), the original ref MUST be restored before ANY subsequent exit point — including early exits for empty diff, diff too large, or errors in later phases. See Phase 6 step 6.

1. Record the current ref for later restoration:
    - `git symbolic-ref --short HEAD` (or `git rev-parse --short HEAD` if detached)

2. Check for uncommitted changes to tracked files:
    - Run `git status --porcelain` and filter out untracked files (lines starting with `??`)
    - If any remaining output: Stop and ask the user to stash or commit their changes before proceeding

3. Check out the PR branch locally:
    - Run `gh pr checkout <number>` (using the PR number from Phase 1 step 1 metadata)
    - This handles fork PRs automatically (creates a local branch tracking the fork remote)
    - If checkout fails: Stop and ask the user to resolve the issue

---

## Phase 3: Get Diff

Goal: Retrieve diff content and check size.

**PR URL mode:** If any step in this phase exits or errors, restore the original ref first (see Phase 6 step 6).

1. Get diff content based on mode (use the resolved base ref from Phase 1 step 5). If the diff command fails: Error "Failed to retrieve diff.":
    - Default: `git diff <resolved-base>...HEAD`
    - `--base <branch>`: `git diff <resolved-base>...HEAD`
    - `--staged`: `git diff --cached`
    - `--uncommitted`: `git diff HEAD`
    - `--commit <sha>`: `git show <sha> --format=` (for merge commits, shows first-parent diff; for root commits with no parent, shows full content)
    - PR URL: `git diff <resolved-base>...HEAD` (after Phase 2 checkout, same mechanics as default mode)

2. Validate commit SHA if using `--commit`:
    - `git rev-parse --verify <sha>` - if fails: Error with clear message
    - Note: Root commits (no parent) are handled automatically by `git show`

3. Check for empty diff:
    - If diff is empty: Print "No changes to review" and exit

4. Calculate line count using `git diff --numstat` (same source as above):
    - If command fails: Error "Failed to analyze diff size."
    - Sum additions + deletions columns
    - Skip lines showing `-` (binary files)
    - If 400+ lines: Print warning "Large diff detected (X lines). Consider splitting for more thorough review." but proceed
    - If 1500+ lines: Print "Diff too large (X lines). Please split into smaller changes for effective review." and exit

5. Identify files to skip (note these for output):
    - Binary files (shown as `-` in numstat)
    - Submodule changes (mode 160000 in diff)
    - Single-line files >300 characters (check with `wc -l` and `wc -c`)
    - Note: Symlinks are followed and reviewed normally
    - Note: File renames are reviewed as normal file changes

6. Get metadata for filename:
    - Try `git symbolic-ref --short HEAD` for branch name
    - If fails (detached HEAD): Use first 7 chars of `git rev-parse HEAD`
    - For `--staged`/`--uncommitted`/`--commit`: Get HEAD SHA with `git rev-parse --short HEAD`
    - Sanitize branch name: replace non-alphanumeric characters (except `-` and `_`) with `-`

---

## Phase 4: Dispatch Agents

Goal: Run review agents in parallel.

1. Determine repo root: `git rev-parse --show-toplevel`

2. Prepare agent context:
    - The diff content from Phase 3
    - The repo root path (for agents to read CLAUDE.md and surrounding code)
    - List of files touched by the diff

3. Determine which agents to run:
    - If `--only <agent>`: Run only that agent
    - Otherwise: Run all four (correctness, security, style, performance)

4. Invoke agents in parallel using the Task tool:
    - Pass diff content embedded in the prompt
    - Pass repo root path
    - Pass list of touched files
    - Each agent should return findings in the structured format

5. Collect results:
    - Wait for all agents to complete
    - Note any agent failures for reporting

---

## Phase 5: Collect & Merge

Goal: Combine agent outputs into final report.

1. For each successful agent, parse findings:
    - Extract Errors, Warnings, and Suggestions sections
    - Each finding has: file, line, message

2. Deduplicate within each agent:
    - Same file + same line + same message = keep only one

3. Handle agent failures:
    - Note which agents failed
    - Proceed with results from successful agents

4. Build output document:

    Calculate additions and deletions using this script (awk fails due to shell escaping in this tool):
    ```bash
    git diff --numstat <same-source-as-phase-3> | python3 -c "
    import sys
    add = del_ = 0
    for line in sys.stdin:
        parts = line.split()
        if parts[0] != '-': add += int(parts[0])
        if parts[1] != '-': del_ += int(parts[1])
    print(f'{add} additions, {del_} deletions')
    "
    ```

    Then build the document:

    ```
    # Peer Review: <source description>

    **Date:** YYYY-MM-DD HH:MM:SS
    **Diff:** <description of what was reviewed>
    **Lines:** X additions, Y deletions

    [If any agents failed:]
    > **Note:** The following review agents failed: <list>. Results below are partial.

    ## Correctness Findings
    [Agent output or "No issues found."]

    ## Security Findings
    [Agent output or "No issues found."]

    ## Style Findings
    [Agent output or "No issues found."]

    ## Performance Findings
    [Agent output or "No issues found."]

    ## Skipped Files
    - `file.min.js` - Binary file
    - `vendor/lib.js` - Single-line file >300 characters
    ```

---

## Phase 6: Write Output

Goal: Save report to file.

**PR URL mode:** If any step in this phase exits or errors, restore the original ref first (see step 6).

1. Create output directory if needed:
    - Check if `claude/reviews/` exists relative to repo root
    - If not, create it

2. Generate filename:
    - Format: `YYYY-MM-DD-HHMMSS-<source>.md`
    - Source based on mode:
        - Default (on branch): `<branch-name>` (sanitized)
        - Default (detached): `detached-<7-char-sha>`
        - `--staged`: `staged-<7-char-sha>`
        - `--uncommitted`: `uncommitted-<7-char-sha>`
        - `--commit`: `commit-<7-char-sha>`
        - PR URL: `pr-<number>`

3. Handle collisions:
    - Check if file exists
    - If so, append `-1`, `-2`, etc. (up to `-99`)
    - If all 100 exist: Error (extremely unlikely)

4. Write the file

5. Print summary to terminal:
    - Path to output file
    - Count of findings by severity (X errors, Y warnings, Z suggestions)
    - If any agents failed, remind user

6. Restore original ref (PR URL mode only — runs on ALL exit paths after Phase 2 checkout):
    - Run `git checkout <original-ref>` (recorded in Phase 2 step 1)
    - If the original ref is a SHA (detached HEAD), this correctly restores detached state — not a failure
    - If restore fails: Print warning with the original ref so the user can switch back manually

---

## Error Messages

Use these exact messages for consistency:

- Not a git repo: "Error: Not inside a git repository."
- No main/master: "Error: Could not find 'main' or 'master' branch. Use `--base <branch>` to specify the base branch."
- Multiple diff flags: "Error: Multiple diff source flags provided (<list>). Use only one of: --base, --staged, --uncommitted, --commit, or a PR URL"
- Invalid --only: "Error: Invalid agent '<value>'. Valid agents: correctness, security, style, performance"
- Invalid SHA: "Error: Commit '<sha>' not found."
- No commits (with --staged): "Error: No commits yet. Use `--uncommitted` to review changes."
- Diff retrieval failed: "Error: Failed to retrieve diff."
- Diff analysis failed: "Error: Failed to analyze diff size."
- Diff too large: "Diff too large (X lines). Please split into smaller changes for effective review."
- Filename collision: "Error: Unable to create output file - too many files with same timestamp."
- Empty diff: "No changes to review."
- PR not found: "Error: PR not found at '<url>'. Verify the URL and your GitHub authentication."
- Dirty working tree: "Error: Uncommitted changes detected. Please stash or commit your changes before reviewing a PR."
- Checkout failed: "Error: Failed to check out PR #<number>. Please resolve the issue and try again."
- Restore failed: "Warning: Could not restore original ref '<ref>'. Run `git checkout <ref>` manually."

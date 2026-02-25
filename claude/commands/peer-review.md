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

2. Check for `--only <agent>` flag (can combine with any diff source):
    - Valid values: correctness, security, style, performance

3. Validate:
    - If multiple diff source flags: Error listing conflicts
    - If invalid `--only` value: Error listing valid agents
    - If not in a git repo (`git rev-parse --is-inside-work-tree` fails): Error
    - If `--staged` and no commits exist (`git rev-parse HEAD` fails): Error "No commits yet. Use `--uncommitted` to review changes."

4. For default/--base modes, verify base branch exists:
    - Try `git rev-parse --verify refs/heads/main`
    - If fails, try `git rev-parse --verify refs/heads/master`
    - If both fail and no `--base` provided: Error with guidance to use `--base <branch>`

5. Resolve the base ref to its remote-tracking counterpart (ensures the diff matches PRs, avoiding stale local branches inflating the line count):
    - Run `git fetch origin <base>` to update the remote-tracking ref
    - If fetch succeeds, use `origin/<base>` as the resolved base ref for all diff commands
    - If fetch fails (offline, no remote), fall back to the local `<base>` ref

---

## Phase 2: Get Diff

Goal: Retrieve diff content and check size.

1. Get diff content based on mode (use the resolved base ref from Phase 1 step 5):
    - Default: `git diff <resolved-base>...HEAD`
    - `--base <branch>`: `git diff <resolved-base>...HEAD`
    - `--staged`: `git diff --cached`
    - `--uncommitted`: `git diff HEAD`
    - `--commit <sha>`: `git show <sha> --format=` (for merge commits, shows first-parent diff; for root commits with no parent, shows full content)

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

## Phase 3: Dispatch Agents

Goal: Run review agents in parallel.

1. Determine repo root: `git rev-parse --show-toplevel`

2. Prepare agent context:
    - The diff content from Phase 2
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

## Phase 4: Collect & Merge

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

## Phase 5: Write Output

Goal: Save report to file.

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

3. Handle collisions:
    - Check if file exists
    - If so, append `-1`, `-2`, etc. (up to `-99`)
    - If all 100 exist: Error (extremely unlikely)

4. Write the file

5. Print summary to terminal:
    - Path to output file
    - Count of findings by severity (X errors, Y warnings, Z suggestions)
    - If any agents failed, remind user

---

## Error Messages

Use these exact messages for consistency:

- Not a git repo: "Error: Not inside a git repository."
- No main/master: "Error: Could not find 'main' or 'master' branch. Use `--base <branch>` to specify the base branch."
- Multiple diff flags: "Error: Multiple diff source flags provided (<list>). Use only one of: --base, --staged, --uncommitted, --commit"
- Invalid --only: "Error: Invalid agent '<value>'. Valid agents: correctness, security, style, performance"
- Invalid SHA: "Error: Commit '<sha>' not found."
- No commits (with --staged): "Error: No commits yet. Use `--uncommitted` to review changes."
- Diff analysis failed: "Error: Failed to analyze diff size."
- Diff too large: "Diff too large (X lines). Please split into smaller changes for effective review."
- Filename collision: "Error: Unable to create output file - too many files with same timestamp."
- Empty diff: "No changes to review."

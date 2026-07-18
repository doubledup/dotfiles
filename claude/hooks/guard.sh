#!/bin/bash
# PreToolUse guard hook: block Read/Write/Edit/Grep/Glob access to secret paths.
#
# Path-matching only - it reads the tool's structured path input (.file_path,
# or .path for Grep/Glob) and never parses a Bash command string. Destructive
# Bash commands and the direnv trust store are handled by the settings.json deny
# rules plus the OS sandbox; this hook is the one leg those can't cover, because
# the sandbox does not wrap built-in tools (Read/Edit/Write/Grep/Glob use the
# permission system, not the sandbox) and there is no reliable
# Grep(path)/Glob(path) deny form.
#
# Block-only: exit 0 = allow, exit 2 = block. jq missing or malformed input ->
# fail closed. The former destructive-command and direnv-trust Bash checks were
# removed: hooks must not parse Bash (see claude-permissions/invariants.md).

set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
    echo "guard: jq not found on PATH, blocking as a precaution" >&2
    exit 2
fi

INPUT=$(cat)
# jq parse error (malformed input) -> fail CLOSED, symmetric with jq-missing.
if ! FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null); then
    echo "guard: malformed hook input, blocking as a precaution" >&2
    exit 2
fi
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# Read/Write/Edit pass an absolute canonical file_path; Grep/Glob's path can be
# relative (e.g. "secrets") or tilde-prefixed (e.g. "~/.ssh") and often names a
# directory, so normalize before matching. The "~/" branch is quoted so it
# matches the literal characters rather than tilde-expanding the pattern itself.
# shellcheck disable=SC2088
case "$FILE_PATH" in
"~/"*) FILE_PATH="$HOME/${FILE_PATH#\~/}" ;;
/*) : ;;
*) FILE_PATH="$PWD/$FILE_PATH" ;;
esac

# Canonical secret set (kept in sync with the Read(**/…) / Bash(*.env*) deny
# surface in settings.json). Bare-name alternatives (no trailing /*) also block a
# file literally named .git/secrets/etc (e.g. a git worktree's .git file).
case "$FILE_PATH" in
*/.env | */.env.* | */.envrc | *.envrc.*)
    echo "Blocked: access to env/secrets file '$FILE_PATH'." >&2
    exit 2
    ;;
*/secrets | */secrets/* | */.ssh | */.ssh/* | */.aws | */.aws/* | */.config/gh | */.config/gh/* | */.git-credentials)
    echo "Blocked: access to sensitive path '$FILE_PATH'." >&2
    exit 2
    ;;
*/.git | */.git/*)
    echo "Blocked: access to '$FILE_PATH' inside .git." >&2
    exit 2
    ;;
esac

exit 0

#!/bin/bash
# Tests for claude/hooks/commit-alone.sh - the PreToolUse lone-signing-git nudge.
#
# Feeds synthetic tool-call JSON to the REPO copy (not the deployed ~/.claude
# symlink), so uncommitted changes are what gets tested. Payloads are built with
# jq so multi-line and quoted commands encode correctly.
#
# Run directly or via `just test-claude-hooks`. Exits non-zero if any case fails.
# shellcheck disable=SC2016
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="$SCRIPT_DIR/../claude/hooks/commit-alone.sh"
failures=0

# expect <exit-code> <command>
expect() {
    local want="$1" cmd="$2" rc
    jq -n --arg c "$cmd" '{tool_input:{command:$c}}' | "$HOOK" 2>/dev/null
    rc=$?
    if [[ $rc -ne $want ]]; then
        echo "FAIL: exit $rc (want $want): $cmd" >&2
        failures=$((failures + 1))
    fi
}

expect 2 'git add . && git commit -m x'
expect 2 'git commit -m x | tail'
expect 2 'FOO=1 git commit -m x'
expect 2 'git commit -m x 2>&1'
expect 2 'git -C /x commit -m y'
expect 2 'git merge main && just test'
expect 2 $'git add .\ngit commit -m x'
expect 2 'git push -u origin x && gh pr create'
expect 2 'git -C /x fetch'
expect 2 $'git commit -m "$(cat <<\'EOF\'\nmsg\nEOF\n)"'

expect 0 'git commit -m "msg"'
expect 0 'git commit -F "$TMPDIR/msg"'
expect 0 'git merge main'
expect 0 'git log'
expect 0 'git add . && git status'
expect 0 'git push -u origin x'
expect 0 'git stash push -m x && git status'
expect 0 'rg -n "git commit" claude/'
expect 0 'git log --grep "git commit"'
expect 0 $'cat > "$TMPDIR/notes" <<\'EOF\'\ngit add .\ngit commit -m x\nEOF'
expect 2 $'cat > "$TMPDIR/notes" <<\'EOF\'\nx\nEOF\ngit commit -m x'
expect 0 $'cat > "$TMPDIR/notes" <<\\EOF\ngit push\nEOF'

if [[ $failures -gt 0 ]]; then
    echo "$failures commit-alone test(s) failed" >&2
    exit 1
fi
echo "All commit-alone tests passed."

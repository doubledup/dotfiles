#!/bin/bash
# Tests for claude/hooks/guard.sh - the PreToolUse destructive-command guard.
# Feeds synthetic Bash tool-call JSON to the REPO copy of guard.sh (not the
# deployed ~/.claude symlink, so uncommitted changes are what gets tested) and
# asserts the decision: ask (prompt), block (hard deny), or allow (pass).
#
# Run directly or via `just test-guard`. Exits non-zero if any case fails.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD="$SCRIPT_DIR/../claude/hooks/guard.sh"

errfile="$(mktemp)"
trap 'rm -f "$errfile"' EXIT

fails=0

# Build a Bash tool-call JSON payload for COMMAND. $c is a jq variable.
mkinput() {
    # shellcheck disable=SC2016
    jq -cn --arg c "$1" '{tool_name:"Bash",tool_input:{command:$c}}'
}

# check <want> <desc> <command>
#   ask   -> guard exits 0 and prints an "ask" permission decision on stdout
#   block -> guard exits 2 and prints "Blocked:" on stderr
#   allow -> guard exits 0 and prints nothing on stdout
check() {
    local want="$1" desc="$2" cmd="$3"
    local out rc
    out="$(mkinput "$cmd" | "$GUARD" 2>"$errfile")"
    rc=$?
    local err
    err="$(cat "$errfile")"

    local ok=1
    case "$want" in
    ask) [[ $rc -eq 0 && "$out" == *'"permissionDecision":"ask"'* ]] || ok=0 ;;
    block) [[ $rc -eq 2 && "$err" == *"Blocked:"* ]] || ok=0 ;;
    allow) [[ $rc -eq 0 && -z "$out" ]] || ok=0 ;;
    *)
        echo "test bug: unknown expectation '$want'" >&2
        exit 2
        ;;
    esac

    if [[ $ok -eq 1 ]]; then
        printf 'ok   %-5s %s\n' "$want" "$desc"
    else
        printf 'FAIL %-5s %s (rc=%s out=%q err=%q)\n' "$want" "$desc" "$rc" "$out" "$err"
        fails=$((fails + 1))
    fi
}

echo "== ask: destructive commands must prompt =="
check ask "mv a b" "mv a b"
check ask "cp a b" "cp a b"
check ask "rm f" "rm f"
check ask "rsync a b" "rsync a b"
check ask "dd if of" "dd if=a of=b"
check ask "cd && mv" "cd /tmp && mv a b"
check ask "/bin/mv" "/bin/mv a b"
check ask "command mv" "command mv a b"
check ask "subshell (mv)" "(mv a b)"
check ask "brace group" "{ mv a b; }"
check ask "multiline mv" "$(printf 'echo hi\nmv a b')"
check ask "for/do rm loop" "for f in *; do rm \$f; done"
check ask "if/then mv" "if true; then mv a b; fi"
check ask "xargs rm pipe" "ls | xargs rm"
check ask "find -exec rm" "find . -exec rm {} \\;"
check ask "time mv" "time mv a b"
check ask "env rm" "env rm f"
# Separated recursive-force flags are NOT hard-denied (only -rf/-fr are); they
# fall through to ask. Asserted so the accepted gap stays visible.
check ask "rm -r -f (not denied)" "rm -r -f /tmp/x"

echo "== block: hard-denied commands must exit 2 =="
check block "rm -rf" "rm -rf /tmp/x"
check block "rm -fr" "rm -fr /tmp/x"
check block "sudo mv" "sudo mv a b"
check block "mv -> direnv/allow" "mv x /home/u/.local/share/direnv/allow/h"

echo "== allow: non-destructive / argument-position must pass silently =="
check allow "ls -la" "ls -la"
check allow "mvn clean" "mvn clean install"
check allow "git status" "git status"
check allow "fd foo" "fd foo"
check allow "rg mv" "rg mv"
check allow "rg cp src/" "rg cp src/"
check allow "echo cp" "echo cp"
check allow "docker rm" "docker rm ctr"
check allow "grep -rm5" "grep -rm5 x"
check allow "cpio -i" "cpio -i"
check allow "rmdir foo" "rmdir foo"

echo
if [[ $fails -eq 0 ]]; then
    echo "guard.sh: all checks passed"
else
    echo "guard.sh: $fails check(s) failed"
    exit 1
fi

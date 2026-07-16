#!/bin/bash
# Tests for claude/hooks/guard.sh - the PreToolUse destructive-command guard.
# Feeds synthetic Bash tool-call JSON to the REPO copy of guard.sh (not the
# deployed ~/.claude symlink, so uncommitted changes are what gets tested) and
# asserts the decision: block (hard deny) or allow (pass). The guard is
# block-only, so no case expects `ask`; the `ask` branch in check() is kept for
# generality (and to catch a reintroduced hook ask) but is deliberately unused.
#
# Run directly or via `just test-guard`. Exits non-zero if any case fails.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD="$SCRIPT_DIR/../claude/hooks/guard.sh"

# Under the Bash sandbox only cwd + $TMPDIR are writable, but macOS mktemp
# defaults to the confstr temp (/var/folders/.../T) which is outside the
# sandbox. Point it at $TMPDIR explicitly (with a /tmp fallback) so this works
# both sandboxed and when run manually.
errfile="$(mktemp -p "${TMPDIR:-/tmp}")"
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

echo "== allow (hook defers): destructive file cmds pass the hook silently =="
# The guard is block-only now: it no longer asks on mv/cp/rsync/dd/rm. These exit
# 0 so the settings.json ask rules (Bash(rm:*)/Bash(dd:*)/Bash(rsync:*)) and the
# permission classifier decide. Asserted so a reintroduced hook ask is caught.
check allow "rm f" "rm f"
check allow "rsync a b" "rsync a b"
check allow "dd if of" "dd if=a of=b"
check allow "cd && mv" "cd /tmp && mv a b"
check allow "/bin/mv" "/bin/mv a b"
check allow "subshell (mv)" "(mv a b)"
check allow "brace group" "{ mv a b; }"
check allow "multiline mv" "$(printf 'echo hi\nmv a b')"
check allow "for/do rm loop" "for f in *; do rm \$f; done"
check allow "if/then mv" "if true; then mv a b; fi"
check allow "xargs rm pipe" "ls | xargs rm"
check allow "find -exec rm" "find . -exec rm {} \\;"
check allow "env rm" "env rm f"
# Separated recursive-force flags are NOT hard-denied (only -rf/-fr are); they
# fall through to allow (the hook defers; settings.json + classifier decide).
check allow "rm -r -f (not denied)" "rm -r -f /tmp/x"

echo "== block: hard-denied commands must exit 2 =="
check block "rm -rf" "rm -rf /tmp/x"
check block "rm -fr" "rm -fr /tmp/x"
check block "sudo mv" "sudo mv a b"
check block "mv -> direnv/allow" "mv x /home/u/.local/share/direnv/allow/h"

echo "== allow: non-destructive / argument-position must pass silently =="
check allow "mv a b" "mv a b"
check allow "cp a b" "cp a b"
check allow "command mv" "command mv a b"
check allow "time mv" "time mv a b"
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

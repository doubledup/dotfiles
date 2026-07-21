#!/bin/bash
# Tests for claude/hooks/guard.sh - the PreToolUse secret-read guard.
#
# The guard is now path-matching only (it never parses Bash): it blocks
# Read/Write/Edit/Grep/Glob access to secret paths and defers everything else.
# Destructive Bash commands and the direnv trust store are enforced by the
# settings.json deny rules + the OS sandbox, NOT this hook, so they are not
# tested here (a hook harness can only feed tool payloads, and the guard has no
# Bash branch to exercise).
#
# Feeds synthetic tool-call JSON to the REPO copy of guard.sh (not the deployed
# ~/.claude symlink, so uncommitted changes are what gets tested) and asserts the
# decision: block (exit 2, "Blocked:" on stderr) or allow (exit 0, silent).
#
# Run directly or via `just test-guard`. Exits non-zero if any case fails.
#
# The block cases below deliberately feed literal "~/..." strings as test data to
# exercise the guard's tilde normalization; they are payloads, not paths to
# expand, hence the file-level SC2088 disable.
# shellcheck disable=SC2088
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARD="$SCRIPT_DIR/../claude/hooks/guard.sh"

# macOS mktemp defaults to the confstr temp (/var/folders/.../T), outside the
# sandbox; point it at $TMPDIR (with a /tmp fallback) so this works sandboxed
# and when run manually.
errfile="$(mktemp "${TMPDIR:-/tmp}/guardtest.XXXXXX")"
trap 'rm -f "$errfile"' EXIT

fails=0

# Build a tool-call JSON payload. Grep/Glob carry their path in `.path`;
# Read/Write/Edit in `.file_path`. The guard reads `file_path // path`.
mkinput() { # <tool> <path>
    local tool="$1" p="$2" key
    case "$tool" in
    Grep | Glob) key=path ;;
    *) key=file_path ;;
    esac
    # shellcheck disable=SC2016
    jq -cn --arg t "$tool" --arg p "$p" --arg k "$key" '{tool_name:$t,tool_input:{($k):$p}}'
}

# check <want> <desc> <tool> <path>
#   block -> guard exits 2 and prints "Blocked:" on stderr
#   allow -> guard exits 0 and prints nothing on stderr
check() { # <want> <desc> <tool> <path>
    local want="$1" desc="$2" tool="$3" p="$4" rc err ok=1
    mkinput "$tool" "$p" | "$GUARD" >/dev/null 2>"$errfile"
    rc=$?
    err="$(cat "$errfile")"
    case "$want" in
    block) [[ $rc -eq 2 && "$err" == *"Blocked:"* ]] || ok=0 ;;
    allow) [[ $rc -eq 0 && -z "$err" ]] || ok=0 ;;
    *)
        echo "test bug: unknown expectation '$want'" >&2
        exit 2
        ;;
    esac
    if [[ $ok -eq 1 ]]; then
        printf 'ok   %-5s %s\n' "$want" "$desc"
    else
        printf 'FAIL %-5s %s (rc=%s err=%q)\n' "$want" "$desc" "$rc" "$err"
        fails=$((fails + 1))
    fi
}

echo "== block: secret-path reads via built-in tools must exit 2 =="
check block "Grep secrets dir" Grep "secrets"
check block "Grep secrets file" Grep "secrets/prod"
check block "Read dotenv abs" Read "/repo/.env"
check block "Read dotenv variant" Read "/repo/.env.local"
check block "Read envrc" Read "/repo/.envrc"
check block "Read envrc backup" Read "/repo/x.envrc.bak"
check block "Glob ssh dir" Glob "~/.ssh"
check block "Read ssh key" Read "~/.ssh/id_ed25519"
check block "Read aws creds" Read "~/.aws/credentials"
check block "Glob gnupg dir" Glob "~/.gnupg"
check block "Read gnupg key" Read "~/.gnupg/private-keys-v1.d/x.key"
check block "Glob gh config dir" Glob "~/.config/gh"
check block "Read gh hosts" Read "~/.config/gh/hosts.yml"
check block "Read git-credentials" Read "/home/u/.git-credentials"
check block "Grep dotgit dir" Grep ".git"
check block "Read dotgit file" Read "/repo/.git/config"
check block "Grep relative dotenv" Grep "./.env"

echo "== allow: non-secret paths and no-path must pass silently =="
check allow "Read source" Read "/repo/src/init.lua"
check allow "Read readme" Read "/repo/README.md"
check allow "Grep src dir" Grep "src"
check allow "Read non-secret dotfile" Read "/repo/.gitignore"
check allow "Read env-lookalike" Read "/repo/environment.md"
check allow "empty path" Grep ""

echo "== fail closed: malformed input must block =="
printf 'not json' | "$GUARD" >/dev/null 2>"$errfile"
rc=$?
if [[ $rc -eq 2 ]]; then
    printf 'ok   %-5s %s\n' block "malformed input"
else
    printf 'FAIL %-5s %s (rc=%s)\n' block "malformed input" "$rc"
    fails=$((fails + 1))
fi

echo
if [[ $fails -eq 0 ]]; then
    echo "guard.sh: all checks passed"
else
    echo "guard.sh: $fails check(s) failed"
    exit 1
fi

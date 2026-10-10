#!/usr/bin/env bash
set -uo pipefail

# PreToolUse hook: block a signing git command that is not a lone Bash call.
# `git commit|merge|rebase|cherry-pick|revert *` are sandbox excludedCommands so
# GPG can reach ~/.gnupg, but the exclusion applies only when the whole call
# matches. Chained, piped, redirected, env-prefixed or `-C` forms run sandboxed
# and signing fails. Advisory, not a security leg: fails open on any parse error.

command -v jq >/dev/null 2>&1 || exit 0
cmd="$(jq -r '.tool_input.command // empty' 2>/dev/null)" || exit 0
[[ -n "$cmd" ]] || exit 0

verbs='(commit|merge|rebase|cherry-pick|revert)'
nl=$'\n'
# git <verb> in command position: start, after a separator, or after VAR=val.
# shellcheck disable=SC2016
invoked='(^|[;&|(`'"$nl"']|\$\()[[:space:]]*([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+'"$verbs"'([[:space:]]|$)'
[[ "$cmd" =~ $invoked ]] || exit 0

lone='^git[[:space:]]+'"$verbs"'([[:space:]]|$)'
# shellcheck disable=SC2016
if [[ "$cmd" =~ $lone ]] && [[ "$cmd" != *'&&'* && "$cmd" != *'||'* && "$cmd" != *';'* &&
    "$cmd" != *'|'* && "$cmd" != *"$nl"* && "$cmd" != *'>'* && "$cmd" != *'<'* &&
    "$cmd" != *'`'* && "$cmd" != *'$('* ]]; then
    exit 0
fi

cat >&2 <<'EOF'
Run this git command as its own Bash call: no chaining, pipes, redirects, env
prefix or `-C` (cd first in a separate call). Only a lone call matches the sandbox
excludedCommands entry, and GPG signing needs it. For a multi-line commit message,
write it to a file under $TMPDIR and use `git commit -F <file>`.
EOF
exit 2

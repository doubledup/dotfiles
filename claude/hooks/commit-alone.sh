#!/usr/bin/env bash
set -uo pipefail

# PreToolUse hook: block an excluded git command that is not a lone Bash call.
# `git commit|merge|rebase|cherry-pick|revert *` are sandbox excludedCommands so
# GPG can reach ~/.gnupg, `git fetch|pull|push *` so SSH remotes work, and
# `git worktree remove|prune *` and `git branch -d|-D *` so they can delete the
# .claude/settings.json, .git/worktrees and .git/config entries the sandbox
# protects, but
# the exclusion applies only when the whole call matches. Chained, piped,
# redirected, env-prefixed or `-C` forms run sandboxed and fail. Advisory, not a
# security leg: fails open on any parse error.

command -v jq >/dev/null 2>&1 || exit 0
cmd="$(jq -r '.tool_input.command // empty' 2>/dev/null)" || exit 0
[[ -n "$cmd" ]] || exit 0

verbs='(commit|merge|rebase|cherry-pick|revert|fetch|pull|push|worktree[[:space:]]+(remove|prune)|branch[[:space:]]+-[dD])'
nl=$'\n'
# Drop heredoc bodies, so a file written with `cat <<EOF` that only mentions a
# verb is not taken for a call. A body fed to a shell is commands, so keep it.
heredoc='(^|[^<])<<-?[[:space:]]*["'\''\]?([A-Za-z_][A-Za-z0-9_]*)'
toshell='(^|[[:space:];&|(/])(bash|sh|zsh|fish)([[:space:]]|$)'
scan='' delim=''
while IFS= read -r line; do
    if [[ -n "$delim" ]]; then
        [[ "${line#"${line%%[![:space:]]*}"}" == "$delim" ]] && delim=''
        continue
    fi
    scan+="$line$nl"
    [[ "$line" =~ $toshell ]] && continue
    [[ "$line" =~ $heredoc ]] && delim="${BASH_REMATCH[2]}"
done <<<"$cmd"
# git <verb> in command position: start, after a separator, or after VAR=val.
# shellcheck disable=SC2016
invoked='(^|[;&|(`'"$nl"']|\$\()[[:space:]]*([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+'"$verbs"'([[:space:]]|$)'
[[ "$scan" =~ $invoked ]] || exit 0

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
excludedCommands entry, which GPG signing and SSH remotes need. For a multi-line
commit message, write it to a file under $TMPDIR and use `git commit -F <file>`.
EOF
exit 2

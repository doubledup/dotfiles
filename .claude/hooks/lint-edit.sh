#!/usr/bin/env bash
set -uo pipefail

# PostToolUse hook: lint the file Claude just edited and feed failures back (exit 2), so a broken
# shell or fish file is fixed in the same turn instead of at commit. Fails open: no jq, no path, or
# a file type it doesn't lint exits 0. The pre-commit hook still runs the full `just check`.

command -v jq >/dev/null 2>&1 || exit 0
path="$(jq -r '.tool_input.file_path // empty' 2>/dev/null)" || exit 0
[[ -f "$path" ]] || exit 0

case "$path" in
*.fish) lint=(fish --no-execute) ;;
*.sh) lint=(shellcheck) ;;
*/scripts/* | */.githooks/*)
    [[ -n "$(shfmt -f "$path" 2>/dev/null)" ]] || exit 0
    lint=(shellcheck)
    ;;
*) exit 0 ;;
esac

out="$("${lint[@]}" "$path" 2>&1)" && exit 0
printf '%s\n' "$out" >&2
exit 2

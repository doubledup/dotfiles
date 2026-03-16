#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook: auto-approve read-only gh api calls to GitHub Actions endpoints.
# All other gh api usage falls through to the normal permission prompt.

# Require jq; if missing, fall through to prompt
command -v jq >/dev/null 2>&1 || exit 0

# Read stdin (hook input JSON) and extract the command
input="$(cat)"
cmd="$(echo "$input" | jq -r '.tool_input.command // empty')"

# Not a gh api command → fall through
[[ "$cmd" == *"gh api"* ]] || exit 0

# Reject embedded newlines (command separators)
if [[ "$cmd" == *$'\n'* ]]; then
    exit 0
fi

# Reject command chaining operators
if [[ "$cmd" == *'&&'* ]] || [[ "$cmd" == *'||'* ]] || [[ "$cmd" == *';'* ]] || [[ "$cmd" == *'$('* ]] || [[ "$cmd" == *'`'* ]]; then
    exit 0
fi

# Token-aware mutating flag check: split into words and check for exact matches
read -ra tokens <<<"$cmd"
for token in "${tokens[@]}"; do
    case "$token" in
    -X | --method | -f | --field | --raw-field | --input)
        exit 0
        ;;
    esac
done

# Find the API path: the first token after "gh api" that doesn't start with -
api_path=""
found_gh=false
found_api=false
for token in "${tokens[@]}"; do
    if [[ "$found_api" == true ]]; then
        if [[ "$token" == -* ]]; then
            continue
        fi
        api_path="$token"
        break
    fi
    if [[ "$found_gh" == true ]] && [[ "$token" == "api" ]]; then
        found_api=true
        continue
    fi
    if [[ "$token" == "gh" ]]; then
        found_gh=true
    else
        found_gh=false
    fi
done

# Must have found a path
[[ -n "$api_path" ]] || exit 0

# Strip leading slash and query params
api_path="${api_path#/}"
api_path="${api_path%%\?*}"

# Validate API path against allowed patterns (actions endpoints only)
allowed=false
if [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/jobs/[^/]+/logs$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/runs/[^/]+/logs$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/runs/[^/]+/jobs$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/runs/[^/]+$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/runs$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/workflows/[^/]+/runs$ ]]; then
    allowed=true
elif [[ "$api_path" =~ ^repos/[^/]+/[^/]+/actions/workflows$ ]]; then
    allowed=true
fi

[[ "$allowed" == true ]] || exit 0

# Strip redirections before pipe analysis (2>&1, 2>/dev/null, >/dev/null, etc.)
sanitized="$cmd"
# Remove fd redirections like 2>&1, 1>&2
sanitized="$(echo "$sanitized" | sed -E 's/[0-9]*>&?[0-9]+//g')"
# Remove redirections to /dev/null (with optional space)
sanitized="$(echo "$sanitized" | sed -E 's/[0-9]*>\s*\/dev\/null//g')"

# Validate pipe targets if piped
if [[ "$sanitized" == *"|"* ]]; then
    # Split on pipes, skip the first segment (the gh api command itself)
    IFS='|' read -ra segments <<<"$sanitized"
    for ((i = 1; i < ${#segments[@]}; i++)); do
        segment="${segments[$i]}"
        # Trim leading/trailing whitespace
        segment="$(echo "$segment" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
        # Get first token (the command)
        first_token="${segment%% *}"
        case "$first_token" in
        grep | head | tail | wc | uniq | cut | jq | cat | tr) ;; # safe
        *)
            exit 0 # unsafe or unknown → fall through to prompt
            ;;
        esac
    done
fi

# All checks passed — auto-approve
echo '{"permissionDecision":"allow"}'

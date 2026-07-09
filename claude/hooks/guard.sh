#!/bin/bash
# PreToolUse guard hook: blocks destructive commands and secrets access.
# Exit 0 = allow, Exit 2 = block with feedback.

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
    echo "guard: jq not found on PATH, blocking as a precaution" >&2
    exit 2
fi

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty')

block() {
    echo "$1" >&2
    exit 2
}

case "$TOOL_NAME" in
Bash)
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty')

    # Block sudo
    if [[ "$COMMAND" =~ (^|[;&|])\ *sudo\  ]]; then
        block "Blocked: sudo is not allowed."
    fi

    # Block rm -rf
    if [[ "$COMMAND" =~ (^|[;&|])\ *rm\ +-[a-zA-Z]*r[a-zA-Z]*f|rm\ +-[a-zA-Z]*f[a-zA-Z]*r ]]; then
        block "Blocked: rm -rf is not allowed."
    fi

    # Tolerate common git global options appearing between `git` and the
    # subcommand in the blocklist checks below (e.g. `git -C <path> push`).
    # Not exhaustive - covers the realistic/common cases: -C <path>,
    # -c <key=val>, --git-dir=<path>, --work-tree=<path>, --namespace=<path>,
    # --no-pager, --paginate, -p, --bare.
    # Known gap: a global-option value containing shell-quoted spaces (e.g.
    # `-c "user.name=John Doe" push`) is not matched, since each alternative
    # below only spans a single whitespace-delimited token - this lets the
    # push/reset --hard/checkout ./restore ./clean check that follows it
    # silently not fire.
    GIT_GLOBAL_OPT='(-C [^ ]+|-c [^ ]+|--git-dir=[^ ]+|--work-tree=[^ ]+|--namespace=[^ ]+|--no-pager|--paginate|-p|--bare)'

    # Block all git push (pushing is user-only); covers force pushes too.
    # Anchored to command boundaries like the sudo/rm rules to avoid substring
    # false positives (e.g. rg "git push", git commit -m "...git push...").
    if [[ "$COMMAND" =~ (^|[;&|])\ *git(\ +$GIT_GLOBAL_OPT)*\ +push(\ |$) ]]; then
        block "Blocked: pushing is user-only. Run the push yourself."
    fi
    if [[ "$COMMAND" =~ git(\ +$GIT_GLOBAL_OPT)*\ reset\ --hard ]]; then
        block "Blocked: git reset --hard is not allowed."
    fi
    # Match "git checkout ." and "git checkout -- ." but not "git checkout .gitignore"
    if [[ "$COMMAND" =~ git(\ +$GIT_GLOBAL_OPT)*\ checkout\ (--\ )?\.(\ |$) ]]; then
        block "Blocked: git checkout . is not allowed."
    fi
    if [[ "$COMMAND" =~ git(\ +$GIT_GLOBAL_OPT)*\ restore\ (--\ )?\.(\ |$) ]]; then
        block "Blocked: git restore . is not allowed."
    fi
    if [[ "$COMMAND" =~ git(\ +$GIT_GLOBAL_OPT)*\ clean(\ |$) ]]; then
        block "Blocked: git clean is not allowed."
    fi

    # Block writes to direnv's trust-hash store (~/.local/share/direnv/allow/
    # by default, or $XDG_DATA_HOME/direnv/allow). Forging a hash there grants
    # trust to an .envrc without going through the denied direnv
    # allow/permit/grant/edit commands. Requires the write token and the path
    # to appear in the same clause (no ;&| between them) - otherwise an
    # unrelated redirect elsewhere in a compound command (e.g. `cat
    # .../direnv/allow/hash 2>/dev/null`) would falsely trip this.
    if [[ "$COMMAND" =~ \>[^\;\&\|]*direnv/allow ]] ||
        [[ "$COMMAND" =~ (^|[\;\&\|])[[:space:]]*(cp|mv|touch|tee|dd|rsync)[[:space:]]+[^\;\&\|]*direnv/allow ]]; then
        block "Blocked: writing to direnv's allow/ trust store is not allowed."
    fi
    ;;

Read | Write | Edit)
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty')

    if [[ -z "$FILE_PATH" ]]; then
        exit 0
    fi

    # Block secrets paths
    case "$FILE_PATH" in
    */.env | */.env.* | */.envrc | */.envrc.*)
        block "Blocked: access to env/secrets file '$FILE_PATH'."
        ;;
    */secrets/* | */.ssh/* | */.aws/*)
        block "Blocked: access to sensitive path '$FILE_PATH'."
        ;;
    */.git/*)
        block "Blocked: access to '$FILE_PATH' inside .git."
        ;;
    esac
    ;;
esac

exit 0

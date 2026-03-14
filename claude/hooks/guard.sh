#!/bin/bash
# PreToolUse guard hook: blocks destructive commands and secrets access.
# Exit 0 = allow, Exit 2 = block with feedback.

set -euo pipefail

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

    # Block destructive git commands
    # Match --force and -f but not --force-with-lease (which is safe)
    if [[ "$COMMAND" =~ git\ push\ .*(\ -f\ |\ -f$|\ --force\ |\ --force$) ]]; then
        block "Blocked: git push --force is not allowed."
    fi
    if [[ "$COMMAND" =~ git\ reset\ --hard ]]; then
        block "Blocked: git reset --hard is not allowed."
    fi
    # Match "git checkout ." and "git checkout -- ." but not "git checkout .gitignore"
    if [[ "$COMMAND" =~ git\ checkout\ (--\ )?\.(\ |$) ]]; then
        block "Blocked: git checkout . is not allowed."
    fi
    if [[ "$COMMAND" =~ git\ restore\ (--\ )?\.(\ |$) ]]; then
        block "Blocked: git restore . is not allowed."
    fi
    if [[ "$COMMAND" =~ git\ clean(\ |$) ]]; then
        block "Blocked: git clean is not allowed."
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
    esac
    ;;
esac

exit 0

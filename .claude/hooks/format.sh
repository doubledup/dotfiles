#!/bin/bash
# Auto-format after Edit/Write tool use.
# Runs `just fmt` from the project root to format all files.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
    exit 0
fi

# Only format file types that have formatters
case "$FILE_PATH" in
*.lua | *.fish | *.sh | *.bash | *.json | *.md) ;;
*) exit 0 ;;
esac

cd "$CLAUDE_PROJECT_DIR"
just fmt || true

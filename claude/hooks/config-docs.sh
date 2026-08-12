#!/bin/bash
# PreToolUse advisory hook: when editing structured Claude Code config, point at
# the reference for the schema being edited.
#
# Why: Claude Code's config surface is large and version-gated, and a stale
# assumption about it fails silently. Listing `Skill` under an agent's `tools`
# instead of using the `skills` frontmatter field produced a working agent that
# passed `just check` and was simply the worse mechanism; nothing automated
# would have caught it. Validation can't help, because both forms are valid.
#
# Advisory only: always exits 0 and never blocks. Matches on structured config
# (settings.json, agents, skills, commands, hooks, .mcp.json) and skips prose
# like rules/ and CLAUDE.md, which have no schema to get wrong. Path-matching
# only; it never parses a Bash command string.

set -uo pipefail

# Advisory hook: a missing jq or malformed input must not interfere with the
# edit. Fail OPEN, the opposite of guard.sh, which is a security control.
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0
[[ -n "$FILE_PATH" ]] || exit 0

# shellcheck disable=SC2088
case "$FILE_PATH" in
"~/"*) FILE_PATH="$HOME/${FILE_PATH#\~/}" ;;
/*) : ;;
*) FILE_PATH="$PWD/$FILE_PATH" ;;
esac

# Only fire inside a Claude config tree: the rcm-managed ~/.dotfiles/claude, the
# deployed ~/.claude, or any project-scope .claude directory.
case "$FILE_PATH" in
"$HOME"/.dotfiles/claude/* | "$HOME"/.claude/* | */.claude/*) : ;;
*) exit 0 ;;
esac

DOCS="https://code.claude.com/docs/en"
case "$FILE_PATH" in
*/settings.json | */settings.local.json)
    TOPIC="a settings file"
    REF="$DOCS/settings"
    ;;
*/agents/*.md)
    TOPIC="a subagent definition"
    REF="$DOCS/sub-agents#supported-frontmatter-fields"
    ;;
*/skills/*/SKILL.md | */commands/*.md)
    TOPIC="a skill or command definition"
    REF="$DOCS/skills#frontmatter-reference"
    ;;
*/hooks/*)
    TOPIC="a hook script"
    REF="$DOCS/hooks"
    ;;
*/.mcp.json)
    TOPIC="an MCP server config"
    REF="$DOCS/mcp"
    ;;
*) exit 0 ;;
esac

jq -n --arg topic "$TOPIC" --arg ref "$REF" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    additionalContext: (
      "You are editing \($topic). Claude Code config is version-gated and changes
often, so verify the fields you are about to write against \($ref) rather than
from memory. A wrong-but-valid field choice here fails silently: it passes
`just check`, produces working config, and is simply the worse mechanism."
    )
  }
}'

exit 0

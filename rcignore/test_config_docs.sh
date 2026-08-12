#!/bin/bash
# Tests for claude/hooks/config-docs.sh - the PreToolUse config-docs advisory.
#
# The hook is advisory: it must ALWAYS exit 0 and never block an edit. It emits
# hookSpecificOutput.additionalContext naming a doc reference when the edited
# path is structured Claude Code config, and stays silent otherwise.
#
# Feeds synthetic tool-call JSON to the REPO copy (not the deployed ~/.claude
# symlink), so uncommitted changes are what gets tested. The failure this guards
# against is self-similar to the one the hook exists to prevent: if the path
# cases break, the hook silently stops firing and nothing else notices.
#
# Run directly or via `just test-claude-hooks`. Exits non-zero if any case fails.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="$SCRIPT_DIR/../claude/hooks/config-docs.sh"
failures=0

# fires <path> <expected-substring-of-ref>
fires() {
    local path="$1" want="$2" out rc
    out=$(printf '{"tool_input":{"file_path":"%s"}}' "$path" | "$HOOK")
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "FAIL: $path exited $rc, advisory hook must always exit 0" >&2
        failures=$((failures + 1))
        return
    fi
    if ! printf '%s' "$out" | grep -q "$want"; then
        echo "FAIL: $path did not reference '$want'" >&2
        failures=$((failures + 1))
    fi
}

# silent <path>
silent() {
    local path="$1" out rc
    out=$(printf '{"tool_input":{"file_path":"%s"}}' "$path" | "$HOOK")
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "FAIL: $path exited $rc, advisory hook must always exit 0" >&2
        failures=$((failures + 1))
        return
    fi
    if [[ -n "$out" ]]; then
        echo "FAIL: $path should be silent, got: $out" >&2
        failures=$((failures + 1))
    fi
}

# Structured config gets the matching reference.
fires "$HOME/.dotfiles/claude/settings.json" "docs/en/settings"
fires "$HOME/.dotfiles/claude/agents/reviewer.md" "docs/en/sub-agents"
fires "$HOME/.dotfiles/claude/skills/ponytail/SKILL.md" "docs/en/skills"
fires "$HOME/.dotfiles/claude/commands/feature.md" "docs/en/skills"
fires "$HOME/.dotfiles/claude/hooks/guard.sh" "docs/en/hooks"
fires "$HOME/.claude/settings.local.json" "docs/en/settings"
fires "/some/repo/.claude/agents/x.md" "docs/en/sub-agents"

# Prose has no schema to get wrong; source files are none of its business.
silent "$HOME/.dotfiles/claude/rules/planning.md"
silent "$HOME/.dotfiles/claude/CLAUDE.md"
silent "$HOME/.dotfiles/DESIGN.md"
silent "/some/repo/src/main.rs"
silent "/some/repo/settings.json"

# Advisory hooks fail OPEN: bad input must not interfere with the edit.
for payload in 'not json' '{}' '{"tool_input":{"command":"rm -rf ~/.zshrc"}}'; do
    out=$(printf '%s' "$payload" | "$HOOK")
    rc=$?
    if [[ $rc -ne 0 || -n "$out" ]]; then
        echo "FAIL: payload '$payload' should fail open silently, got rc=$rc out=$out" >&2
        failures=$((failures + 1))
    fi
done

if [[ $failures -gt 0 ]]; then
    echo "config-docs.sh: $failures check(s) failed" >&2
    exit 1
fi
echo "config-docs.sh: all checks passed"

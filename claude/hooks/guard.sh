#!/bin/bash
# PreToolUse guard hook: blocks destructive commands and secrets access.
# Exit 0 = allow, Exit 2 = block with feedback. Block-only by design: it never
# emits an "ask". Dual-use file commands (mv/cp/rsync/dd/rm) are deliberately
# left to the settings.json ask rules and Claude Code's permission classifier,
# so do not reintroduce an ask() path here.

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
    #
    # cp/mv/rsync only block when direnv/allow is the LAST token in the
    # clause (their common destination position) - reading the store as a
    # source, e.g. `cp .../direnv/allow/hash /tmp/backup`, is not a write and
    # stays allowed. dd has no positional destination; it blocks specifically
    # on the `of=` parameter instead. tee/touch have no "source" mode - every
    # argument to them is a write target - so they still match anywhere in
    # the clause.
    if [[ "$COMMAND" =~ \>[^\;\&\|]*direnv/allow ]] ||
        [[ "$COMMAND" =~ (^|[\;\&\|])[[:space:]]*(touch|tee)[[:space:]]+[^\;\&\|]*direnv/allow ]] ||
        [[ "$COMMAND" =~ (^|[\;\&\|])[[:space:]]*(cp|mv|rsync)[[:space:]]+[^\;\&\|]*direnv/allow[^\;\&\|[:space:]]*[[:space:]]*($|[\;\&\|]) ]] ||
        [[ "$COMMAND" =~ (^|[\;\&\|])[[:space:]]*dd[[:space:]]+[^\;\&\|]*of=[^\;\&\|[:space:]]*direnv/allow ]]; then
        block "Blocked: writing to direnv's allow/ trust store is not allowed."
    fi
    ;;

Read | Write | Edit | Grep | Glob)
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // empty')

    if [[ -z "$FILE_PATH" ]]; then
        exit 0
    fi

    # Read/Write/Edit always receive an absolute, canonicalized file_path.
    # Grep/Glob's path can be relative (e.g. "secrets") or tilde-prefixed
    # (e.g. "~/.ssh") and commonly names a directory with no trailing
    # content, so normalize before matching the patterns below. The tilde
    # branch pattern is quoted ("~/"*) so it matches the literal characters
    # "~/" instead of being tilde-expanded itself (an unquoted ~/* pattern
    # expands to $HOME/* and never matches a literal "~/..." string).
    # shellcheck disable=SC2088 # intentional: quoting the "~/" case pattern
    # below keeps it a literal match against $FILE_PATH's contents, not a
    # tilde expansion.
    case "$FILE_PATH" in
    "~/"*) FILE_PATH="$HOME/${FILE_PATH#\~/}" ;;
    /*) : ;;
    *) FILE_PATH="$PWD/$FILE_PATH" ;;
    esac

    # Block secrets paths. The bare-directory alternatives below (no
    # trailing /*) also broaden the Read/Write/Edit leg slightly: a file
    # literally named secrets, .ssh, .aws, or .git (e.g. a git
    # submodule/worktree .git file, which is a regular file) is now blocked
    # too, not just directories of those names. Intentional defense-in-depth,
    # not a regression.
    case "$FILE_PATH" in
    */.env | */.env.* | */.envrc | */.envrc.*)
        block "Blocked: access to env/secrets file '$FILE_PATH'."
        ;;
    */secrets | */secrets/* | */.ssh | */.ssh/* | */.aws | */.aws/*)
        block "Blocked: access to sensitive path '$FILE_PATH'."
        ;;
    */.git | */.git/*)
        block "Blocked: access to '$FILE_PATH' inside .git."
        ;;
    esac
    ;;
esac

exit 0

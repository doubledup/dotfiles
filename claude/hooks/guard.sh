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

# Emit a PreToolUse "ask" decision (prompt the user to confirm) and exit.
ask() {
    # shellcheck disable=SC2016  # $r is a jq variable, not shell expansion
    jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
    exit 0
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

    # Require confirmation for destructive file mutations (mv/cp/rsync/dd/rm):
    # they can irreversibly overwrite or delete files, so return an "ask"
    # decision to force per-command approval. Belt-and-suspenders with the
    # Bash(mv:*)/... ask rules in settings.json - this also fires on prefixed
    # forms (/bin/mv, command mv) and loop/pipeline/wrapper forms the rule
    # matcher can miss. The hard blocks above (sudo, rm -rf, direnv) run first
    # and take precedence, so those never downgrade to a mere ask. Newlines are
    # normalized to ; so a command on its own line still matches. LEAD is the
    # set of keywords/wrappers that can precede the command in destructive
    # position, so loop and pipeline deletes (`for f in *; do rm $f; done`,
    # `ls | xargs rm`, `find . -exec rm {} \;`) still ask. A plain space is
    # intentionally NOT a boundary, so `rg mv`, `fd cp`, `docker rm`, `git rm`
    # (destructive word as another tool's argument) stay silent. The trailing
    # ([[:space:]]|$) avoids false positives on mvn/cpio/ddrescue/rmdir.
    # Accepted gaps (ask-only backstop; the ask rule and default-mode plan
    # gating are the paired defenses): a wrapper carrying flags (`timeout 5 rm`,
    # `xargs -n1 rm`), an env-assignment prefix (`FOO=bar rm x`), a relative or
    # home-dir path (`./mv`, `~/bin/mv` - only absolute /paths are matched),
    # command substitution / `bash -c "..."`, and a command or path built via a
    # variable or eval (`M=mv; $M a b`). Conversely, a boundary char inside a
    # quoted string (`git commit -m "note (rm x)"`) yields a harmless extra ask,
    # never a wrongful block - the miss direction is always fail-safe.
    LEAD='(do|then|else|elif|time|env|nice|sudo|command|nohup|stdbuf|timeout|watch|xargs)'
    NORM="${COMMAND//$'\n'/;}"
    if [[ "$NORM" =~ (^|[;&|(){}]|[[:space:]]-exec(dir)?)[[:space:]]*(${LEAD}[[:space:]]+)*(/[^[:space:]]*/)?(cp|mv|rsync|dd|rm)([[:space:]]|$) ]]; then
        ask "Confirm destructive file command (mv/cp/rsync/dd/rm): $COMMAND"
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

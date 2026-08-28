# Design

Architectural decisions and design philosophy for this dotfiles repository.

## Development Philosophy

Core principles that guide all decisions in this repository:

**Simplicity over cleverness:**

- Aim for narrow interfaces with deep implementations
- Prefer simple, clear code over complex abstractions, even if the code is more verbose
- Minimize configuration - use defaults wherever possible
- Lower complexity even if initially more difficult or verbose

**Conservative tool choices:**

- Prefer well-tested tools with larger communities and longer track records
- Avoid introducing new tools/languages unless necessary
- Favor terminal/CLI programs over GUI applications

**Keyboard-first workflow:**

- Prioritize keyboard shortcuts and terminal workflows
- Avoid mouse-dependent tools and interfaces

**When evaluating new additions:**

1. Can existing tools handle this?
2. Does this add unnecessary complexity?
3. Is this tool mature and widely adopted?
4. Will this work in a terminal/CLI environment?

## Design Decisions

Key technical choices and their rationale:

**rcm for dotfile management:**

- Mature tool from thoughtbot with 10+ years of development
- Simple symlink-based approach without magic or complex abstractions
- Built-in support for OS-specific configurations via tags
- No Ruby/Python/complex dependencies - just shell scripts
- Alternative considered: GNU Stow (rejected: less flexible tag system)

**Fish shell:**

- User-friendly defaults (autosuggestions, syntax highlighting) without configuration
- Clean, readable syntax for scripting
- Fast startup time
- Strong community and active development
- Trade-off accepted: Not POSIX-compliant, but this dotfiles repo doesn't need POSIX portability

**Neovim with lazy.nvim:**

- Neovim: Modern, actively developed Vim fork with Lua API and LSP support
- lazy.nvim: Fast, minimal plugin manager with good lazy-loading
- Pure Lua configuration: Better performance and integration than vimscript
- Multiple configs (main/kickstart/golf): Learn different approaches without commitment

**Plugin versioning (lazy.nvim):**

- Default to tracking each repo's default branch (no `version` constraint in lazy.nvim specs)
- Only pin when the plugin's own docs explicitly recommend it
- lazy.nvim's docs warn against blanket pinning because many plugins have stale releases
- Changelog review during updates and test_plugins.lua catch breaks regardless of pinning strategy

**Homebrew for CLI tools, Mason for editor plumbing:**

- Formatters and linters go in Brewfile: useful outside editors (pre-commit hooks, CI, shell)
- LSP and DAP servers go in Mason: editor-specific, Mason handles wiring to neovim
- Exception: Rust tools (rust-analyzer, clippy, rustfmt) come from rustup, not Mason or Homebrew.
  They are toolchain components, version-matched to the active compiler and respect per-project
  rust-toolchain.toml
- Avoids duplicate installs and version mismatches between Homebrew and Mason

**BACKLOG.md for work tracking:**

- Git-tracked markdown file organised by effort/impact (fixes > low-hanging fruit > high impact >
  other > new tools)
- Complements Claude Code's built-in Tasks (session-level) and Memory (preferences/decisions)
- Split into `backlog/` directory if the file grows past ~100 items
- Alternative considered: GitHub Issues (requires network, splits context), Beads (requires Dolt
  server, alpha stability), split directory (premature before knowing the right split)

**just for task running:**

- Simpler syntax than make (no tabs, clear command syntax)
- Better error messages and user experience
- Cross-platform by design
- Focused on running commands, not building software (better fit than make)

**Kitty and Ghostty terminals:**

- Both GPU-accelerated for performance
- Modern feature sets (ligatures, images, extensive customization)
- Kitty: Mature, well-established
- Ghostty: Newer, native macOS performance
- Both support keyboard-driven workflows

**Kitty option reference generated on demand:**

- `kitty.conf` holds only the settings this machine actually changes, plus the marker blocks kitty
  rewrites itself (`BEGIN_KITTY_FONTS`, `BEGIN_KITTY_THEME`)
- Browse the full option list with `just kitty-defaults`, which pipes the installed kitty's own
  default config into nvim (read-only, kitty syntax, folded by section)
- Alternative considered: keeping kitty's commented-out defaults interleaved in `kitty.conf`
  (rejected: stale by construction, the file drifted a whole release behind and hid 39 new options);
  vendoring a generated default file (rejected: repo churn on every kitty upgrade, and it needs a
  `typos` exclude for an upstream typo)
- Accepted cost: no local baseline, so "what changed since the last kitty version" comes from the
  changelog (`ctrl+shift+f1`) rather than a `git diff`

**Notification auto-dismiss on focus (kitty watcher):**

- kitty's `notify_on_cmd_finish ... focus` clears only its own cmd-finished notifications on
  refocus; notifications from other apps (e.g. Claude Code's OSC 99 "waiting for input") lingered in
  Notification Center in kitty but not Ghostty
- `config/kitty/close-notifications-on-focus.py`, loaded via `watcher` in `kitty.conf`, closes every
  live notification whose sending window just regained focus, regardless of sender, by iterating
  `NotificationManager.in_progress_notification_commands` and matching `channel_id`
- Alternatives considered: kitty's `notifications.py` filtering hook (rejected: fires at creation
  time, has nothing to close); a launchd agent polling frontmost-app (rejected: its own permissions
  and process lifecycle for a problem kitty's watcher solves in-process); waiting for an upstream
  option (rejected: none as of 0.48.2)
- Accepted risk: it reaches into internals kitty's docs call undocumented/unstable. `just test`'s
  `kitty +runpy` contract check turns a rename into a loud failure, and kitty catches watcher
  exceptions, so the worst runtime case is a regression to lingering notifications, not breakage
- Accepted cost: macOS kitty gets no notification-close events, so the watcher re-issues harmless
  no-op closes for already-gone entries. Watchers bind only to windows created after a config
  reload, and script edits need a full kitty restart (module cache)

**Config-docs advisory hook:**

- `claude/hooks/config-docs.sh` fires on `Write|Edit` and, for structured Claude Code config paths
  (settings, agents, skills/commands, hooks, `.mcp.json`), injects the matching `code.claude.com`
  reference via `hookSpecificOutput.additionalContext` (listed in the docs' universal hook-output
  table, though not demonstrated for PreToolUse there; works today)
- Targets a silent-and-valid failure: `Skill` under an agent's `tools` instead of the `skills`
  frontmatter field passed `just check` and was simply the worse mechanism; a model's knowledge of
  the large, version-gated config surface goes stale by construction
- First hook admitted under the context-injection category rather than enforcement (see the
  claude-permissions entry below). Always exits 0 and fails **open**, the opposite of `guard.sh`;
  kept a separate script so an advisory bug can never block an edit. Skips `rules/` and `CLAUDE.md`
  (prose has no schema to get wrong)
- Alternatives considered: a skill (rejected: model-invoked, so it fails exactly when carelessness
  is the problem); a blocking hook (rejected: needs per-session state for a reminder that works when
  merely offered)
- Accepted limit: it guarantees the pointer is delivered, not that it is followed

**gh-api-readonly hook:**

- `claude/hooks/gh-api-readonly.sh` (PreToolUse on Bash) auto-approves read-only `gh api` calls to
  GitHub Actions endpoints, cutting prompt noise during CI triage
- It parses the Bash command string, which the enforcement-hook rule forbids; acceptable here
  because it is allow-only and fails open: any parse failure or rejected pattern falls through to
  the normal permission prompt, so the failure mode is a prompt, not a bypass
- Accepted gaps: no `timeout` in settings.json and no test harness, unlike the other two hooks
  (backlog)

**Ponytail vendored as a skill, not installed as a plugin:**

- Ponytail is a minimalism ruleset ("the best code is the code you never wrote") whose entire value
  is one 6.6 KB markdown file. `claude/skills/ponytail/SKILL.md` is a verbatim copy; provenance, the
  MIT notice, and the byte-identical vendoring mechanics (prettierignore and non-ASCII exceptions,
  manual `just ponytail-diff` updates) live in `VENDOR.md` beside it
- The upstream plugin wraps that file in three Node lifecycle hooks that only inject the file, write
  a mode flag, and parse `/ponytail`; the `skills/` mechanism covers the first two, and the third is
  near-worthless (the vendored copy keeps the intensity table in full)
- Alternatives considered: installing the plugin (rejected: three third-party Node scripts with full
  user privileges on every session start, prompt submit, and subagent spawn - hooks are gated by
  neither `permissions`, `guard.sh`, nor the sandbox - the largest trust-boundary widening available
  here for the smallest benefit); putting the ruleset in `claude/CLAUDE.md` (rejected: ~1.4k tokens
  on every session, coding or not); pinning the marketplace to a tag (rejected with the plugin;
  upstream tags trailed `main` by 53 commits when evaluated, worse than tracking the branch)
- Accepted tradeoff: a skill is model-invoked rather than injected every session; its frontmatter
  description fires it on any coding task, preferable to a per-session tax
- Deliberately no `just test` contract check, unlike the kitty watcher: the failure mode here is
  upstream text drift, which needs a human reading a diff, and a network fetch in the test suite
  would fail it on a GitHub rate limit

**File organization patterns:**

- `.local` files: Machine-specific overrides without polluting version control
- `.os` files: OS-specific configs that can be committed (via tag-mac/tag-linux)
- This two-tier system separates "personal machine tweaks" from "macOS vs Linux differences"

**XDG Base Directory spec:**

- Modern standard for config file locations
- Keeps home directory clean
- Better organization than scattered dotfiles
- Most tools now support ~/.config

**claude-permissions skill:**

- A focused, advisory linter for the layered permission config (CLAUDE.md intent, settings.json
  allow/ask/deny, the sandbox block, the guard hooks) at `claude/skills/claude-permissions/`;
  proposes diffs, never edits, so every change still passes through the normal plan-approve flow
- Standing policy it encodes: **sandbox-first. The OS sandbox contains Bash; destructive must-nevers
  live in `deny` rules; an ENFORCEMENT hook is added ONLY for what rules and the sandbox can't do
  (secret reads via the built-in Read/Grep/Glob tools). Enforcement hooks never parse Bash command
  strings.** Context-injection hooks are a separate category, justified case by case; the allow-only
  gh-api-readonly hook (above) parses but fails open. Security-related intent still gets a CLAUDE.md
  `## Safety` line. (Supersedes the earlier "belt-and-suspenders across all three layers" policy:
  duplicating a `deny` rule in a Bash-parsing hook is fragile maintenance for no gain once the
  sandbox is the primary boundary.)
- Threat model (canonical copy: the Threat model section of the skill's `invariants.md`): defend
  against accidental/mistaken commands; keep cheap, robust protections that also raise the attack
  bar; decline complex/fragile adversarial hardening as friction undercut by accepted residuals.
  Weigh each new rule against the accident it prevents
- Alternative considered: a declarative policy-registry file (rejected: another artifact to keep
  current, against the minimalism principle; invariants derive intent from the live config)

**Bash sandbox (macOS Seatbelt):**

- Enabled strictly (`enabled`, `failIfUnavailable: true`, `allowUnsandboxedCommands: false`): the
  PRIMARY containment boundary. `deny` rules still bind Bash (they descend into `$(...)` and are
  respected under sandbox auto-allow), so destructive verbs live in `deny` rules and the guard hook
  does no Bash parsing
- A single block in user scope (`claude/settings.json`), not split across scopes: the docs confirm
  the sandbox arrays merge across scopes (paths from every scope combine; deny entries only narrow),
  but scalar keys (`enabled`, `failIfUnavailable`) have no documented cross-scope semantics, so a
  split could still silently weaken the posture
- Tools needing broad `$HOME` writes are `excludedCommands`, not `filesystem.allowWrite` grants:
  `rcup`/`rcdn`/`mkrc` (symlink `$HOME`), `gh` (Go-TLS fails under Seatbelt), `git commit` (GPG
  needs the gpg-agent socket and `~/.gnupg`). Broad home-write grants are a privilege-escalation
  surface (shell configs, `$PATH` dirs). `brew`/`rustup`/`cargo`/`mas` stay un-excluded by design:
  maintenance-only, fail closed under the sandbox, run via `!`; excluding them would run build tools
  unsandboxed in every repo
- `autoAllowBashIfSandboxed: true` (the documented large prompt reduction): sandboxable commands run
  unprompted while `deny` rules still gate the destructive and secret-file cases; the repo-relative
  secret-read gap (`cat ./.env`, `cat secrets/x`) is closed by the
  `Bash(*.env*)`/`Bash(*/secrets/*)` denies, not a guard Bash-block
- Accepted tradeoffs and residuals: github-only egress for `just test` plugin fetches (raw
  `git push` denied; `just push` is host-checked, not identity-pinned; non-github egress via
  `git fetch <url>` or in-tree `insteadOf` accepted per the threat model); nvim data-dir writes
  apply globally; Linux deploys need bubblewrap + socat under `failIfUnavailable: true`; the
  text-match denies over-block benign mentions (`app.env`); the collision-prone
  `*.pem`/`*.key`/`*id_rsa*`/`.netrc`/`.npmrc` family is left out at user scope;
  `git -c k=v reset --hard` and split-flag `rm -fr` fall through to ask, not deny. All narrow and
  contained while the sandbox is active
- **`Bash(command -v:*)` is allowed** (read-only lookup plan mode would otherwise prompt on);
  `Bash(command:*)` is deliberately NOT (`command rm -rf /` would evade both the `rm -rf` deny and
  the `rm` ask)
- **The `Grep` built-in tool is denied**: it bypasses the sandbox, so a broad `Grep(path=~)` could
  leak `~/.aws` contents the path-guard can't catch; sandboxed `rg` is bounded by OS-level
  credential-denies that `--no-ignore`/`-u` cannot defeat. `Glob` stays (paths and metadata, not
  contents). The in-tree residual (`rg --no-ignore` on a git-ignored secret) is closed by the
  no-secrets-in-repos discipline
- **`~/.gnupg` is protected** (Read+Edit deny, guard case, `Bash(*/.gnupg/*)`, sandbox
  credential-deny) and `~/.aws` has a full Edit deny; neither breaks the AWS CLI nor GPG-signed
  commits (`aws *`/`git commit *` are `excludedCommands`, and Edit denies bind only the built-in
  tool). `git tag -s` and bare `gpg` under the sandbox are the documented over-block

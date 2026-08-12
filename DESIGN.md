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
- Exception: Rust tools (rust-analyzer, clippy, rustfmt) come from rustup, not Mason or Homebrew. They are toolchain components, version-matched to the active compiler and respect per-project rust-toolchain.toml
- Avoids duplicate installs and version mismatches between Homebrew and Mason

**BACKLOG.md for work tracking:**

- Git-tracked markdown file organised by effort/impact (fixes > low-hanging fruit > high impact > other > new tools)
- Complements Claude Code's built-in Tasks (session-level) and Memory (preferences/decisions)
- Split into `backlog/` directory if the file grows past ~100 items
- Alternative considered: GitHub Issues (requires network, splits context), Beads (requires Dolt server, alpha stability), split directory (premature before knowing the right split)

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

- `kitty.conf` holds only the settings this machine actually changes, plus the marker blocks
  kitty rewrites itself (`BEGIN_KITTY_FONTS`, `BEGIN_KITTY_THEME`)
- Browse the full option list with `just kitty-defaults`, which pipes the installed kitty's
  own default config into nvim (read-only, kitty syntax, folded by section)
- Alternative considered: keeping kitty's commented-out defaults interleaved in `kitty.conf`
  (rejected: stale by construction, the file drifted a whole release behind and hid 39 new
  options); vendoring a generated default file (rejected: repo churn on every kitty upgrade,
  and it needs a `typos` exclude for an upstream typo)
- Accepted cost: no local baseline, so "what changed since the last kitty version" comes from
  the changelog (`ctrl+shift+f1`) rather than a `git diff`

**Notification auto-dismiss on focus (kitty watcher):**

- kitty's built-in `notify_on_cmd_finish unfocused 5.0 notify focus` clears its own
  cmd-finished notifications when the window regains focus, but only those - it has no
  equivalent for notifications sent by other apps (e.g. Claude Code's OSC 99 "waiting for
  input" notification), which is why they lingered in Notification Center after refocus in
  kitty but not in Ghostty
- `config/kitty/close-notifications-on-focus.py`, loaded via `watcher` in `kitty.conf`,
  closes every live notification whose sending window matches the one that just regained
  focus, regardless of sender - it iterates
  `NotificationManager.in_progress_notification_commands` and calls `close_notification()`
  for entries whose `channel_id` matches
- Alternatives considered: kitty's `notifications.py` filtering hook (rejected: only fires
  at notification-creation time, before a `desktop_notification_id` even exists, so it has
  nothing to close); a standalone macOS launchd agent polling frontmost-app and clearing
  Notification Center directly (rejected: needs its own notification-center permissions and
  process lifecycle outside kitty, for a problem kitty's own watcher mechanism already
  solves from inside kitty's process); waiting for kitty to add a general option upstream
  (rejected: no such option exists as of 0.48.2, and no remote-control command for closing a
  notification either)
- Accepted risk: this reaches into `NotificationManager.in_progress_notification_commands`
  and `NotificationCommand.channel_id`, which kitty's own docs explicitly call
  undocumented/unstable. A future kitty release could rename or restructure these with no
  deprecation notice, making the watcher a no-op at runtime - `just test`'s `kitty +runpy`
  contract check turns that into a loud failure rather than a silent no-op, and even if
  that check somehow passes anyway, kitty catches and logs watcher exceptions rather than
  crashing, so the worst runtime case is a regression to today's lingering-notification
  behavior, not breakage
- Accepted cost: on macOS, kitty never learns when a notification was dismissed
  (`supports_close_events = False`), so closed entries are never purged from
  `in_progress_notification_commands` except via kitty's own 128-entry cap or
  replacement/activation - the watcher will harmlessly re-issue no-op close calls for old,
  already-gone notifications on every future focus of a window that has notified before
- Only affects kitty windows (including new tabs/splits) created after a config
  reload/restart (documented `watcher` caveat), not ones already open when this is added.
  kitty also caches a loaded watcher module by path for the life of the process, so any
  future edit to this script needs a full kitty restart to take effect, not just a reload
  plus a new window

**Ponytail vendored as a skill, not installed as a plugin:**

- Ponytail is a minimalism ruleset ("the best code is the code you never wrote") whose
  entire value is one 6.6 KB markdown file. `claude/skills/ponytail/SKILL.md` is a verbatim
  copy of it; `VENDOR.md` beside it carries the provenance and the MIT notice
- The upstream plugin wraps that file in three Node lifecycle hooks (SessionStart,
  SubagentStart, UserPromptSubmit) that only write a mode flag, inject the file into
  context, and parse `/ponytail` to switch intensity. Claude Code's own `skills/` mechanism
  covers the first two; the third is near-worthless because the intensity levels differ by
  two rows of a table the vendored copy keeps in full
- Alternatives considered: installing the plugin (rejected: it runs three third-party Node
  scripts with full user privileges on every session start, prompt submit, and subagent
  spawn - hooks are gated by neither `permissions`, `guard.sh`, nor the Bash sandbox, so it
  is the largest trust-boundary widening available here for the smallest benefit. node
  itself is already present transitively via `prettier`/`fish-lsp`/`bitwarden-cli`, so the
  objection is the unsandboxed execution and Node's supply-chain record, not availability -
  declaring `brew "node"` was considered and rejected for the same reason); putting the
  ruleset in `claude/CLAUDE.md` (rejected: true always-on injection at zero runtime, but
  pays ~1.4k tokens on every session including non-coding ones and bloats the file governing
  everything else); pinning the marketplace to a tag (rejected along with the plugin, but
  worth recording that upstream tags trailed `main` badly - `v4.8.4` was 53 commits behind
  when this was evaluated - so the reflexive "pin to a tag" would have been worse than
  tracking the branch)
- Accepted tradeoff: a skill is model-invoked rather than injected every session. Its own
  frontmatter description triggers it on any coding task, so it fires when relevant and
  costs nothing otherwise, which is preferable to a fixed per-session tax
- `SKILL.md` must stay byte-identical to upstream or `just ponytail-diff` stops meaning
  anything. That forces two documented exceptions: it is listed in `.prettierignore`, and
  it keeps 11 non-ASCII characters (em dashes, arrows, a superscript) against this repo's
  ASCII-only convention. Both apply to vendored third-party text only. Attribution lives in
  `VENDOR.md` rather than in a header for the same reason
- Updates are manual by design: `just ponytail-diff` exits 0 for up to date, 1 for drift,
  and 2 for a failed fetch, so a rate-limited or offline run cannot masquerade as "the whole
  ruleset changed". Nothing pulls automatically. Only 13 upstream commits have touched the
  ruleset (last 2026-07-10) while the plugin machinery churns constantly, so the vendored
  half is the stable half
- Deliberately no `just test` contract check, unlike the kitty watcher. That check exists
  because kitty's undocumented internals can silently no-op; here the failure mode is
  upstream text drift, which needs a human reading a diff, and wiring a network fetch into
  the test suite would fail it on a GitHub rate limit

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

- A focused, advisory linter for the Claude Code permission triangle (CLAUDE.md intent,
  settings.json allow/ask/deny, and the guard hooks), living at
  `claude/skills/claude-permissions/`
- Belt-and-suspenders drift (a policy enforced in one layer but not the others) is a distinct,
  checkable failure mode that the general config-improvement runbook does not target; this skill
  audits it against principle invariants and guides adding new policies across layers
- Advisory only (proposes diffs; never edits or commits), so every change still passes through
  the normal plan-approve flow
- Standing policy it encodes: **sandbox-first. The OS sandbox contains Bash; destructive
  must-nevers live in `deny` rules; a hook is added ONLY for what rules and the sandbox can't do
  (secret reads via the built-in Read/Grep/Glob tools). Hooks never parse Bash command strings.**
  Security-related intent still gets a CLAUDE.md `## Safety` line; non-security rules follow the
  minimalism default. (This supersedes the earlier "belt-and-suspenders across all three layers"
  policy: duplicating a `deny` rule in a Bash-parsing hook is fragile maintenance for no gain once
  the sandbox is the primary boundary.)
- Threat model it encodes: defends against **accidental/mistaken commands** and takes cheap, robust,
  low-friction protections (secret-path denies, the sandbox, denying a sandbox-bypassing built-in
  tool) that also raise the attack bar; it declines complex/fragile adversarial hardening (real-URL
  parsing, flag-tolerant command globs, narrowing widely-used commands) as excessive friction,
  undercut by accepted residuals (github egress, unattended `git fetch`/`just push`, in-tree
  `.git/config` trust) and the sandbox being the real containment. The secret-path denies, the
  sandbox, and the Grep-tool deny are kept because they are cheap and robust, not because the posture
  claims to be adversary-proof. When adding a rule, weigh it against the accident it prevents and its
  complexity, and prefer simple configuration.
- Alternative considered: a declarative policy-registry file (rejected: another artifact to keep
  current, against the minimalism principle; invariants derive intent from the live config)

**Bash sandbox (macOS Seatbelt):**

- Claude Code's OS-level Bash sandbox is enabled strictly (`enabled`, `failIfUnavailable: true`,
  `allowUnsandboxedCommands: false`) and is the PRIMARY containment boundary. `deny` rules still
  bind Bash (they descend into `$(...)` and are respected under sandbox auto-allow), so destructive
  verbs live in `deny` rules and the guard hook does no Bash parsing. `cat ~/.env` via Bash is
  caught by the `Bash(*.env*)`-family denies; a raw write to the direnv trust store is out-of-tree
  and sandbox-blocked
- Lives as a single block in user scope (`claude/settings.json`), not split across user +
  project scope: splitting would rely on the `sandbox` object deep-merging across scopes
  (unconfirmed); if merging is object-replace, this repo's project scope would silently drop
  `enabled`/`denyRead` and disable the sandbox in the primary repo
- Tools that need broad `$HOME` writes are `excludedCommands` (run through the normal permission
  flow) rather than granted broad `filesystem.allowWrite`: `rcup`/`rcdn`/`mkrc` (symlink `$HOME`),
  `gh` (Go-TLS fails under Seatbelt), and `git commit` (GPG signing needs the gpg-agent Unix
  socket and `~/.gnupg`, both outside the sandbox). Broad home-write grants are a
  privilege-escalation surface (shell configs, `$PATH` dirs), so exclusion is preferred over
  widening the write allowlist.
  `brew`/`rustup`/`cargo`/`mas` are deliberately NOT excluded - they are maintenance-only and
  fail-closed under the sandbox by design (run via `!`); excluding them would run build tools
  (e.g. `cargo build.rs`) fully unsandboxed in every repo for no benefit here
- Accepted tradeoffs: `network.allowedDomains` grants `github.com` for `just test`'s plugin
  fetches, a data-exfiltration surface the docs flag - acceptable because raw `git push` is denied
  (push goes through the `just push` wrapper, which is github-host-checked, not identity-pinned) and this is a solo machine; unattended non-github egress via `git fetch <url>` or an in-tree `insteadOf` redirect is an accepted residual per the threat model; `filesystem.allowWrite` for the nvim data dirs applies globally (the
  user's own editor state); the config deploys via rcm to Linux too, where the sandbox backend
  (bubblewrap + socat) is a prerequisite since `failIfUnavailable: true` hard-fails without it
- `autoAllowBashIfSandboxed: true` is enabled (the documented large prompt reduction): sandboxable
  commands run unprompted, contained by the sandbox, while `deny` rules still gate the destructive
  and secret-file cases. The repo-relative Bash secret-read gap (`cat ./.env`, `cat secrets/x`) is
  now closed by the `Bash(*.env*)`/`Bash(*/secrets/*)` deny rules, not a guard Bash-block. Residuals:
  the text-match denies over-block on benign mentions (an `app.env` filename, `foo.environment`);
  the collision-prone `*.pem`/`*.key`/`*id_rsa*`/`.netrc`/`.npmrc` family is deliberately left out at
  user scope; a global-opt destructive form the deny globs miss (`git -c k=v reset --hard`); the
  `rm -fr`/split-flag ordering falls through to the `Bash(rm:*)` ask rather than a hard block (the
  guard used to catch `-fr`); and a sandbox-off (`failIfUnavailable: false`) raw write to the direnv
  trust store. All narrow and contained by the sandbox when active
- **`Bash(command -v:*)` is allowed** (a read-only lookup that plan mode would otherwise prompt on,
  since it isn't a built-in read-only command and plan mode skips sandbox auto-allow). `Bash(command:*)`
  is deliberately NOT allowed: `command <cmd>` executes `<cmd>`, so `command rm -rf /` (first token
  `command`) would evade both `Bash(rm -rf:*)` and the `rm` ask
- **The `Grep` built-in tool is denied** (steering content search to sandboxed `rg`): the built-in
  tool bypasses the sandbox, so a broad `Grep(path=~)` recursing into `~/.aws` leaks credential
  contents the path-guard can't catch; sandboxed `rg` is bounded by the OS-level credential-denies,
  which `rg --no-ignore`/`-u` cannot defeat (they are filesystem denies, not `.gitignore`). `Glob`
  stays (it returns paths/metadata, not contents). The in-tree residual (`rg --no-ignore` reading a
  git-ignored secret) is closed by the no-secrets-in-repos discipline, not a rule
- **`~/.gnupg` is protected** (Read+Edit deny, guard case, `Bash(*/.gnupg/*)`, sandbox
  credential-deny) and `~/.aws` is upgraded to a full Edit deny. Neither breaks the AWS CLI nor
  GPG-signed commits (`aws *`/`git commit *` are `excludedCommands`, and the Edit denies bind only
  the built-in Edit tool, not the CLIs); `git tag -s` and a bare `gpg` under the sandbox are the
  documented over-block

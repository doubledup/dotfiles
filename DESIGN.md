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

**Formatting enforced at commit (git pre-commit hook):**

- `.githooks/pre-commit` formats fully staged files, re-stages them, then runs `just check`, so a
  formatting miss from any source is fixed inside the commit and only lint blocks. A file that also
  has unstaged changes is only checked: re-staging it would commit hunks that were never staged
- `.claude/hooks/lint-edit.sh` (PostToolUse on Edit/Write, this repo only) lints the edited shell or
  fish file and feeds failures back to Claude, so a lint error is fixed in the same turn rather than
  at commit. It lints, never formats (the commit hook owns that), and fails open. It runs via
  `bash`, because the sandbox can't set the execute bit under `.claude/hooks`
- `just sync` re-applies `core.hooksPath`, so a clone set up before the hook existed gets it
- Residuals: `just check` validates the working tree, not the index, so a staged misformat whose
  working copy was since fixed passes; committing with explicit paths runs the hook on a temporary
  index, so the real index can keep the unformatted blob afterwards
- Alternative considered: Claude PostToolUse format hook (rejected: misses edits outside Edit/Write)

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

**Tokyo Night palettes vendored from upstream extras:**

- Kitty (`*-theme.auto.conf`), Ghostty (`themes/`), and fish (`themes/*.fish`) each hold verbatim
  copies of `folke/tokyonight.nvim` `extras/` files for the Day and Moon variants.
  `just tokyonight-vendor` refreshes all of them at once; `git diff` is the review
- Each terminal picks the variant from OS appearance itself; fish follows the terminal's report
  (`fish_terminal_color_theme`, DEC mode 2031) through the handler in `conf.d/theme.fish`, which
  sources the matching upstream script
- Alternatives considered: `fish_config theme choose` with upstream `.theme` files (rejected: its
  override semantics either erase the prompt roles fish's default theme sets, or, with a
  fish-generated `fish_frozen_theme.fish` in `conf.d`, silently apply nothing; a plain `source` has
  neither trap); ANSI colour names in fish so the terminal palette drives it (rejected: loses the
  per-role hex colours upstream assigns)

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

**Claude Code user config: minimal always-on context:**

Target state for `claude/`. A line is always loaded only if it applies to most turns in most repos;
procedures live in skills (loaded on invoke), file-specific guidance in path-scoped rules,
must-nevers in the sandbox and deny rules. Budget: about 80 always-loaded lines.

- `CLAUDE.md`: environment, communication, persistence, safety prose not enforced elsewhere,
  compressed sandbox gotchas. No thinking keywords or session discipline. In this repo, touching a
  file under `claude/` loads `claude/CLAUDE.md` a second time as a nested CLAUDE.md (about 1k
  tokens, once per session). Accepted: `~/.claude/CLAUDE.md` links to the same file, so a
  `claudeMdExcludes` pattern for it may also drop the user CLAUDE.md, silently, in every session
  here
- Rules: `git.md` unscoped; `claude-config.md` and `prose.md` path-scoped. `claude-config.md` points
  at the `code.claude.com` reference for each config schema, because a wrong-but-valid field choice
  (`Skill` in an agent's `tools` instead of `skills:` frontmatter) passes `just check`. It loads
  when Claude touches a matching file inside the current project and reloads after compaction
  ([memory docs](https://code.claude.com/docs/en/memory#path-specific-rules)). Verified: Read,
  Write, and Bash `head` load it; `cat >/dev/null` does not; files outside the project never do.
  Accepted gap: editing user config from another repo gets no pointer, since user config is edited
  in `~/.dotfiles` sessions. Rejected: a skill (invocation is model-mediated, which fails when the
  model doesn't know its knowledge is stale); a `CLAUDE.md` line (always loaded for a rare case)
- Agents: one `reviewer` (plan and diff modes, ponytail preloaded) for the design lens built-ins
  lack: plan review, and diff review for plan conformance and over-engineering. Correctness and
  security review use built-in `/code-review` and `/security-review`, which already fan out.
  Rejected: splitting into spec/plan reviewers plus four diff specialists (more agents, no verify
  pass, duplicates a maintained built-in)
- Skills: `ship` (plan, execute, review; starts at the plan, no spec phase; review loops cap at 3
  iterations), `full-review` (the Reviewer plus `/code-review` and `/security-review`, one VERDICT;
  accepted cost: up to 3 sources plus a confirm pass per iteration; `/code-review` returns
  unverified findings, so built-in MEDIUM+ counts only once the Reviewer confirms it, or ship's loop
  never converges), `ponytail`, `pr-triage`, `claude-permissions`, `handoff`, `authored-voice` (PR
  comms rules plus `voice.md`, loaded only when drafting text in the user's voice; rejected: an
  output style, inert while another style is active, and a rule, loaded every session). No commands
- Hooks: `guard.sh` (security leg) and `commit-alone.sh`. Formatting is enforced by each repo's own
  pre-commit hook, not a PostToolUse hook (see "Formatting enforced at commit")
- Settings: deny unrecoverable loss and leaks-secrets; ask only for actions that ship or publish
  (merge, release, deploy, Confluence writes); the auto-mode classifier reviews everything else.
  Bash `allow` rules only for commands harmless outside the sandbox (e.g. `command -v`, `date`), in
  settings and in skill `allowed-tools` alike: an allow also approves the command's unsandboxed
  retry with no classifier review, and tools like `rg` (`--pre`), `fd` (`-x`), `git` (config-driven
  hooks and filters) and `just` run arbitrary code. Sandbox auto-allow already runs them unprompted.
  Cost: plan mode prompts on them
- Work-only config (Jira, acli, jdtls-lombok, Atlassian asks) lives under `tag-work/`, enabled only
  on the work machine, so rcm never links it here

**commit-alone hook:**

- `claude/hooks/commit-alone.sh` (PreToolUse on Bash) blocks an excluded git verb (signing:
  `commit`, `merge`, `rebase`, `cherry-pick`, `revert`; SSH: `fetch`, `pull`, `push`) unless it is a
  lone call, and tells the model to rerun it alone. Only a lone call matches `excludedCommands`,
  which GPG signing and SSH remotes need; the CLAUDE.md prose rule alone was repeatedly missed
- It parses the Bash command string, which the enforcement-hook rule forbids; acceptable here
  because it is not a security leg and fails open: a miss is a failed signed commit or remote op
  (the status quo), and a false positive costs one retry

**gh-api-readonly hook:**

- `claude/hooks/gh-api-readonly.sh` (PreToolUse on Bash) auto-approves read-only `gh api` calls to
  GitHub Actions endpoints, cutting prompt noise during CI triage
- It parses the Bash command string, which the enforcement-hook rule forbids; acceptable here
  because it is allow-only and fails open: any parse failure or rejected pattern falls through to
  the normal permission prompt, so the failure mode is a prompt, not a bypass
- Accepted gaps: no `timeout` in settings.json and no test harness, unlike the other hooks (backlog)

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
  gh-api-readonly and advisory commit-alone hooks (above) parse but fail open. Security-related
  intent still gets a CLAUDE.md `## Safety` line. (Supersedes the earlier "belt-and-suspenders
  across all three layers" policy: duplicating a `deny` rule in a Bash-parsing hook is fragile
  maintenance for no gain once the sandbox is the primary boundary.)
- Threat model (canonical copy: the Threat model section of the skill's `invariants.md`): defend
  against accidental/mistaken commands; keep cheap, robust protections that also raise the attack
  bar; decline complex/fragile adversarial hardening as friction undercut by accepted residuals.
  Weigh each new rule against the accident it prevents
- Alternative considered: a declarative policy-registry file (rejected: another artifact to keep
  current, against the minimalism principle; invariants derive intent from the live config)

**Bash sandbox (macOS Seatbelt):**

- Enabled with `failIfUnavailable: true`: the PRIMARY containment boundary. Unsandboxed retries are
  allowed (`allowUnsandboxedCommands: true`) and reviewed by the auto-mode classifier, not a prompt,
  so a sandbox-incompatible command doesn't stop the session. A
  `Bash(dangerouslyDisableSandbox:true)` ask rule would prompt on every retry, even in auto mode and
  over a co-matching allow rule (verified live). `deny` rules still bind Bash (they descend into
  `$(...)` and are respected under sandbox auto-allow and unsandboxed), so destructive verbs and
  production credentials live in `deny` rules and the guard hook does no Bash parsing. Alternative:
  `allowUnsandboxedCommands: false` (rejected: every such command becomes a hand-off)
- **The `autoMode` block describes the environment, not new rules**: the built-in classifier rules
  already block production deploys and reads, PII handling, and tree-wide discards; the block tells
  them where those things are (default-branch pushes outside `~/.dotfiles`, production AWS profiles,
  the stores holding customer data). It is read from user scope only, so it lives here
- A single block in user scope (`claude/settings.json`), not split across scopes: the docs confirm
  the sandbox arrays merge across scopes (paths from every scope combine; deny entries only narrow),
  but scalar keys (`enabled`, `failIfUnavailable`) have no documented cross-scope semantics, so a
  split could still silently weaken the posture
- Tools needing broad `$HOME` writes are `excludedCommands`, not `filesystem.allowWrite` grants:
  `rcup`/`rcdn`/`mkrc` (symlink `$HOME`), `gh` (Go-TLS fails under Seatbelt), `git commit` (GPG
  needs the gpg-agent socket and `~/.gnupg`), `git fetch`/`pull`/`push` (macOS can't tunnel git's
  SSH through the sandbox proxy, and the remotes stay SSH rather than needing an HTTPS credential
  helper). Broad home-write grants are a privilege-escalation surface (shell configs, `$PATH` dirs).
  `brew`/`rustup`/`cargo`/`mas` stay un-excluded by design: maintenance-only, fail under the
  sandbox, run via `!` or a prompted unsandboxed retry; excluding them would run build tools
  unsandboxed in every repo
- `autoAllowBashIfSandboxed: true` (the documented large prompt reduction): sandboxable commands run
  unprompted while `deny` rules still gate the destructive and secret-file cases; the repo-relative
  secret-read gap (`cat ./.env`, `cat secrets/x`) is closed by the
  `Bash(*.env*)`/`Bash(*/secrets/*)` denies, not a guard Bash-block
- **`~/.dotfiles` is an additional directory** (beside `~/code/worktrees`), so any session can edit
  and commit user config without `/add-dir`. That also opens it to sandboxed writes, so `denyWrite`
  keeps read-only what runs or instructs without review: `claude/hooks`, `claude/skills`,
  `claude/rules`, `.githooks`, `justfile` and `scripts`. A build script or dependency in another
  repo can't plant code there; the Edit tool still can, under the permission flow. Shell and editor
  configs (`config/`, `zshrc`) stay writable: a residual, caught by reviewing the dotfiles diff
- **Plain push goes to the classifier; unrecoverable pushes are must-nevers**: `git push` has no
  `allow` rule. It is an excluded command, so it runs unsandboxed and the classifier reviews it,
  which an `allow` would skip. A push to the default branch outside `~/.dotfiles` counts as a
  production deploy (`autoMode.environment`), so the classifier refuses it unless the user asked.
  Only the unrecoverable forms (`--force*`, `-f`, `+refspec`, `--mirror`) and every `git -C * push`
  are `deny`; branch protection backstops the rest. Shipping one-way doors (`gh pr merge`,
  `gh release create`, `terraform apply`, `just deploy`) are `ask`: they are direction decisions.
  Destructive ones with no routine use (`gh repo delete`, `terraform destroy`) are `deny`; rarer
  ones get a rule when they show up
- Accepted tradeoffs and residuals: github-only egress for `just test` plugin fetches (non-github
  egress via `git fetch <url>` or in-tree `insteadOf` accepted per the threat model); nvim data-dir
  writes apply globally; Linux deploys need bubblewrap + socat under `failIfUnavailable: true`; the
  text-match denies over-block benign mentions (`app.env`); the collision-prone
  `*.pem`/`*.key`/`*id_rsa*`/`.netrc`/`.npmrc` family is left out at user scope; recursive `rm`
  clusters the denies don't spell (`-vfr`, `-dr`, `-ir`) and wrapped forms (`xargs rm -r`) run
  unprompted. All narrow and contained while the sandbox is active
- **Discarding uncommitted edits runs unprompted** (`reset --hard`, `checkout`/`restore` of a path
  or the tree, `checkout -f`, `switch --discard-changes`, `stash drop`): the worst case is redoing
  uncommitted work, and small frequent commits bound it; a dropped stash stays recoverable through
  `git fsck` until gc. No rule matches them, so the classifier decides: it allows per-file reverts
  and refuses a tree-wide discard or stash drop you didn't ask for. `git clean` and the forced
  `worktree remove` stay `deny`: they delete untracked and ignored files git never held. Plain
  `worktree remove` deletes only ignored files (build output, local overrides) and goes to the
  classifier, so Claude can clean up its own worktrees
- **Local history operations have no verb-level `allow`** (`merge`, `rebase`, `cherry-pick`,
  `revert`): they are `excludedCommands` for GPG signing, so they run unsandboxed and the auto-mode
  classifier reviews each, as it does their `--abort`/`--skip` and `git -C *` forms; an `allow`
  would skip that review. In-repo hooks and merge drivers they trigger run outside the sandbox as
  hooks already do for `git commit`. `rebase --exec`/`-x` (arbitrary command, unsandboxed) is `deny`
  in leading or later flag position; clustered short flags (`-ix`) fall to the classifier
- **Plain `rm` runs unprompted** (sandboxed, auto-allowed): the sandbox bounds it to its write set,
  and git restores tracked files; losing an untracked file is the accepted cost of not prompting on
  every temp-file cleanup. Recursive `rm` is `deny` in its common spellings (`-r`, `-R`,
  `--recursive`, `-fr`, `-fR`, in leading or later position). `dd` and `rsync` are `deny`: rare
  here, so Claude hands the command over instead
- **`Bash(command -v:*)` is allowed** (read-only lookup plan mode would otherwise prompt on);
  `Bash(command:*)` is deliberately NOT (`command rm -rf /` would evade the recursive `rm` denies)
- **The `Grep` built-in tool is denied**: it bypasses the sandbox, so a broad `Grep(path=~)` could
  leak `~/.aws` contents the path-guard can't catch; sandboxed `rg` is bounded by OS-level
  credential-denies that `--no-ignore`/`-u` cannot defeat. `Glob` stays (paths and metadata, not
  contents). The in-tree residual (`rg --no-ignore` on a git-ignored secret) is closed by the
  no-secrets-in-repos discipline
- **`~/.gnupg` is protected** (Read+Edit deny, guard case, `Bash(*/.gnupg/*)`, sandbox
  credential-deny) and `~/.aws` has a full Edit deny. GPG-signed commits still work (`git commit *`
  is an `excludedCommands` entry, and Edit denies bind only the built-in tool); `aws` is not
  excluded, so sandboxed `aws` cannot read `~/.aws` and authenticated calls fail in the sandbox; an
  unsandboxed retry reads `~/.aws`, gated by the classifier. Production profiles are `deny` by
  command text (`*--profile*prd*`, `*_PROFILE=*prod*` and their pairs, which also cover
  `AWS_DEFAULT_PROFILE`). They over-match on purpose: `prod` anywhere after the flag blocks, so a
  `products` table or bucket in the same command is denied; relax them if that friction shows up.
  Uppercase names, profiles set in a separate shell step, and SDK use are left to the classifier.
  `git tag -s` and bare `gpg` under the sandbox are the documented over-block
- **Customer data stays out of context**: `dumps/` is `deny` for Read (which also lands in the
  sandbox read-deny) and by Bash command text. Residual: in a repo with a legitimate `dumps`
  directory, sandboxed tools that walk it (`git status`, builds) fail there. Datadog log, trace,
  span and RUM MCP tools are `ask`: they return customer personal information, while metrics and
  monitors stay unprompted. The name globs (`mcp__*atadog*__*logs*`) cover both the connector and
  the plugin server, and over-match any config tool sharing those words. `cleanupPeriodDays: 7`
  limits how long an accidental leak sits in local transcripts. Scanning prompts and edits for
  personal identifiers belongs in each work repo's hooks, where the identifier formats are known.
  Alternatives: deny `*.log` reads (rejected: blocks local build and test output); deny
  `~/Downloads` (rejected: files there are handed over on purpose)

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
- Alternative considered: Claude PostToolUse format hook (rejected: misses edits outside
  Edit/Write). The lint hook above takes that miss: it only speeds up feedback, and the commit hook
  still gates

**`backlog-doubledup/` for work tracking:**

- One local backlog per repo, at the main checkout root so worktrees share it; follow-ups go to the
  project's backlog, or to `~/.dotfiles/backlog-doubledup/` when they concern user config. Only
  medium-or-higher impact work is recorded, so the backlog stays short
- One markdown file per item; the README is the only place that orders items: Next holds the single
  highest-priority item, Remaining is a flat list
- Read only on request ("continue the backlog"), never at session start
- Adding an item is always loaded (user `CLAUDE.md` Workflow), since capture must work in any
  session; working a backlog is the path-scoped `claude/rules/backlog.md`, which loads once a README
  is read. Path rules load only for files inside the current project, so work a backlog from its own
  repo's main checkout, not a worktree (the dotfiles backlog from `~/.dotfiles`)
- Local-only and git-ignored, globally and in this repo (public; a clone may predate `rcup`): items
  carry work detail. Single machine, no history; deleting a finished item is permanent. The
  `-doubledup` suffix keeps the global ignore off repos with a real `backlog/` directory
- Complements Claude Code's built-in Tasks (session-level) and Memory (preferences/decisions)
- Alternatives considered: per-item front matter for status and priority (duplicates the README
  order and drifts), a committed backlog (public repo), the process in each README (copies drift),
  GitHub Issues (requires network, splits context), Beads (requires Dolt server, alpha stability)

**just for task running:**

- Simpler syntax than make (no tabs, clear command syntax)
- Better error messages and user experience
- Cross-platform by design
- Focused on running commands, not building software (better fit than make)

**Kitty terminal:**

- GPU-accelerated for performance
- Modern feature set (ligatures, images, extensive customization)
- Mature, well-established
- Supports keyboard-driven workflows

**Catppuccin from each tool's official port (Latte for light, Mocha for dark):**

- Each tool below follows OS appearance, and one scheme with a written cross-port style guide keeps
  their colours in step
- Kitty holds verbatim copies of `catppuccin/kitty` `latte.conf` and `mocha.conf`
  (`catppuccin-latte.conf`, `catppuccin-mocha.conf`), and picks a flavour from OS appearance itself
  through `light-theme.auto.conf` and `dark-theme.auto.conf`. Those wrappers `include` the vendored
  copy and then set local overrides, so re-vendoring never touches the overrides and the copies stay
  byte-identical. `just catppuccin-vendor` fetches every vendored file at the upstream commit the
  justfile pins per repo, so upstream changes land only when a pin is bumped; `git diff` is the
  review. The delta file goes live through its include as soon as it is written, so a bump is the
  point to read the upstream diff
- Kitty re-reads a theme wrapper on reload only when the wrapper's mtime changes, not an included
  file's (observed), so after editing a vendored copy or adding its `rcup` link, `touch` the wrapper
  before `ctrl+shift+f5`
- Neovim loads `catppuccin/nvim` through lazy; `colorscheme catppuccin-nvim` picks the flavour from
  `background`, which auto-dark-mode sets
- fish sets its colours with ANSI names (`conf.d/theme.fish`), so kitty's Catppuccin palette drives
  them: kitty stores palette colours by index, so a light/dark switch recolours fish output already
  in scrollback, where truecolor output keeps the flavour it was printed in. Roles follow fish's
  bundled catppuccin theme; accents outside the 16-colour palette (peach, mauve, flamingo) take the
  nearest palette colour. `theme.fish` sorts after the fish-generated `fish_frozen_theme.fish` in
  `conf.d`, so its globals win
- Delta holds one `syntax-theme` and one set of hunk colours, so git runs it through
  `local/bin/delta-auto`, which reads macOS appearance on every call and passes the
  `catppuccin-latte` or `catppuccin-mocha` feature from `config/delta/catppuccin.gitconfig` (a
  verbatim copy of `catppuccin/delta` that `gitconfig` includes). Reading the OS per call covers git
  started from any program, including an nvim or Claude Code that predates the switch; off macOS it
  passes Mocha. The wrapper unsets `DELTA_FEATURES`, which outranks `--features` (measured)
- bat follows OS appearance itself (`--theme=auto:system`) and ships the Catppuccin themes, which
  delta also bundles, so neither needs vendored themes or a cache build
- Firefox extensions keep their styles in extension storage, so `rcignore/vimium.css` and
  `rcignore/treestyletab.css` are applied by hand (README, Firefox). Each follows OS appearance with
  `prefers-color-scheme` and repeats the extension's own selectors or variables, which change
  between releases, so a style that stops applying needs its selectors checked against upstream
- Alternatives considered: Tokyo Night (rejected: its per-tool ports disagree on about half of all
  characters between nvim and bat, measured); fish's bundled catppuccin hex theme (rejected: its
  truecolor output keeps the old flavour in scrollback after a switch, including every prompt and
  typed command); palette colours in bat and delta (bat's `ansi` theme), so output already on
  screen, such as an open pager, recolours when kitty switches palette (rejected: Catppuccin's kitty
  palette holds six accent hues, so about half of all characters change colour against bat's
  Catppuccin theme, measured, and delta's tinted hunk backgrounds have no palette equivalent).
  Accepted cost: truecolor output keeps the flavour it was drawn in, so a pager open across a switch
  needs a rerun

**Kitty option reference generated on demand:**

- `kitty.conf` holds only the settings this machine actually changes, plus the marker block kitty
  rewrites itself (`BEGIN_KITTY_FONTS`); themes come from the `*-theme.auto.conf` files
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
  Notification Center
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

**Rounded kitty tabs (custom tab bar):**

- `config/kitty/tab_bar.py` (`tab_bar_style custom`) draws each tab as a separate bubble with
  rounded caps (U+E0B6, U+E0B4), coloured from the active theme at draw time so the caps follow the
  OS light/dark switch. Kitty draws these glyphs itself, so they fill the cell whatever the font
- Alternatives considered: `tab_title_template` caps (rejected: the template can colour text with
  the tab's foreground or background, not the tab's background as a foreground on the bar, so caps
  need hard-coded hex that breaks on the theme switch); built-in `powerline` with `round` (rejected:
  joins tabs instead of separating them)
- The drawer's width reservation must match what it draws, because kitty sizes each tab from a first
  pass that measures the drawer. The last tab has no trailing gap, so it must not reserve one, or
  its title truncates
- Accepted cost: kitty loads the module once per process and keeps the built-in fallback if the
  first load fails, so edits (and a first install before `rcup`) need a full restart, not a reload

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
- Rules: `git.md` unscoped; `claude-config.md`, `prose.md` and `backlog.md` path-scoped.
  `claude-config.md` points at the `code.claude.com` reference for each config schema, because a
  wrong-but-valid field choice (`Skill` in an agent's `tools` instead of `skills:` frontmatter)
  passes `just check`. It loads when Claude touches a matching file inside the current project and
  reloads after compaction
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
  iterations, then the user decides: 3 more, proceed or stop), `full-review` (the Reviewer plus
  `/code-review` and `/security-review`, one VERDICT; accepted cost: up to 3 sources plus a confirm
  pass per iteration; `/code-review` returns unverified findings, so built-in MEDIUM+ goes to the
  Reviewer to confirm, and an unconfirmed one drops to LOW, or ship's loop never converges),
  `ponytail`, `pr-triage`, `claude-permissions`, `handoff`, `authored-voice` (PR comms rules plus
  `voice.md`, loaded only when drafting text in the user's voice; rejected: an output style, inert
  while another style is active, and a rule, loaded every session), `parallel-sessions` (subagents
  in worktrees open draft PRs; this session reviews and merges them; repo facts live in each repo's
  CLAUDE.md), `wrap-up` (end-of-session open threads; closes only what needs no decision). No
  commands
- Hooks: `guard.sh` (security leg), `commit-alone.sh`, and `worktree-create.sh` (places every
  worktree, including subagents', flat under `~/code/worktrees/`, branched off the remote's default
  branch, instead of the repo's `.claude/worktrees`). Formatting and lint are enforced by each
  repo's own pre-commit hook; a project PostToolUse lint hook only shortens feedback (see
  "Formatting enforced at commit")
- Background sessions keep Claude Code's worktree guard (`worktree.bgIsolation` unset): Edit and
  Write are refused in the main checkout until `EnterWorktree`, so parallel jobs never share a
  working copy, and git commands that target another checkout (including `!` commands) are refused
  too, so commits land on `main` by the worktree rule in `claude/rules/git.md`. Rejected:
  `"bgIsolation": "none"` for this direct-to-`main` repo, which puts every background job in one
  working copy. The guard covers file tools only; sandboxed Bash can still write to `~/.dotfiles`
- Settings: deny unrecoverable loss and leaks-secrets; ask only for actions that ship or publish (PR
  creation, merge, release, deploy); the auto-mode classifier reviews everything else. The Atlassian
  MCP's read and non-destructive write tools are allowed by exact name, `executeWrite` included: a
  Jira or Confluence edit is recoverable from page and issue history, and its one destructive
  runner, `executeDestructive`, is `deny`. Exact names send a primary tool the connector adds later
  to the classifier (a prompt in default mode) until it is listed; an operation reached through
  `executeRead` or `executeWrite` follows the server's tiering instead. Bash `allow` rules only for
  commands harmless outside the sandbox (e.g. `command -v`, `date`), in settings and in skill
  `allowed-tools` alike: an allow also approves the command's unsandboxed retry with no classifier
  review, and tools like `rg` (`--pre`), `fd` (`-x`), `git` (config-driven hooks and filters) and
  `just` run arbitrary code. Sandbox auto-allow already runs them unprompted. Cost: plan mode
  prompts on them. Exception: the worktree cleanup verbs (`git worktree remove`, `prune`,
  `git branch -d`/`-D`) are allowed and excluded, so cleanup skips the classifier. Only a planted
  `.git/config` (e.g. `core.fsmonitor`) turns them into code execution, which is deliberate, not
  accidental, and outside the threat model; the forced remove stays `deny`
- Claude's temp dirs (`/tmp/claude-<uid>`, which is `$TMPDIR`) are allowed without naming the uid:
  `Read` on `//private/tmp/claude-*/**` and `//tmp/claude-*/**`, `Edit` only on their direct
  children (`/*`), where scratch files go. Both spellings are needed because macOS `/tmp` is a
  symlink and an allow rule matches only when the requested and the resolved path both match. Edit
  stays shallow so it can't reach the harness's task output under `<project>/<session>/tasks/`;
  Claude Code also mirrors Edit allows into the sandbox's write paths. `claude-*` matches other
  users' dirs too, accepted on a single-user machine (they are `drwx------`)
- The file tools' `Read` in `~/.claude` is an allowlist, not a broad allow with denies: the
  directory also holds key files, transcripts, prompt and paste history and file snapshots, and
  Claude Code adds new state directories over time, so a denylist fails open. The config directories
  (`skills`, `agents`, `rules`, `hooks`, `commands`, `docs`) and the top-level `CLAUDE.md` and
  `settings.json` hold symlinks into `~/.dotfiles/claude/`, so each needs `~/.dotfiles/claude/**` as
  well, for the resolved path. Memory (`projects/*/memory/**`) and `plans/**` are real directories.
  Everything else in `~/.claude` prompts. This gates the file tools only: sandboxed Bash reads all
  of `~/.claude` except the paths the sandbox itself denies
- Work-only config (Jira, acli, jdtls-lombok) lives under `tag-work/`, enabled only on the work
  machine, so rcm never links it here

**commit-alone hook:**

- `claude/hooks/commit-alone.sh` (PreToolUse on Bash) blocks an excluded git verb (signing:
  `commit`, `merge`, `rebase`, `cherry-pick`, `revert`; SSH: `fetch`, `pull`, `push`) unless it is a
  lone call, and tells the model to rerun it alone. Only a lone call matches `excludedCommands`,
  which GPG signing and SSH remotes need; the CLAUDE.md prose rule alone was repeatedly missed
- It parses the Bash command string, which the enforcement-hook rule forbids; acceptable here
  because it is not a security leg and fails open: a miss is a failed signed commit or remote op
  (the status quo), and a false positive costs one retry

**gh api reads:**

- No hook and no `allow` rule: `gh` is sandbox-excluded, so the auto-mode classifier judges each
  call and passes reads unprompted (measured: a GitHub Actions runs read). A broad `allow` would
  also pre-approve `gh api` writes, which the classifier still reviews

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
  strings.** Context-injection hooks are a separate category, justified case by case; the advisory
  commit-alone hook (above) parses but fails open. Security-related intent still gets a CLAUDE.md
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

- Enabled with `failIfUnavailable: true`: the PRIMARY containment boundary. Unsandboxed retries are
  allowed (`allowUnsandboxedCommands: true`) and reviewed by the auto-mode classifier, not a prompt,
  so a sandbox-incompatible command doesn't stop the session. A
  `Bash(dangerouslyDisableSandbox:true)` ask rule would prompt on every retry, even in auto mode and
  over a co-matching allow rule (verified live). `deny` rules still bind Bash (they descend into
  `$(...)` and are respected under sandbox auto-allow and unsandboxed), so destructive verbs and
  production credentials live in `deny` rules and the guard hook does no Bash parsing. Alternative:
  `allowUnsandboxedCommands: false` (rejected: every such command becomes a hand-off)
- **The `autoMode` block describes the environment, not new rules**: the built-in classifier rules
  already block production deploys and reads, and PII handling, in what reaches them; the block
  tells them where those things are (production AWS profiles, the stores holding customer data). It
  is read from user scope only, so it lives here
- A single block in user scope (`claude/settings.json`), not split across scopes: the docs confirm
  the sandbox arrays merge across scopes (paths from every scope combine; deny entries only narrow),
  but scalar keys (`enabled`, `failIfUnavailable`) have no documented cross-scope semantics, so a
  split could still silently weaken the posture
- Tools needing broad `$HOME` writes are `excludedCommands`, not `filesystem.allowWrite` grants:
  `rcup`/`rcdn`/`mkrc` (symlink `$HOME`), `gh` (Go-TLS fails under Seatbelt), `git commit` (GPG
  needs the gpg-agent socket and `~/.gnupg`), `git fetch`/`ls-remote`/`pull`/`push` (macOS can't
  tunnel git's SSH through the sandbox proxy, and the remotes stay SSH rather than needing an HTTPS
  credential helper). Push is excluded only toward `origin` (`git push`, `git push origin …`,
  `git push -u`/`--set-upstream origin …`): any other target, however spelled (a path, `--repo=`, a
  variable), runs sandboxed, so a local target's `receive-pack` hooks stay contained; `origin`'s URL
  is in sandbox-protected `.git/config`. Broad home-write grants are a privilege-escalation surface
  (shell configs, `$PATH` dirs). `brew`/`rustup`/`cargo`/`mas` stay un-excluded by design:
  maintenance-only, fail under the sandbox, run via `!` or a prompted unsandboxed retry; excluding
  them would run build tools unsandboxed in every repo
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
- **Git config is sandbox read-only** (`~/**/.git/config`, `~/.gitconfig` and its rcm target
  `~/.dotfiles/gitconfig`, `~/.config/git/config` in `denyWrite`; `Edit` denies on both gitconfig
  paths): `core.sshCommand`, `remote.<n>.uploadpack` and similar keys run a command on the next
  unsandboxed `git fetch`/`push`, which the classifier sees only as a plain fetch. The project
  root's `.git/config` is already built-in protected; these entries extend that to every repo and to
  global config. Measured: `git config --global` and a repo `git config` both fail. Cost: sandboxed
  config writes (`git remote add`, `git branch -u`) run via `!`; `git push -u` is excluded and
  unaffected
- **Plain push goes to the classifier; unrecoverable pushes are must-nevers**: `git push` has no
  `allow` rule. It is an excluded command, so it runs unsandboxed and the classifier reviews it,
  which an `allow` would skip. The classifier treats a push to the default branch as ordinary
  (measured: an `autoMode.environment` line calling it a production deploy didn't stop one), so each
  remote's branch protection is what keeps unreviewed code off a deploying `main`. Only the
  unrecoverable forms (`--force*`, `-f`, `+refspec`, `--mirror`, `--delete`/`-d`, `:branch`,
  `--prune`) and every `git -C * push` are `deny`. Infra one-way doors (`terraform apply`,
  `just deploy`) are `ask`: an apply can destroy resources. GitHub writes that only add or merge
  (`gh pr create`, `gh pr merge`, `gh release create`) have no user rule, so the classifier judges
  them: a merge is revertable and branch protection gates it, and a repo that wants a human gate (a
  PR review gate, a release) adds the `ask` in its project settings.
  `gh pr merge --delete-branch`/`-d` is `deny`, like `git push --delete`. Known-destructive changes
  to remote state are `deny` up front: repo delete, archive, rename and visibility changes; gh
  release, secret, variable, label, gist, issue, project (and its items and fields), deploy-key, SSH
  and GPG key, and codespace deletes; `gh api` DELETE calls and graphql delete mutations;
  `terraform destroy`, `-destroy`, `state rm` and `workspace delete`; `aws` operations named
  `delete-*`, `*-delete-*` (`batch-delete-image`) or `purge-*`, plus `s3 sync --delete`,
  `terminate-*`, `schedule-key-deletion`, `s3 rm` and `s3 rb`, on any profile; and the Atlassian
  MCP's `executeDestructive`. `full-review` checks out same-repo PRs with `gh pr checkout`, which
  runs unsandboxed with the PR's tracked hooks; teammates' PRs are trusted per the accidents-only
  threat model, and fork PRs stop for the user. Regenerable state (`gh run delete`,
  `gh cache delete`) has no rule. A rule with a `*` straight after the command prefix gets a leading
  twin wherever its match can come first (`gh api -X DELETE`), since that `*` doesn't match empty;
  `aws *delete*` needs none, as a service name always fills it. Residuals: variable-built commands,
  other flag orders, graphql queries read from a file (`-F query=@file`), and SDK scripts (boto3)
  bypass these patterns, accepted per the accidents-only threat model; `gh api -X PATCH` can still
  archive a repo or change its visibility, left to the classifier because a pattern on `visibility`
  would also block reads; routine dev deletes (`aws sqs delete-message`) run via `!`; the terraform
  destroy rules also block harmless commands naming `destroy` (`plan -destroy`,
  `plan -out destroy.tfplan`)
- Accepted tradeoffs and residuals: github-only egress for `just test` plugin fetches (non-github
  egress via `git fetch <url>` or in-tree `insteadOf` accepted per the threat model); nvim data-dir
  writes apply globally; Linux deploys need bubblewrap + socat under `failIfUnavailable: true`; the
  text-match denies over-block benign mentions (`app.env`, a commit message containing " dumps ");
  history-destroying commands (`reflog expire`, `gc --prune`, `update-ref -d`) are unguarded: they
  lose only local, unpushed work and take a deliberate multi-step sequence; `git mv -f` can
  overwrite one untracked destination file, left unguarded for the same reason; the collision-prone
  `*.pem`/`*.key`/`*id_rsa*`/`.netrc`/`.npmrc` family is left out at user scope; recursive `rm`
  clusters the denies don't spell (`-vfr`, `-dr`, `-ir`) and wrapped forms (`xargs rm -r`) run
  unprompted. All narrow and contained while the sandbox is active
- **Local destruction is fine only when recoverable or asked for**: committed work (recoverable via
  reflog) may be reset or rebased; uncommitted edits and untracked files are the user's, and Claude
  discards them only when asked. That is a CLAUDE.md `## Safety` rule, not a permission rule: the
  discard forms (`reset --hard`, `checkout`/`restore` of a path or the tree, `checkout -f`,
  `switch --discard-changes`, `stash drop`) match no rule and run sandboxed, so sandbox auto-allow
  approves them and the classifier sees them only on an unsandboxed retry. Accepted because small
  frequent commits bound the loss, and a dropped stash stays recoverable through `git fsck` until
  gc. The same Safety section says to stop at the first denial from any source and raise it rather
  than work around it, since a denial is either a config bug or a real edge case. `git clean` and
  the forced `worktree remove` stay `deny`: they delete untracked and ignored files git never held.
  Plain `worktree remove` deletes only ignored files (build output, local overrides) and runs
  unprompted, so Claude can clean up its own worktrees
- **Local history operations have no verb-level `allow`** (`merge`, `rebase`, `cherry-pick`,
  `revert`, and `pull`, which merges): they are `excludedCommands` for GPG signing, so they run
  unsandboxed and the auto-mode classifier reviews each, as it does their `--abort`/`--skip` and
  `git -C *` forms; an `allow` would skip that review. In-repo hooks and merge drivers they trigger
  run outside the sandbox as hooks already do for `git commit`. The flags that name a command to run
  (`rebase --exec`, `push --receive-pack`/`--exec`, `fetch`/`pull --upload-pack`) and the commands
  that repoint a remote (`git remote add`/`set-url`, `git config` URL and hook keys) have no rule: a
  command Claude names there (`git rebase -x 'just test'`) runs unsandboxed under classifier review
  like any other unsandboxed command, and the injected forms are attacker-only, which the threat
  model leaves to the classifier and to the sandbox's `.git/config` and `~/.gitconfig` write denies
- **`git commit` is allowed** (unlike the history verbs): commits are local and reversible, and the
  classifier sees only `git commit -m …`, not the hooks it triggers, so its review adds little. The
  real exposure is the commit's pre-commit hooks running unsandboxed from an in-tree config, so
  `Edit(~/**/.pre-commit-config.yaml)` write-protects that config in every repo (merged into the
  sandbox, so Bash writes too; wildcard, so macOS-only). Residual: a `repo: local` hook's in-tree
  script, or a config that lives elsewhere (this repo's `.githooks` is already `denyWrite`)
- **Plain `rm` runs unprompted** (sandboxed, auto-allowed): the sandbox bounds it to its write set,
  and git restores tracked files; losing an untracked file is the accepted cost of not prompting on
  every temp-file cleanup. Recursive `rm` is `deny` in its common spellings (`-r`, `-R`,
  `--recursive`, `-fr`, `-fR`, in leading or later position). `find -delete` is `deny` for the same
  reason; `find -exec rm`, `xargs rm -r` and `rsync --delete` are accepted residuals: rare, and
  bounded by the sandbox's write set. `dd` and `rsync` otherwise have no rule
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
  `products` table or bucket in the same command is denied, as is any non-AWS tool with a
  `--profile` flag (`cargo build --profile release -p products`); relax them if that friction shows
  up. Uppercase names, profiles set in a separate shell step, credential wrappers that take the
  profile as a plain argument (`aws-vault exec prod`), and SDK use are left to the classifier.
  `git tag -s` and bare `gpg` under the sandbox are the documented over-block
- **Customer data stays out of context**: `dumps/` is `deny` for Read (which also lands in the
  sandbox read-deny) and by Bash command text. Residual: in a repo with a legitimate `dumps`
  directory, sandboxed tools that walk it (`git status`, builds) fail there. Datadog log, trace,
  span and RUM MCP tools are `ask`: they return customer personal information, while metrics and
  monitors stay unprompted. The name globs (`mcp__*atadog*__*log*`) cover both the connector and the
  plugin server, and over-match any config tool sharing those words. Transcript retention stays at
  the default: one cleanup sweeps every project's transcripts, so a per-repo `cleanupPeriodDays`
  can't scope it. Scanning prompts and edits for personal identifiers belongs in each work repo's
  hooks, where the identifier formats are known. Alternatives: deny `*.log` reads (rejected: blocks
  local build and test output); deny `~/Downloads` (rejected: files there are handed over on
  purpose)

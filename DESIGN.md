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
  `bash`, so it doesn't depend on the file's execute bit
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
must-nevers in deny rules. Budget: about 80 always-loaded lines.

- `CLAUDE.md`: environment, communication, persistence, safety prose not enforced elsewhere. No
  thinking keywords or session discipline. In this repo, touching a file under `claude/` loads
  `claude/CLAUDE.md` a second time as a nested CLAUDE.md (about 1k tokens, once per session).
  Accepted: `~/.claude/CLAUDE.md` links to the same file, so a `claudeMdExcludes` pattern for it may
  also drop the user CLAUDE.md, silently, in every session here
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
- Hooks: `worktree-create.sh` only (places every worktree, including subagents', flat under
  `~/code/worktrees/`, branched off the remote's default branch, instead of the repo's
  `.claude/worktrees`). Formatting and lint are enforced by each repo's own pre-commit hook; a
  project PostToolUse lint hook only shortens feedback (see "Formatting enforced at commit")
- Background sessions keep Claude Code's worktree guard (`worktree.bgIsolation` unset): Edit and
  Write are refused in the main checkout until `EnterWorktree`, so parallel jobs never share a
  working copy, and git commands that target another checkout (including `!` commands) are refused
  too, so commits land on `main` by the worktree rule in `claude/rules/git.md`. In a
  worktree-isolated session the guard also refuses a Bash call whose git target it can't verify: a
  `cd` or computed path before git, or a script whose text names git (seen live). Rejected:
  `"bgIsolation": "none"` for this direct-to-`main` repo, which puts every background job in one
  working copy. The guard covers file tools only; Bash can still write to `~/.dotfiles`
- Settings: see "Claude Code permissions" below
- Claude's temp dirs (`/tmp/claude-<uid>`, which is `$TMPDIR`) are allowed without naming the uid:
  `Read` on `//private/tmp/claude-*/**` and `//tmp/claude-*/**`, `Edit` only on their direct
  children (`/*`), where scratch files go. Both spellings are needed because macOS `/tmp` is a
  symlink and an allow rule matches only when the requested and the resolved path both match. Edit
  stays shallow so it can't reach the harness's task output under `<project>/<session>/tasks/`.
  `claude-*` matches other users' dirs too, accepted on a single-user machine (they are
  `drwx------`)
- The file tools' `Read` in `~/.claude` is an allowlist, not a broad allow with denies: the
  directory also holds key files, transcripts, prompt and paste history and file snapshots, and
  Claude Code adds new state directories over time, so a denylist fails open. The config directories
  (`skills`, `agents`, `rules`, `hooks`, `commands`, `docs`) and the top-level `CLAUDE.md` and
  `settings.json` hold symlinks into `~/.dotfiles/claude/`, so each needs `~/.dotfiles/claude/**` as
  well, for the resolved path. Memory (`projects/*/memory/**`) and `plans/**` are real directories.
  Everything else in `~/.claude` prompts. This gates the file tools only; Bash reads are left to the
  classifier
- Work-only config (Jira, acli, jdtls-lombok) lives under `tag-work/`, enabled only on the work
  machine, so rcm never links it here

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
  neither `permissions` nor the classifier - the largest trust-boundary widening available here for
  the smallest benefit); putting the ruleset in `claude/CLAUDE.md` (rejected: ~1.4k tokens on every
  session, coding or not); pinning the marketplace to a tag (rejected with the plugin; upstream tags
  trailed `main` by 53 commits when evaluated, worse than tracking the branch)
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

**Claude Code permissions: auto mode, hard denies, one human gate:**

- **Model**: the auto-mode classifier judges every action no rule settles; `deny` holds the
  irreversible and the credential- or customer-data-exposing; `ask` gates config that steers or runs
  code in future sessions, and publish steps; `allow` only skips classifier latency on read-only
  commands. Jira and Confluence writes are not allowed: an allowed tool never reaches the
  classifier, so the personal-information line couldn't stop a customer record pasted into a ticket.
  The checks and the project baseline live in `claude/skills/claude-permissions/` (`invariants.md`,
  `project-baseline.json`, `user-baseline.json`); `/claude-permissions setup` applies the project
  one to a repo and `/claude-permissions user` the user one to a teammate's settings. Allows live
  only in the user baseline: tool names differ per person's connectors and CLIs, and a project allow
  can't be routed back to the classifier, since a teammate can only override it with `ask` or `deny`
- **No OS sandbox.** Its two jobs are fewer prompts without a classifier (redundant under auto mode)
  and containment that holds when the model is fooled. The second costs too much for this workflow:
  the credentials it walls off (`~/.aws` SSO, SSH and GPG for git, `gh`) are the ones routine
  commands need, so every git, gh and aws call needed an exclusion, a lone-call rule, a hook or a
  `!` hand-off. Accepted residual: deny rules match Claude's file tools and command text, not what a
  program opens, so a script reading `~/.aws` or `.envrc` is judged only by the classifier.
  Mitigated by short-lived SSO credentials, agent-held keys, no secrets in repos, and
  `autoMode.environment` lines naming credential reads and personal information. Claude Code doesn't
  unset exported tokens, so keep them out of the environment it starts in. Revisit for unattended or
  untrusted-code work, where containment earns its friction
- **No enforcement hooks.** `Read` denies cover the file tools; Bash denies cover the common
  spellings; the classifier covers the rest. Hooks that parse Bash are fragile and duplicate rules.
  `worktree-create.sh` stays as a convenience
- **Hard denies** (user scope, and the subset every repo needs in `project-baseline.json`):
    - Secret files by `Read` path, by path in command text (`*/.env*`, `*/.aws/*`, `*/.netrc*`), by
      the common file-reading verbs (`cat`, `head`, `tail`, `less`, `source`, `cp` on `*.env*`; `cp`
      because a copy under another name escapes every other rule) and by search and edit tools
      (`grep`, `sed`, `awk`) with a space before `.env`, so a pattern like `process.env` still
      passes. Not a bare `* .env*`, which also matched commit messages and search patterns; a commit
      message that names a secret path goes through `git commit -F <file>`. Personal tools (`rg`,
      `bat`) get the same rules at user scope only. User-scope path rules are anchored `~/**/`:
      measured, a user-scope `**/` rule matches only under the session's project, not in additional
      directories. A tree-wide search that never names the file falls to the classifier
    - Also denied: `export-credentials` in any form, `git commit -F` of a `.env` file (the commit
      allow skips the classifier), force/delete/mirror/prune pushes and `git -C * push`,
      `--no-verify`, `git clean`, recursive `rm`, `find -delete`, forced worktree removal, `sudo`,
      `direnv`, gh/terraform/aws verbs that destroy remote state, Atlassian `executeDestructive`,
      and `dumps/` (customer data, as `*/dumps/*` and `* dumps/*` so the repo-relative spelling
      matches)
    - Bash patterns are a backstop for the common spelling, not a boundary; variable-built commands,
      other flag orders and SDK scripts fall to the classifier
- **Asks**: edits to `CLAUDE.md`, `CLAUDE.local.md`, `.claude/` settings, hooks, skills, agents,
  commands and rules, `.mcp.json`, `.pre-commit-config.yaml`, `.githooks/` and
  `~/.dotfiles/claude/`, plus this repo's `justfile` and `scripts/` (the pre-commit hook runs
  `just check`): these run or instruct every future session, and `git commit` is allowed, so a hook
  edit would run on the next commit unjudged (`.git/hooks` and `.git/config` are built-in protected,
  so the classifier judges writes there; `git config` setting `core.hooksPath` or `core.fsmonitor`
  is a command, not a file write, so it asks too). A persisted injection or a one-session workaround
  turned rule needs a human to see it. Spelled per directory, not `**/.claude/**`, so auto-memory
  stays a free write. Production and pre-production AWS profiles (`prd`, `prod`, `ppe`, matched by
  command text and over-matching `products` and words like `mapper` on purpose): reads there are
  sometimes needed, the delete and destroy denies still hold on every profile, and any other write
  on such a profile passes only if the user approves the prompt; repos whose cloud data matters add
  their own write-verb denies. Publish steps: `terraform apply`, `just deploy`; repos add
  `gh pr create` where the PR is the review gate. Residual: a Bash write to a gated file goes to the
  classifier
- **`autoMode.environment`** says where production and personal information live (production AWS
  profiles; production DynamoDB, DLQs, Kinesis and dumps; POPIA personal-information fields) and
  that reading credential files is credential access. Logs, traces and RUM carry no personal
  information by design, so they are routine debugging sources. Read from user scope only, so each
  contributor sets their own
- **Scopes**: user scope holds my posture everywhere (mode, `autoMode`, the full deny list, read
  allows, config asks). Project `.claude/settings.json` holds the shared baseline plus the repo's
  own rules (its cloud CLI's mutation verbs, data-store asks, publish gates), so a teammate with no
  user config still can't make a severe mistake there; duplicating user denies is harmless since
  deny merges. Never in project scope: `sandbox` (a project `enabled` overrides the user value),
  `defaultMode`/`autoMode` (ignored), `allow` (pre-approves for every teammate). Machine paths go in
  `settings.local.json`
- **Local destruction is fine only when recoverable or asked for**: a CLAUDE.md `## Safety` rule,
  since the discard forms (`reset --hard`, `checkout .`, `stash drop`) have legitimate uses; the
  classifier sees them
- **`git commit` and worktree cleanup are allowed**: local and reversible, and the classifier sees
  only the command, not the hooks it triggers. The pre-commit config that would make a commit run
  new code is behind the config ask

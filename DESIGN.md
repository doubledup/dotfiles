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
- Standing policy it encodes: **security-related guardrails get belt-and-suspenders across all
  three layers, and this trumps CLAUDE.md minimalism (for now)**; non-security rules follow the
  minimalism default (CLAUDE.md carries principles, not every mechanical rule)
- Alternative considered: a declarative policy-registry file (rejected: another artifact to keep
  current, against the minimalism principle; invariants derive intent from the live config)

**Bash sandbox (macOS Seatbelt):**

- Claude Code's OS-level Bash sandbox is enabled strictly (`enabled`, `failIfUnavailable: true`,
  `allowUnsandboxedCommands: false`) so `deny` rules actually bind Bash - the third enforcement
  leg alongside settings denies and the guard hook. Without it, a bare `deny` binds only built-in
  tools, so `cat ~/.env` via Bash bypasses the secret Read-denies entirely
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
  fetches, a data-exfiltration surface the docs flag - acceptable because `git push` is denied and
  this is a solo machine; `filesystem.allowWrite` for the nvim data dirs applies globally (the
  user's own editor state); the config deploys via rcm to Linux too, where the sandbox backend
  (bubblewrap + socat) is a prerequisite since `failIfUnavailable: true` hard-fails without it
- Residual gap (tracked in BACKLOG): the sandbox's prefix `denyRead` cannot express arbitrary-depth
  repo-relative secrets, so `cat ./.env` / `cat secrets/x` stay open until the guard hook gains a
  Bash-read block. Alternative considered: `autoAllowBashIfSandboxed: true` for the documented
  ~84% prompt reduction (deferred: kept `false` so the existing permission-prompt UX is unchanged
  and the sandbox is purely additive enforcement for now)

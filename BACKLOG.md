# Backlog

Single tracker for this repo. Sections are by area, not priority; the Next list holds what is
actually up next (keep it to ~5 items). Items are one line: what, and why if not obvious. Remove
items when done; git history records completion.

## Next

- Claude Code: verify whether `!` commands run inside the Bash sandbox. `claude/CLAUDE.md` Safety
  says to run sandbox-blocked maintenance via `!`, but `just fmt` via `!` hit the same EPERM on
  `claude/CLAUDE.md` as sandboxed Bash did, on a plain 644 file. Test in a fresh session, then
  correct the rule if the claim is wrong
- Claude Code: verify the new local-git-ops rules in a fresh session, then remove this item:
  `git merge --abort` prompts (ask beats allow), `git rebase -x 'echo p' --bogus-flag` is denied,
  `git worktree remove -f x --bogus-flag` is denied, `git merge --no-ff --no-commit HEAD` and
  `git worktree list` run unprompted
- Claude Code: minimize our configuration. Start with config to enforce this while editing config,
  then use it in a fresh session to do the minimization. Consider ponytail
- Repo-wide ASCII/em-dash sweep across first-party files (bootstrap.md, peer-review.md, reviewer.md,
  jira-comment.md, claude-permissions SKILL.md + invariants.md, gh-api-readonly.sh); consider a
  typos/lint rule so it stays fixed
- Remove Nix configuration (`config/nix/`); Nix is no longer in use

## Claude Code

- Create an /explain workflow
- Add config so that when we find friction from our permissions, we update them to remove it
- Config to exclude references to current repo state (e.g. `claude-permissions/invariants.md`
  "Atlassian ask rules"), then run it to remove existing references
- Run only fast commands (format, lint, relevant unit tests) on each commit; a hook?
- Allow rm in /var/
- Restrict dangerous CLI tools: awk (system(), file writes), sed (GNU e command, file writes), less
  (shell escape, LESSOPEN exec), sort (file writes via -o)
- Consider adding obsidian-cli `daily:path`/`daily:read` to the project allow list in
  `.claude/settings.json` once verified that reading today's daily note doesn't auto-create it
- `guard.sh`'s Grep/Glob secret-path block only fires when `path` targets or is nested inside a
  secret; a broad Grep (`path: "."` or omitted) that incidentally returns lines from a secret file
  is not caught. A PreToolUse hook cannot filter output. Mirrors the sandbox residual-gap note in
  DESIGN.md
- Review project-level permissions in `.claude/settings.json`: only `just check` is allowed.
  Consider `just test`, `just fmt`, `just todos`, and other safe recipes
- Allow fetching PR comments in `claude/hooks/gh-api-readonly.sh`
- Give `claude/hooks/gh-api-readonly.sh` a `timeout` in settings.json and a test in `rcignore/` (the
  other two hooks have both; this is the most parsing-heavy)
- `gh-api-readonly.sh` checks that the token right after `gh` is `api`; `gh --repo owner/x api ...`
  slips past. Apply the same tolerant matching as the git -C fix if it turns out to matter
- Document or relocate the jdtls-lombok-lsp shim under `claude/skills/`: no SKILL.md, hardcodes an
  Amazon Corretto 21 path and Lombok 1.18.42, official jdtls plugin disabled in its favor; recorded
  nowhere in DESIGN.md
- Move work-specific config out of global `claude/`: `jira-comment.md` hardcodes
  `sft.atlassian.net`, `acli-guide.md` references `GLUE`. Consider `tag-work/` or parameterization
- Investigate adversarial verification (agents trying to refute a finding), multi-modal search
  sweeps, judge panels, and loop-until-dry for Claude config, vs ultra code review
- Split review agent into review-spec and review-plan; fold final mode into
  review-{correctness,performance,security,style}
- Update `/feature` to integrate with `execution.md`: Phase 3 lacks commit discipline and rollback
  protocol; Phase 4 has a conflicting 3-cycle limit (execution.md uses 6)
- Rename spec in review agent and feature command (consider "problem-definition")
- Automated post-update review: last step of `just update` runs `claude` to review package updates
  for deprecations and breaking changes, audit inline TODOs, spot-check config consistency. Needs
  design work on the prompt and invocation
- Set up and try in tmux
- Run `just ponytail-diff` periodically; read the diff before copying upstream changes into the
  vendored skill, then update the commit and sha256 in `claude/skills/ponytail/VENDOR.md`
- Vendor `ponytail-review` (audits a diff for over-engineering) once the core skill has earned its
  place; fits the existing review-loop workflow
- Vendor `ponytail-debt` (harvests deferred shortcuts) only once `ponytail:` marker comments exist
  in a repo
- Vendor `ponytail-audit` (full-repo over-engineering audit) if a specific repo needs one
- Upstream also ships `ponytail-gain` and `ponytail-help`; deliberately not vendored

## Neovim

- JDTLS: complete the nvim-jdtls setup. Audit correctness and configurability: autobuild disabled
  (TODO about Maven coordination), JDK version hardcoded to 25, inlay hints disabled, workspace
  isolation edge cases, Lombok version pinned manually. Consider debug adapter, test runner,
  `.java-version` support, telescope/fzf integration; read `:h jdtls`
- Telescope trial: currently on fzf. When trying telescope, run it as a trial with a clean path back
  to fzf. Blocked on the trial: fzf history file (`--history ~/.local/share/fzf/fzf_history`),
  telescope for LSP results, frizbee-based fzf alternative
- Add localleader (`vim.g.maplocalleader = "'"`) next to leader; use for LSP/language-specific
  bindings
- Audit filetype tooling coverage: LSP server, formatter, and linter per supported filetype. Known
  gaps: fish (no LSP; fish-lsp in Brewfile), javascript/typescript (no LSP), css (no LSP), markdown
  (no LSP or linter), java (no linter; checkstyle/PMD candidates). Build the matrix, fill gaps,
  document target state
- Treesitter grammars for all filetypes (is there a justfile grammar?)
- Audit lazy loading: which plugins load eagerly vs on event/ft/keys/cmd; benchmark with
  `:Lazy profile`; define conventions. Check VeryLazy in particular
- Review lazy.nvim docs against our practices; create backlog items for misalignment
- Periodic scan for major version bumps on pinned plugins (LuaSnip, blink.cmp, fidget.nvim,
  hop.nvim, nvim-tree.lua); lazy.nvim doesn't detect a new major beyond the pinned range
- Try MasonToolsUpdateSync as a `build` step in mason-tool-installer's spec so Mason updates tools
  during Lazy sync (like treesitter with TSUpdate)
- Fix roc.vim warning in `just test`: "Lua module not found for config of roc.vim"
- Extract init.lua inline configs (hop, mouse, terminal autocmds, wildmenu) to proper homes
- Treesitter-based folding instead of `foldmethod=indent`
- which-key group labels for leader groups
- Persistent undo history
- Set up DAP
- `<c-q>` to expand visual selection based on AST
- Indent and entire-document objects for wellle/targets.vim
- Use nvim for git diff?
- LSP hover doc: dismiss with esc, scroll with c-f/c-b, reduce hidden text whitespace
- LSP text objects for functions and classes; targeted code actions; range selection; management
  commands (restart, logs)
- Buffer deletion from fzf buffer picker
- Dismiss gitsigns inline diff (currently using kj workaround)
- Resize help window to 80 chars after opening
- `gf`: relative paths relative to current file; expand `~` to `$HOME`
- Lualine tab padding inconsistency when first tab is active
- Colorful-menu.nvim for completion highlighting
- LuaSnip snippet engine
- blink.cmp: terminal completion, community sources
- vim-slime: choose from active terminals via `b:terminal_job_id`
- Fix "Too many nodes but not enough keys!" in mizlan/iswap.nvim; contribute multiple keys?
- Disable `<leader>rwp` in powerman/vim-plugin-AnsiEsc
- hop across windows when they show the same buffer with overlapping lines
- Keybinding design: map keys to intents and intents to actions; crib from
  [LazyVim keymaps](https://www.lazyvim.org/keymaps) and [plugins](https://www.lazyvim.org/plugins)
- Deprecation warning capture in headless nvim test
- Contribute base64/hex/octal/binary conversions to vim-unimpaired

## Shell, terminal, tooling

- Shortcut (fish or karabiner) for opening Obsidian notes (todo/daily; vault path per machine) and
  BACKLOG.md, for quick capture
- Remove references to Ghostty
- Audit cargo-installed packages in `just update`: speedtest and zeitfetch are general CLI tools
  that belong in Brewfile if available
- `just doctor` for periodic checks: `~/.Brewfile.local` packages to move to `~/.Brewfile`, pinned
  neovim packages to bump
- `just stale-links`: like `just broken-links` but detects links into the dotfiles repo and can
  remove them
- XCode update progress in `just update`: restructure for `mas` visibility while keeping sudo last
- Check that setup.sh is idempotent; review and streamline new-machine bootstrapping
- fishtape for fish function testing
- Fish: pass previous last arg to a different command (keybinding)
- Fish: separate ignore-vcs bindings for fzf cd shortcut
- Kitty: splits layout; ad-hoc vertical/horizontal splits
- Kitty: try `tab_bar_filter session:~` to scope the tab bar to the current session
- noise-toggle fade in/out
- Backup Vimium options
- Review firefox privacy plugins

## Reading

- https://cmp.saghen.dev/
- https://github.com/neovim/nvim-lspconfig
- https://github.com/mason-org/mason.nvim
- https://github.com/mason-org/mason-lspconfig.nvim
- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
- https://github.com/j-hui/fidget.nvim
- `:h ins-completion`, `:h initialization`, `:h exrc`, `:h lsp-vs-treesitter`, `:h CursorHold`,
  `:h vim.diagnostic.Opts`

## Someday: new tools

### General

- [kanata](https://github.com/jtroo/kanata) - keyboard remapping
- [warpd](https://github.com/rvaiya/warpd) - keyboard-driven mouse
- [Talon](https://talonvoice.com/docs/) - voice control
- [atuin](https://github.com/atuinsh/atuin) - shell history
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) - tiling window manager
- [starship](https://github.com/starship/starship) - cross-shell prompt
- [yazi](https://github.com/sxyazi/yazi) - terminal file manager
- [Fennel](https://fennel-lang.org/) - Lua-based Lisp
- [nvimpager](https://github.com/lucc/nvimpager) - neovim as pager
- [kinto](https://github.com/rbreaves/kinto) - keyboard mapping for Linux
- [aichat](https://github.com/sigoden/aichat) - AI chat

### Neovim plugins

- [harpoon2](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) - quick file navigation
- [claudecode.nvim](https://github.com/coder/claudecode.nvim) - Claude Code integration
- [codecompanion.nvim](https://codecompanion.olimorris.dev/) - AI chat
- [mcphub.nvim](https://github.com/ravitemer/mcphub.nvim) - MCP integration
- [snacks.nvim](https://github.com/folke/snacks.nvim) - QoL plugin collection
- [neorg](https://github.com/nvim-neorg/neorg) - note-taking / organization
- [vimagit](https://github.com/jreybert/vimagit) - git workflow
- [vim-git](https://github.com/tpope/vim-git) - git filetype support
- [octo.nvim](https://github.com/pwntester/octo.nvim) - GitHub integration
- [vim-markdown](https://github.com/preservim/vim-markdown) - markdown support
- [elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim) - Elixir support
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - fuzzy finder (see Neovim
  telescope trial)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - indent guides
  (see [scope](https://github.com/lukas-reineke/indent-blankline.nvim?tab=readme-ov-file#scope))
- [trouble.nvim](https://github.com/folke/trouble.nvim) - diagnostics list
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - debug adapter protocol
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - TODO highlighting
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - markdown preview
- [vim-rsi](https://github.com/tpope/vim-rsi) - readline-style insert mode
- [undotree](https://github.com/mbbill/undotree) - undo history visualizer
- [central.vim](https://github.com/her/central.vim) - centralized backup/swap/undo
- [vim-dispatch](https://github.com/tpope/vim-dispatch) - async build/test
- [vim-test](https://github.com/janko-m/vim-test) - test runner
- [projectionist](https://github.com/tpope/projectionist) - project-aware navigation
- [nvim-magic](https://github.com/jameshiew/nvim-magic) - AI code generation
- [rest.nvim](https://github.com/rest-nvim/rest.nvim) - HTTP client
- [vim-textobj-entire](https://github.com/kana/vim-textobj-entire) - entire buffer text object
- [vim-textobj-user](https://github.com/kana/vim-textobj-user) - custom text objects
- [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object) - indent text object
- [vim-afterimage](https://github.com/tpope/vim-afterimage) - edit non-text files
- [vim-eunuch](https://github.com/tpope/vim-eunuch) - Unix commands
- [minimap.vim](https://github.com/wfxr/minimap.vim) - code minimap
- [previm](https://github.com/kannokanno/previm) - markdown preview
- [filetype.nvim](https://github.com/nathom/filetype.nvim) - faster filetype detection
- [blamer.nvim](https://github.com/APZelos/blamer.nvim) - inline git blame
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) - git blame
- [gundo.vim](https://github.com/sjl/gundo.vim) - undo tree
- [FastFold](https://github.com/Konfekt/FastFold) - faster folding
- [oil.nvim](https://github.com/stevearc/oil.nvim) - keyboard-first file explorer (directories as
  editable buffers); fits keyboard-first philosophy better than nvim-tree

# Backlog

## Fixes

## Low-hanging fruit

- Fix roc.vim warning in `just test`: "Lua module not found for config of roc.vim. Please use a `config()` function instead"
- Treesitter-based folding: switch from `foldmethod=indent` to treesitter foldexpr. Free since 56 parsers are already loaded.
- which-key group labels: loaded but no group registrations. Adding labels for leader groups would improve discoverability.
- Claude Code: permit `find` without destructive flags in permissions, but without `-exec` or other destructive flags/operations
- Claude Code: allow fetching PR comments in `claude/hooks/gh-api-readonly.sh`
- Claude Code: restrict dangerous CLI tools: awk (system(), file writes), sed (GNU e command, file writes), less (interactive shell escape, LESSOPEN env exec), sort (file writes via -o)
- Audit cargo-installed packages in `just update`: speedtest and zeitfetch are general CLI tools that belong in Brewfile if available via Homebrew. Move non-Rust-tooling packages per Homebrew-for-CLI-tools convention.
- LSP hover doc improvements: dismiss with esc, scroll with c-f/c-b, reduce hidden text whitespace
- Buffer deletion from fzf buffer picker
- Dismiss gitsigns inline diff (currently using kj workaround)
- Resize help window to 80 chars after opening
- Expand `gf` to interpret relative paths as relative to current file
- Expand `gf` to expand `~` to `$HOME`

## High impact

- Detect breaking nvim plugin updates before they land: mason-lspconfig silently dropped `handlers` in v2.0, nvim-treesitter changed branch conventions (fixed in ad683ad). Both went unnoticed until config stopped working. Need a process or tooling: pinning risky plugins with `version = "^N.0"`, reviewing changelogs before updating lazy-lock.json, or running config validation after updates.
- Audit filetype tooling coverage: ensure each supported filetype has an LSP server, formatter, and linter. Known gaps: fish (no LSP, fish-lsp in Brewfile), javascript/typescript (no LSP), css (no LSP), markdown (no LSP or linter), java (no linter, checkstyle/PMD candidates). Build the matrix, fill the gaps, document the target state.
- Review JDTLS configuration: Java is a primary language. Audit correctness and configurability: autobuild disabled (TODO about Maven coordination), JDK version hardcoded to 25, inlay hints disabled, workspace isolation edge cases, Lombok version pinned manually. Consider debug adapter, test runner, `.java-version` support.
- Automated post-update Claude review: make the last step of `just update` run `claude` to review recent package updates for deprecation warnings and breaking changes, audit inline TODOs, and spot-check config consistency. Needs design work on the prompt and Claude Code invocation.
- Extract init.lua inline configs: hop config, mouse settings, terminal autocmds, wildmenu are mixed into init.lua (126 lines of mixed concerns). Move to proper homes.
- Claude Code: split review agent into review-spec and review-plan. Incorporate final mode into review-{correctness,performance,security,style}.

## Other

- Consider oil.nvim: keyboard-first file explorer, directories as editable buffers. Fits keyboard-first philosophy better than nvim-tree.
- noise-toggle fade in/out
- Claude Code: rename spec in review agent and feature command (consider "problem-definition")
- XCode update progress in `just update`: Homebrew shows no progress bar for XCode upgrades. Restructure for `mas` visibility while keeping sudo at the end.
- Check that setup.sh is idempotent
- Deprecation warning capture in headless nvim test
- fishtape for fish function testing
- LSP text objects for functions and classes
- LSP targeted code actions
- LSP range selection
- LSP management commands (restart, logs, etc.)
- Contribute base64/hex/octal/binary conversions to vim-unimpaired
- Lualine tab padding inconsistency when first tab is active
- Colorful-menu.nvim for completion highlighting
- LuaSnip snippet engine
- Terminal completion in blink.cmp
- Community sources for blink.cmp
- vim-slime: choose from active terminals via `b:terminal_job_id`
- JDTLS: set up inlay hints
- JDTLS: add telescope/fzf integration
- JDTLS: read `:h jdtls` for additional configuration
- Fish: pass previous last arg to different command (keybinding)
- Fish: separate ignore-vcs bindings for fzf cd shortcut
- Kitty: set up splits layout

## New tools

### General

- [kanata](https://github.com/jtroo/kanata) — keyboard remapping
- [warpd](https://github.com/rvaiya/warpd) — keyboard-driven mouse
- [Talon](https://talonvoice.com/docs/) — voice control
- [atuin](https://github.com/atuinsh/atuin) — shell history
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) — tiling window manager
- [starship](https://github.com/starship/starship) — cross-shell prompt
- [yazi](https://github.com/sxyazi/yazi) — terminal file manager
- [Fennel](https://fennel-lang.org/) — Lua-based Lisp
- [nvimpager](https://github.com/lucc/nvimpager) — neovim as pager
- [kinto](https://github.com/rbreaves/kinto) — keyboard mapping for Linux

### Neovim plugins

- [harpoon2](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) — quick file navigation
- [neorg](https://github.com/nvim-neorg/neorg) — note-taking / organization
- [vimagit](https://github.com/jreybert/vimagit) — git workflow
- [vim-git](https://github.com/tpope/vim-git) — git filetype support
- [octo.nvim](https://github.com/pwntester/octo.nvim) — GitHub integration
- [vim-markdown](https://github.com/preservim/vim-markdown) — markdown support
- [elixir-tools.nvim](https://github.com/elixir-tools/elixir-tools.nvim) — Elixir support
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) — fuzzy finder
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) — indent guides (see [scope](https://github.com/lukas-reineke/indent-blankline.nvim?tab=readme-ov-file#scope))
- [trouble.nvim](https://github.com/folke/trouble.nvim) — diagnostics list
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — debug adapter protocol
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) — TODO highlighting
- [aichat](https://github.com/sigoden/aichat) — AI chat
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) — markdown preview
- [vim-rsi](https://github.com/tpope/vim-rsi) — readline-style insert mode
- [undotree](https://github.com/mbbill/undotree) — undo history visualizer
- [central.vim](https://github.com/her/central.vim) — centralized backup/swap/undo
- [vim-dispatch](https://github.com/tpope/vim-dispatch) — async build/test
- [vim-test](https://github.com/janko-m/vim-test) — test runner
- [projectionist](https://github.com/tpope/projectionist) — project-aware navigation
- [nvim-magic](https://github.com/jameshiew/nvim-magic) — AI code generation
- [rest.nvim](https://github.com/rest-nvim/rest.nvim) — HTTP client
- [vim-textobj-entire](https://github.com/kana/vim-textobj-entire) — entire buffer text object
- [vim-textobj-user](https://github.com/kana/vim-textobj-user) — custom text objects
- [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object) — indent text object
- [vim-afterimage](https://github.com/tpope/vim-afterimage) — edit non-text files
- [vim-eunuch](https://github.com/tpope/vim-eunuch) — Unix commands
- [minimap.vim](https://github.com/wfxr/minimap.vim) — code minimap
- [previm](https://github.com/kannokanno/previm) — markdown preview
- [filetype.nvim](https://github.com/nathom/filetype.nvim) — faster filetype detection
- [blamer.nvim](https://github.com/APZelos/blamer.nvim) — inline git blame
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) — git blame
- [gundo.vim](https://github.com/sjl/gundo.vim) — undo tree
- [FastFold](https://github.com/Konfekt/FastFold) — faster folding
- [oil.nvim](https://github.com/stevearc/oil.nvim) — keyboard-first file explorer (directories as editable buffers)

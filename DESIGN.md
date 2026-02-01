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

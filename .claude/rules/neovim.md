---
paths:
    - "config/nvim/**"
    - "tag-*/config/nvim/**"
---

Pure Lua only -- no vimscript in neovim configuration.

Plugin size thresholds:

- <=20 lines: keep in `plugins/init.lua`
- > 20 lines: separate file in `plugins/`, named after the plugin repo (e.g.,
  > `nvim-lint.lua` for `mfussenegger/nvim-lint`)

Plugin docs: https://github.com/{user}/{repo}

Test config loads: `nvim --headless -c 'quit'`

Plugin versions:

- Default to tracking each repo's default branch (no `version` constraint)
- Only pin when the plugin's own docs recommend it

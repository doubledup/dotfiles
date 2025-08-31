-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

--  NOTE: map leader key before plugins are required, else wrong leader will be used
vim.g.mapleader = " "

-- nvim-tree: disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- slime: disable default mappings: must run before slime loads
vim.g.slime_no_mappings = 1

-- set termguicolors here for norcalli/nvim-colorizer.lua
vim.o.termguicolors = true

vim.keymap.set("n", "<leader>p", ":Lazy<cr>", { desc = "Open lazy.nvim menu" })

-- Load configuration modules
require("lazy").setup({
    spec = { import = "plugins" },
})

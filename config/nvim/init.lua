require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- filetype
vim.filetype.add({
    extension = {
        avsc = "json",
        prettierrc = "jsonc",
    },
    filename = {
        ["coc-settings.json"] = "jsonc",
        ["tsconfig.json"] = "jsonc",
    },
})

-- hop
local hop = require("hop")
local directions = require("hop.hint").HintDirection

vim.keymap.set("n", "s", function()
    hop.hint_char2()
end, { desc = "Hop to 2 characters" })

vim.keymap.set("v", "s", function()
    hop.hint_char2({ inclusive_jump = true })
end, { desc = "Hop to 2 characters (inclusive)" })

vim.keymap.set("o", "z", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { desc = "Hop forward on line", remap = true })

vim.keymap.set("o", "Z", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Hop backward on line", remap = true })

-- mouse
vim.g.mousescroll = "hor:1"
vim.keymap.set("n", "<ScrollWheelUp>", "<c-y>")
vim.keymap.set("n", "<ScrollWheelDown>", "<c-e>")

-- neovide
if vim.g.neovide then
    vim.o.guifont = "Hack Nerd Font:h14"
    vim.g.neovide_scroll_animation_length = 0.2
    -- vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_refresh_rate_idle = 1
    vim.g.neovide_input_macos_option_key_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.keymap.set("", "<D-n>", ":silent !neovide --multigrid&<cr>")
end

-- terminal
-- quit, then move to start of line to preserve display of curses-like output
vim.keymap.set("t", "<c-/>", "<c-\\><c-n>0")
vim.keymap.set("n", "<leader>ts", ":25sp | terminal fish<cr>a", { desc = "Terminal [s]plit horizontally" })
vim.keymap.set("n", "<leader>tv", ":85vsp | terminal fish<cr>a", { desc = "Terminal split [v]ertically" })
vim.keymap.set("n", "<leader>tt", ":tabnew | terminal fish<cr>a", { desc = "Terminal [t]ab" })

local terminal_settings_augroup = vim.api.nvim_create_augroup("terminal_settings", {})
vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Remove line numbers in terminals",
    group = terminal_settings_augroup,
    pattern = "term://*",
    command = "setlocal nonumber norelativenumber scrolloff=0",
})

vim.api.nvim_create_autocmd("TermClose", {
    desc = "Close terminals without pressing the return key",
    group = terminal_settings_augroup,
    pattern = "term://*",
    callback = function() -- event_args
        vim.fn.call("nvim_input", { "<cr>" })

        -- ignore fzf & coc filetypes as those will close terminal automatically
        -- local expanded_file = vim.fn.expand(event_args.file)
        -- local is_autoclose_file = string.match(expanded_file, "fzf")
        --     or string.match(expanded_file, "coc")
        -- if not is_autoclose_file then
        --     vim.fn.call("nvim_input", {"<cr>"})
        -- end
    end,
})

-- wildmenu
vim.o.wildmode = "longest,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.keymap.set("c", "<c-f>", "<space><bs><left>")
vim.keymap.set("c", "<c-b>", "<space><bs><right>")

-- coc, os and local config
local coc_settings = vim.fn.stdpath("config") .. "/coc-settings.lua"
if vim.fn.filereadable(coc_settings) == 1 then
    vim.cmd("luafile " .. coc_settings)
end
local os_settings = vim.fn.expand("~/.config/nvim/init.os.vim")
if vim.fn.filereadable(os_settings) == 1 then
    vim.cmd.source(os_settings)
end
local local_settings = vim.fn.expand("~/.config/nvim/init.local.vim")
if vim.fn.filereadable(local_settings) == 1 then
    vim.cmd.source(local_settings)
end

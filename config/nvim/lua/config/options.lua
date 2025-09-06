-- non-plugin vim.opt.*, vim.g.*, vim.o.* settings

vim.cmd.filetype("plugin indent on")
vim.cmd.syntax("enable")

-- show extra whitespace
vim.o.list = true
vim.o.listchars = "tab:▷\\ ,trail:⋅,nbsp:☺,extends:→,precedes:←"

-- wrap & highlight @100 chars
vim.o.textwidth = 100
vim.o.colorcolumn = "+0"
-- use sensible boundaries when wrapping text display
vim.o.linebreak = true
-- indent when wrapping with showbreak starting the line
vim.o.breakindent = true
vim.o.breakindentopt = "sbr"
vim.o.showbreak = "↪ "

-- show line numbers
vim.o.number = true
-- always show signcolumn, otherwise it would shift the text each time diagnostics appear
vim.o.signcolumn = "yes"

-- continue comments on new lines
vim.opt.formatoptions:append("ro")

-- ignore case unless there are upper-case characters
vim.o.ignorecase = true
vim.o.smartcase = true
-- include hyphens in words
vim.opt.iskeyword:prepend("-")
-- drop forward jumplist locations when moving to a new location
vim.opt.jumpoptions:append("stack")
-- ignore modelines due to security concerns
vim.o.modeline = false
vim.o.modelines = 0
-- live on the edge!
vim.o.swapfile = false
-- leave some space around the cursor when moving
vim.o.scrolloff = 2
vim.o.sidescrolloff = 15
-- trigger CursorHold sooner; keep < 300
vim.o.updatetime = 200

-- highlight current line
vim.o.cursorline = true
-- fold on indents; don't fold when opening files
vim.o.foldmethod = "indent"
vim.o.foldenable = false

-- https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0

vim.o.background = "dark"
vim.g.ayucolor = "mirage"
vim.cmd.colorscheme("ayu")

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup time.
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- some language servers have issues with backup files, see
-- https://github.com/neoclide/coc.nvim/issues/649
vim.o.backup = false
vim.o.writebackup = false

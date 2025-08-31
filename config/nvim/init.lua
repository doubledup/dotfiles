require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

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
-- always show signcolumn
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

-- wildmenu
vim.o.wildmode = "longest,full"
vim.o.wildoptions = "fuzzy,pum,tagfile"
vim.keymap.set("c", "<c-f>", "<space><bs><left>")
vim.keymap.set("c", "<c-b>", "<space><bs><right>")

-- https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0

vim.o.background = "dark"
vim.g.ayucolor = "mirage"
vim.cmd.colorscheme("ayu")

vim.keymap.set("n", "<c-n>", ":tabn<cr>")
vim.keymap.set("n", "<c-p>", ":tabp<cr>")
vim.keymap.set("n", "<c-.>", ":tabmove +1<cr>")
vim.keymap.set("n", "<c-,>", ":tabmove -1<cr>")
vim.keymap.set("n", "gm", ":tabmove<space>")

vim.keymap.set("n", "gz", ":q<cr>")
vim.keymap.set("n", "gZ", ":tabclose<cr>")
vim.keymap.set("n", "<c-w>t", ":tabonly<cr>")

vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")

vim.keymap.set("n", "<c-e>", "5<c-e>")
vim.keymap.set("n", "<c-y>", "5<c-y>")

-- horizontal scrolling
vim.keymap.set("n", "zh", "40zh", { remap = false })
vim.keymap.set("n", "zl", "40zl", { remap = false })

-- open file under cursor
-- TODO: interpret relative paths as relative to current file location
-- TODO: expand ~ to $HOME
vim.keymap.set("n", "gf", ":edit <cfile><cr>")

-- show file format and encoding
vim.keymap.set("n", "gl", ":set fileformat? fileencoding?<cr>")

-- enter to save all buffers, except in quickfix lists
vim.keymap.set(
    "n",
    "<cr>",
    "&buftype ==# 'quickfix' ? '<cr>' : ':checktime<cr>:wall<cr>'",
    { expr = true, remap = false }
)

-- keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { remap = false })
vim.keymap.set("n", "gJ", "mzgJ`z", { remap = false })

-- split line before/after cursor
vim.keymap.set("n", "[<cr>", "i<cr><esc>kg_")
vim.keymap.set("n", "]<cr>", "a<cr><esc>kg_")

-- search for selected text
vim.keymap.set("v", "*", '"zy/\\V\\c\\<<c-r>z\\><cr>')
vim.keymap.set("v", "g*", '"zy/\\V\\c<c-r>z<cr>')

-- substitute: replace all, ask for confirmation and don't ignore case
vim.keymap.set("n", "<c-s>", ":%s/\\V\\<<c-r><c-w>\\>/<c-r><c-w>/gcI<left><left><left><left>")
vim.keymap.set("n", "g<c-s>", ":%s/\\V<c-r><c-w>/<c-r><c-w>/gcI<left><left><left><left>")
vim.keymap.set("x", "<c-s>", '"zy:%s/\\V\\<<c-r>z\\>/<c-r>z/gcI<left><left><left><left>')
vim.keymap.set("x", "g<c-s>", '"zy:%s/\\V<c-r>z/<c-r>z/gcI<left><left><left><left>')

-- clear highlights
vim.keymap.set("n", "<esc>", function()
    vim.cmd.nohlsearch()
    -- TODO: dismiss gitsigns inline diff. Use kj for now.
    vim.cmd.echo()
end, { remap = false })

-- select all
vim.keymap.set("n", "^", "ggVG")

vim.cmd.cnoreabbrev("h", "vert h")
vim.cmd.cnoreabbrev("hs", "hor h")
vim.cmd.cnoreabbrev("ht", "tab h")

-- sacrilegious bindings for command mode
vim.keymap.set("c", "<c-a>", "<Home>")
vim.keymap.set("c", "<c-b>", "<left>")
vim.keymap.set("c", "<c-f>", "<right>")
vim.keymap.set("c", "<m-b>", "<s-left>")
vim.keymap.set("c", "<m-f>", "<s-right>")

vim.g.mousescroll = "hor:1"
vim.keymap.set("n", "<ScrollWheelUp>", "<c-y>")
vim.keymap.set("n", "<ScrollWheelDown>", "<c-e>")

if vim.g.neovide then
    vim.o.guifont = "Hack Nerd Font:h14"
    vim.g.neovide_scroll_animation_length = 0.2
    -- vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_refresh_rate_idle = 1
    vim.g.neovide_input_macos_option_key_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.keymap.set("", "<D-n>", ":silent !neovide --multigrid&<cr>")
end

-- config
vim.keymap.set("n", "<leader>,", ":tabnew<cr>:tcd ~/.dotfiles<cr>:e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader><leader>,", function()
    vim.cmd.source("~/.config/nvim/init.lua")
    -- suppress "Reloading your config is not supported" message as source does actually reload
    -- (non-package) config
    vim.cmd.echo()
end)
vim.keymap.set("n", "<leader>;", ":execute 'tabnew ~/.config/nvim/ftplugin/' . &ft . '.vim'<cr>")
vim.keymap.set("n", "<leader><leader>.", ":so %<cr>")

-- clipboard
-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup time.
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)
-- copy filename to system clipboard
vim.keymap.set("n", "<leader>5", ":let @+=@%<cr>")
-- copy current register to system clipboard
vim.keymap.set("n", "<leader>'", '"+')
vim.keymap.set("x", "<leader>'", '"+')

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

-- commands & augroups

vim.api.nvim_create_user_command("BuffersDeleteHidden", function()
    local shownBuffers = {}
    for i = 1, vim.fn.tabpagenr("$") do
        for _, j in pairs(vim.fn.tabpagebuflist(i)) do
            shownBuffers[j] = true
        end
    end

    local hiddenBuffers = {}
    for i = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and not shownBuffers[i] then
            table.insert(hiddenBuffers, i)
        end
    end

    if #hiddenBuffers > 0 then
        vim.cmd.bdelete(table.concat(hiddenBuffers, " "))
    end
end, { desc = 'Delete all "hidden" / not-shown buffers' })

vim.api.nvim_create_user_command("BuffersDeleteUnnamed", function()
    local emptyBuffers = {}
    for i = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and vim.fn.bufname(i) == "" then
            table.insert(emptyBuffers, i)
        end
    end

    if #emptyBuffers > 0 then
        vim.cmd.bdelete(table.concat(emptyBuffers, " "))
    end
end, { desc = "Delete all unnamed buffers" })

local onsave_augroup = vim.api.nvim_create_augroup("trim_whitespace_on_bufwrite", {})
vim.api.nvim_create_autocmd("BufWrite", {
    desc = "Trim trailing whitespace on save",
    group = onsave_augroup,
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

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

-- plugins

-- go
vim.g.go_code_completion_enabled = 0
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_fmt_autosave = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_term_mode = "split"
vim.g.go_term_reuse = 1
vim.g.go_term_enabled = 1
vim.g.go_term_close_on_exit = 0
vim.g.go_gopls_enabled = 0

-- hop
local hop = require("hop")
vim.keymap.set("n", "s", function()
    hop.hint_char2()
end)
vim.keymap.set("v", "s", function()
    hop.hint_char2({ inclusive_jump = true })
end)
local directions = require("hop.hint").HintDirection
vim.keymap.set("o", "z", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("o", "Z", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })

-- linediff
vim.keymap.set("v", "<leader>l", ":Linediff<cr>")

-- obsession
vim.keymap.set("n", "<leader>st", ":Obsession<cr>")
vim.keymap.set("n", "<leader>sl", ":source Session.vim<cr>")

-- slime
vim.g.slime_target = "kitty"
vim.g.slime_no_mappings = 1
vim.keymap.set("n", "<leader>tc", "<plug>SlimeConfig")
vim.keymap.set("n", "<leader>tx", "<plug>SlimeMotionSend")
vim.keymap.set("x", "<leader>tx", "<plug>SlimeRegionSend")
vim.keymap.set("n", "<leader>tl", "<plug>SlimeLineSend")
-- TODO: choose from active terminals b:terminal_job_id

-- unimpaired extensions for encoding & decoding
-- TODO: contribute this to unimpaired
vim.keymap.set("n", "[44", "!!base64<cr>")
vim.keymap.set("n", "]44", "!!base64 -d<cr>")
vim.keymap.set("v", "[4", "\"zc<c-r>=system(\"echo '<c-r>z' | base64 | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]4", "\"zc<c-r>=system(\"echo '<c-r>z' | base64 -d | tr -d '\\n'\")<cr><esc>")

vim.keymap.set("n", "[66", "VU!!sed -E 's/(.*)/obase=16;\\1/' | bc<cr>")
vim.keymap.set("n", "]66", "VU!!sed -E 's/(.*)/ibase=16;\\1/' | bc<cr>")
vim.keymap.set("v", "[6", "Ugv\"zc<c-r>=system(\"echo 'obase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]6", "Ugv\"zc<c-r>=system(\"echo 'ibase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

vim.keymap.set("n", "[88", "VU!!sed -E 's/(.*)/obase=8;\\1/' | bc<cr>")
vim.keymap.set("n", "]88", "VU!!sed -E 's/(.*)/ibase=8;\\1/' | bc<cr>")
vim.keymap.set("v", "[8", "Ugv\"zc<c-r>=system(\"echo 'obase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]8", "Ugv\"zc<c-r>=system(\"echo 'ibase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

vim.keymap.set("n", "[22", "VU!!sed -E 's/(.*)/obase=2;\\1/' | bc<cr>")
vim.keymap.set("n", "]22", "VU!!sed -E 's/(.*)/ibase=2;\\1/' | bc<cr>")
vim.keymap.set("v", "[2", "Ugv\"zc<c-r>=system(\"echo 'obase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]2", "Ugv\"zc<c-r>=system(\"echo 'ibase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

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

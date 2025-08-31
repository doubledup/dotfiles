-- non-plugin keymaps

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

-- copy filename to system clipboard
vim.keymap.set("n", "<leader>5", ":let @+=@%<cr>")
-- copy current register to system clipboard
vim.keymap.set("n", "<leader>'", '"+')
vim.keymap.set("x", "<leader>'", '"+')

-- Unimpaired extensions for encoding & decoding
-- TODO: contribute this to unimpaired

-- Base64 encoding/decoding
vim.keymap.set("n", "[44", "!!base64<cr>")
vim.keymap.set("n", "]44", "!!base64 -d<cr>")
vim.keymap.set("v", "[4", "\"zc<c-r>=system(\"echo '<c-r>z' | base64 | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]4", "\"zc<c-r>=system(\"echo '<c-r>z' | base64 -d | tr -d '\\n'\")<cr><esc>")

-- Hexadecimal conversion
vim.keymap.set("n", "[66", "VU!!sed -E 's/(.*)/obase=16;\\1/' | bc<cr>")
vim.keymap.set("n", "]66", "VU!!sed -E 's/(.*)/ibase=16;\\1/' | bc<cr>")
vim.keymap.set("v", "[6", "Ugv\"zc<c-r>=system(\"echo 'obase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]6", "Ugv\"zc<c-r>=system(\"echo 'ibase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

-- Octal conversion
vim.keymap.set("n", "[88", "VU!!sed -E 's/(.*)/obase=8;\\1/' | bc<cr>")
vim.keymap.set("n", "]88", "VU!!sed -E 's/(.*)/ibase=8;\\1/' | bc<cr>")
vim.keymap.set("v", "[8", "Ugv\"zc<c-r>=system(\"echo 'obase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]8", "Ugv\"zc<c-r>=system(\"echo 'ibase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

-- Binary conversion
vim.keymap.set("n", "[22", "VU!!sed -E 's/(.*)/obase=2;\\1/' | bc<cr>")
vim.keymap.set("n", "]22", "VU!!sed -E 's/(.*)/ibase=2;\\1/' | bc<cr>")
vim.keymap.set("v", "[2", "Ugv\"zc<c-r>=system(\"echo 'obase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")
vim.keymap.set("v", "]2", "Ugv\"zc<c-r>=system(\"echo 'ibase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>")

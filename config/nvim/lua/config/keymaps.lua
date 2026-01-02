-- non-plugin keymaps

vim.keymap.set("n", "<c-n>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<c-p>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<c-.>", ":tabmove +1<cr>", { desc = "Move tab right" })
vim.keymap.set("n", "<c-,>", ":tabmove -1<cr>", { desc = "Move tab left" })
vim.keymap.set("n", "gm", ":tabmove<space>", { desc = "Move tab to position" })

vim.keymap.set("n", "gz", ":q<cr>", { desc = "Close current window" })
vim.keymap.set("n", "gZ", ":tabclose<cr>", { desc = "Close current tab" })
vim.keymap.set("n", "<c-w>t", ":tabonly<cr>", { desc = "Close all other tabs" })

vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<c-e>", "5<c-e>", { desc = "Scroll down 5 lines" })
vim.keymap.set("n", "<c-y>", "5<c-y>", { desc = "Scroll up 5 lines" })

-- horizontal scrolling
vim.keymap.set("n", "zh", "40zh", { remap = false, desc = "Scroll left 40 columns" })
vim.keymap.set("n", "zl", "40zl", { remap = false, desc = "Scroll right 40 columns" })

-- open file under cursor
-- TODO: interpret relative paths as relative to current file location
-- TODO: expand ~ to $HOME
vim.keymap.set("n", "gf", ":edit <cfile><cr>", { desc = "Edit file under cursor" })

-- show file format and encoding
vim.keymap.set(
    "n",
    "gl",
    ":set fileformat? fileencoding?<cr>",
    { desc = "Show file format and encoding" }
)

-- keep cursor in place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { remap = false, desc = "Join lines keeping cursor position" })
vim.keymap.set(
    "n",
    "gJ",
    "mzgJ`z",
    { remap = false, desc = "Join lines without spaces, keeping cursor position" }
)

-- enter to save all buffers, except in quickfix lists
vim.keymap.set(
    "n",
    "<cr>",
    "&buftype ==# 'quickfix' ? '<cr>' : ':checktime<cr>:wall<cr>'",
    { expr = true, remap = false, desc = "Save all buffers (except in quickfix)" }
)

-- split line before/after cursor
vim.keymap.set("n", "[<cr>", "i<cr><esc>kg_", { desc = "Split line before cursor" })
vim.keymap.set("n", "]<cr>", "a<cr><esc>kg_", { desc = "Split line after cursor" })

-- search for selected text
vim.keymap.set(
    "v",
    "*",
    '"zy/\\V\\c\\<<c-r>z\\><cr>',
    { desc = "Search for selected text (whole word)" }
)
vim.keymap.set(
    "v",
    "g*",
    '"zy/\\V\\c<c-r>z<cr>',
    { desc = "Search for selected text (partial match)" }
)

-- substitute: replace all, ask for confirmation and don't ignore case
vim.keymap.set(
    "n",
    "<c-s>",
    ":%s/\\V\\<<c-r><c-w>\\>/<c-r><c-w>/gcI<left><left><left><left>",
    { desc = "Substitute word under cursor (whole word)" }
)
vim.keymap.set(
    "n",
    "g<c-s>",
    ":%s/\\V<c-r><c-w>/<c-r><c-w>/gcI<left><left><left><left>",
    { desc = "Substitute word under cursor (partial match)" }
)
vim.keymap.set(
    "x",
    "<c-s>",
    '"zy:%s/\\V\\<<c-r>z\\>/<c-r>z/gcI<left><left><left><left>',
    { desc = "Substitute selected text (whole word)" }
)
vim.keymap.set(
    "x",
    "g<c-s>",
    '"zy:%s/\\V<c-r>z/<c-r>z/gcI<left><left><left><left>',
    { desc = "Substitute selected text (partial match)" }
)

-- clear highlights
vim.keymap.set("n", "<esc>", function()
    vim.cmd.nohlsearch()
    -- TODO: dismiss gitsigns inline diff. Use kj for now.
    vim.cmd.echo()
end, { remap = false, desc = "Clear search highlights" })

-- select all
vim.keymap.set("n", "^", "ggVG", { desc = "Select all text" })

-- TODO: resize to 80 chars after opening help
vim.cmd.cnoreabbrev("h", "vert h")
vim.cmd.cnoreabbrev("hs", "hor h")
vim.cmd.cnoreabbrev("ht", "tab h")

-- sacrilegious bindings for command mode
vim.keymap.set("c", "<c-a>", "<Home>", { desc = "Move to beginning of line" })
vim.keymap.set("c", "<c-b>", "<left>", { desc = "Move cursor left" })
vim.keymap.set("c", "<c-f>", "<right>", { desc = "Move cursor right" })
vim.keymap.set("c", "<m-b>", "<s-left>", { desc = "Move word backward" })
vim.keymap.set("c", "<m-f>", "<s-right>", { desc = "Move word forward" })

-- config
vim.keymap.set(
    "n",
    "<leader>,",
    ":tabnew<cr>:tcd ~/.dotfiles<cr>:e config/nvim/init.lua<cr>",
    { desc = "Open nvim config" }
)
vim.keymap.set("n", "<leader><leader>,", function()
    vim.cmd.source("~/.config/nvim/init.lua")
    -- suppress "Reloading your config is not supported" message as source does actually reload
    -- (non-package) config
    vim.cmd.echo()
end, { desc = "Reload nvim config" })

-- copy filename to system clipboard
vim.keymap.set("n", "<leader>5", ":let @+=@%<cr>", { desc = "Copy filename to clipboard" })
-- copy current register to system clipboard
vim.keymap.set("n", "<leader>'", '"+', { desc = "Access system clipboard register" })
vim.keymap.set("x", "<leader>'", '"+', { desc = "Access system clipboard register" })

-- Unimpaired extensions for encoding & decoding
-- TODO: contribute this to unimpaired

-- Base64 encoding/decoding
vim.keymap.set("n", "[44", "!!base64<cr>", { desc = "Base64 encode current line" })
vim.keymap.set("n", "]44", "!!base64 -d<cr>", { desc = "Base64 decode current line" })
vim.keymap.set(
    "v",
    "[4",
    "\"zc<c-r>=system(\"echo '<c-r>z' | base64 | tr -d '\\n'\")<cr><esc>",
    { desc = "Base64 encode selection" }
)
vim.keymap.set(
    "v",
    "]4",
    "\"zc<c-r>=system(\"echo '<c-r>z' | base64 -d | tr -d '\\n'\")<cr><esc>",
    { desc = "Base64 decode selection" }
)

-- Hexadecimal conversion
vim.keymap.set(
    "n",
    "[66",
    "VU!!sed -E 's/(.*)/obase=16;\\1/' | bc<cr>",
    { desc = "Convert (decimal) line to hexadecimal" }
)
vim.keymap.set(
    "n",
    "]66",
    "VU!!sed -E 's/(.*)/ibase=16;\\1/' | bc<cr>",
    { desc = "Convert hex line to decimal" }
)
vim.keymap.set(
    "v",
    "[6",
    "Ugv\"zc<c-r>=system(\"echo 'obase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert (decimal) selection to hexadecimal" }
)
vim.keymap.set(
    "v",
    "]6",
    "Ugv\"zc<c-r>=system(\"echo 'ibase=16;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert hex selection to decimal" }
)

-- Octal conversion
vim.keymap.set(
    "n",
    "[88",
    "VU!!sed -E 's/(.*)/obase=8;\\1/' | bc<cr>",
    { desc = "Convert (decimal) line to octal" }
)
vim.keymap.set(
    "n",
    "]88",
    "VU!!sed -E 's/(.*)/ibase=8;\\1/' | bc<cr>",
    { desc = "Convert octal line to decimal" }
)
vim.keymap.set(
    "v",
    "[8",
    "Ugv\"zc<c-r>=system(\"echo 'obase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert (decimal) selection to octal" }
)
vim.keymap.set(
    "v",
    "]8",
    "Ugv\"zc<c-r>=system(\"echo 'ibase=8;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert octal selection to decimal" }
)

-- Binary conversion
vim.keymap.set(
    "n",
    "[22",
    "VU!!sed -E 's/(.*)/obase=2;\\1/' | bc<cr>",
    { desc = "Convert (decimal) line to binary" }
)
vim.keymap.set(
    "n",
    "]22",
    "VU!!sed -E 's/(.*)/ibase=2;\\1/' | bc<cr>",
    { desc = "Convert binary line to decimal" }
)
vim.keymap.set(
    "v",
    "[2",
    "Ugv\"zc<c-r>=system(\"echo 'obase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert (decimal) selection to binary" }
)
vim.keymap.set(
    "v",
    "]2",
    "Ugv\"zc<c-r>=system(\"echo 'ibase=2;<c-r>z' | bc | tr -d '\\n'\")<cr><esc>",
    { desc = "Convert binary selection to decimal" }
)

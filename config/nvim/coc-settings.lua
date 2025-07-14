-- some servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/649
vim.o.backup = false
vim.o.writebackup = false

-- Having longer updatetime leads to noticeable delays and poor user experience
-- Already set to <300 in init.lua, setting again to keep it low
vim.opt.updatetime = 200

-- always show the signcolumn, otherwise it would shift the text each time diagnostics appear
-- Already set in init.lua, setting again to keep it on
vim.o.signcolumn='yes'

vim.g.coc_global_extensions = {
  'coc-diagnostic',
  -- 'coc-eslint',
  -- 'coc-fzf-preview',
  -- 'coc-go',
  'coc-html',
  'coc-java',
  'coc-json',
  -- 'coc-ltex',
  'coc-lua',
  'coc-prettier',
  -- 'coc-pyright',
  'coc-rust-analyzer',
  'coc-sh',
  -- 'coc-snippets',
  'coc-sql',
  'coc-terraform',
  -- 'coc-tsserver',
  'coc-typos',
  'coc-yaml',
  'coc-xml',
  -- 'coc-zig',
}

local keyset = vim.keymap.set

-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

vim.g.coc_snippet_next = '<tab>'
vim.g.coc_snippet_prev = '<s-tab>'

-- Use `[s` and `]s` to navigate diagnostics (replace spell checker)
keyset('n', '[s', '<Plug>(coc-diagnostic-prev)', { silent = true })
keyset('n', ']s', '<Plug>(coc-diagnostic-next)', { silent = true })

keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window (replace keywordprg)
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<cmd>lua _G.show_docs()<cr>', { noremap = true, silent = true }) -- noremap?

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

keyset("n", "<leader>an", "<Plug>(coc-rename)", { silent = true })

keyset('x', '<leader>=', '<Plug>(coc-format-selected)', { silent = true })
keyset('n', '<leader>=', '<Plug>(coc-format)', { silent = true })

---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Apply code action at cursor position
keyset('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)', opts)
-- Apply code action to selected region
keyset('x', '<leader>a', '<Plug>(coc-codeaction-selected)', opts)
-- Apply code action to current file
keyset('n', '<leader>ak', '<Plug>(coc-codeaction)', opts)
-- Apply source code action to current line
keyset('n', '<leader>al', '<Plug>(coc-codeaction-line)', opts)

-- Apply most preferred fix action on current line
keyset('n', '<leader>af', '<Plug>(coc-fix-current)', opts)

-- Apply source code action to current file
keyset('n', '<leader>as', '<Plug>(coc-codeaction-source)', opts)

-- Apply refactor code action at cursor position
keyset('n', '<leader>ar', '<Plug>(coc-codeaction-refactor)', { silent = true })
-- keyset('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })

-- keyset('n', '<leader>r', '<Plug>(coc-refactor)', { silent = true })

-- Run the Code Lens actions on the current line
-- keyset('n', '<leader>ae', '<Plug>(coc-codelens-action)', opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Remap <c-f> and <c-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true, expr = true }
local scroll_length = 5
keyset('n', '<c-f>',
    string.format('coc#float#has_scroll() ? coc#float#scroll(1, %d) : "<c-f>"',
        scroll_length
    ), opts)
keyset('n', '<c-b>',
        string.format('coc#float#has_scroll() ? coc#float#scroll(0, %d) : "<c-b>"',
        scroll_length
    ), opts)
keyset('i', '<c-f>',
    string.format('coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1, %d)<cr>" : "<right>"',
        scroll_length,
        scroll_length
    ), opts)
keyset('i', '<c-b>',
        string.format('coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0, %d)<cr>" : "<left>"',
        scroll_length,
        scroll_length
    ), opts)
keyset('v', '<c-f>',
    string.format('coc#float#has_scroll() ? coc#float#scroll(1, %d) : "<c-f>"',
        scroll_length,
        scroll_length
    ), opts)
keyset('v', '<c-b>',
        string.format('coc#float#has_scroll() ? coc#float#scroll(0, %d) : "<c-b>"',
        scroll_length,
        scroll_length
    ), opts)

-- Use c-q for selecting ranges
-- Requires 'textDocument/selectionRange' support from the language server
keyset('n', '<c-q>', '<Plug>(coc-range-select)', { silent = true })
keyset('x', '<c-q>', '<Plug>(coc-range-select)', { silent = true })

-- TODO: See `:h coc-status` for integration with lightline.

-- Mappings for CoCList
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
keyset('n', '<leader>e', ':<c-u>CocList diagnostics<cr>', opts)
keyset('n', '<leader>ax', ':<c-u>CocList extensions<cr>', opts)
keyset('n', '<c-;>', ':<c-u>CocList commands<cr>', opts)
keyset('n', '<leader>ao', ':<c-u>CocList outline<cr>', opts)
keyset('n', '<leader>ay', ':<c-u>CocList -I symbols<cr>', opts)
-- -- Do default action for next item
-- keyset('n', '<leader>j', ':<c-u>CocNext<cr>', opts)
-- -- Do default action for previous item
-- keyset('n', '<leader>k', ':<c-u>CocPrev<cr>', opts)
-- -- Resume latest coc list
-- keyset('n', '<leader>p', ':<c-u>CocListResume<cr>', opts)

-- Show symbol outline for current document
vim.keymap.set('n', '<leader>o', function()
  local winid = vim.fn['coc#window#find']('cocViewId', 'OUTLINE')
  if winid == -1 then
    vim.fn.CocActionAsync('showOutline', 1)
  else
    vim.fn['coc#window#close'](winid)
  end
end, { silent = true, nowait = true, desc = "Toggle outline" })

-- Automatically close outline when it's the last window
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == 'coctree' and vim.fn.winnr('$') == 1 then
      if vim.fn.tabpagenr('$') ~= 1 then
        vim.cmd('close')
      else
        vim.cmd('bdelete')
      end
    end
  end,
  desc = "Auto close outline when last window"
})

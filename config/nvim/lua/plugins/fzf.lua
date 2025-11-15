return {
    { "junegunn/fzf" },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        keys = {
            { "<leader>f", ":Files!<cr>", desc = "Find files" },
            { "<leader>b", ":Buffers!<cr>", desc = "Find buffers" }, -- TODO: buffer deletion
            { "<leader>i", ":History!<cr>", desc = "Recent files" },
            { "<leader>w", ":Windows!<cr>", desc = "Find windows" },
            { "<leader>x", ":Rg!<cr>", desc = "Find in files" },
            { "<leader>x", 'y:Rg! <c-r>"<cr>', desc = "Find selection in files", mode = "v" },
            { "<leader>/", ":BLines!<cr>", desc = "Find in current buffer" },
            {
                "<leader>/",
                'y:BLines! <c-r>"<cr>',
                desc = "Find selection in current buffer",
                mode = "v",
            },
            { "<leader>*", ":BLines! <c-r><c-w><cr>", desc = "Find word under cursor in buffer" },
            {
                "<leader>*",
                'y:BLines! <c-r>"<cr>',
                desc = "Find selection in current buffer",
                mode = "v",
            },
            { "<leader>:", ":History:!<cr>", desc = "Run command from history" },
            { "<leader>gl", ":Commits!<cr>", desc = "Git log (fzf)" },
        },
        config = function()
            vim.cmd([[
                function! s:build_quickfix_list(lines)
                call setqflist(map(copy(a:lines), "{ 'filename': v:val, 'lnum': 1 }"))
                copen
                cc
                endfunction

                let g:fzf_action = {
                \ "ctrl-s": "split",
                \ "ctrl-v": "vsplit",
                \ "ctrl-t": "tab split",
                \ "ctrl-q": function("s:build_quickfix_list") }
            ]])
        end,
    },
}

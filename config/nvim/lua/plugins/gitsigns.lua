return {
    "lewis6991/gitsigns.nvim",
    opts = {
        on_attach = function(bufnr)
            local gitsigns = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]d", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]d", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end)

            map("n", "[d", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[d", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end)

            -- Actions
            map("n", "<leader>ga", gitsigns.stage_hunk)
            map("v", "<leader>ga", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)
            map("n", "<leader>gr", gitsigns.reset_hunk)
            map("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)

            map("n", "<leader>gA", gitsigns.stage_buffer)
            map("n", "<leader>gR", gitsigns.reset_buffer)
            map("n", "<leader>gi", gitsigns.preview_hunk_inline)
            map("n", "<leader>gv", gitsigns.undo_stage_hunk)

            -- Text object
            map({ "o", "x" }, "id", gitsigns.select_hunk)
        end,
    },
}

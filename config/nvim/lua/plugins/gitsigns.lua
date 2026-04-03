return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gitsigns = package.loaded.gitsigns

            local function opts(desc)
                return { buffer = bufnr, desc = desc }
            end

            -- Navigation
            vim.keymap.set("n", "]d", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]d", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, opts("Next diff/hunk"))

            vim.keymap.set("n", "[d", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[d", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, opts("Previous diff/hunk"))

            -- Actions
            vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, opts("Stage hunk"))
            vim.keymap.set("v", "<leader>ga", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, opts("Stage hunk selection"))
            vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, opts("Reset hunk"))
            vim.keymap.set("v", "<leader>gr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, opts("Reset hunk selection"))

            vim.keymap.set("n", "<leader>gA", gitsigns.stage_buffer, opts("Stage buffer"))
            vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, opts("Reset buffer"))
            vim.keymap.set(
                "n",
                "<leader>gi",
                gitsigns.preview_hunk_inline,
                opts("Preview hunk inline")
            )
            vim.keymap.set("n", "<leader>gv", gitsigns.undo_stage_hunk, opts("Undo stage hunk"))

            -- Text object
            vim.keymap.set(
                { "o", "x" },
                "id",
                gitsigns.select_hunk,
                opts("Select hunk text object")
            )
        end,
    },
}

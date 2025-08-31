-- alternative: nvim-neo-tree/neo-tree.nvim
-- edit filesystem in buffer: stevearc/oil.nvim
return {
    "nvim-tree/nvim-tree.lua",

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    opts = {
        view = {
            width = 60,
        },

        renderer = {
            group_empty = true,
        },

        on_attach = function(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "-", api.tree.toggle, opts("Toggle tree"))
            -- swap default c-x for c-s so horizontal split is consistent with c-w window keys
            vim.keymap.del("n", "<c-x>", { buffer = bufnr })
            vim.keymap.set("n", "<c-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        end,
    },

    config = function(_, opts)
        require("nvim-tree").setup(opts)

        local nvimtree_augroup = vim.api.nvim_create_augroup("NvimTree", { clear = false })
        vim.api.nvim_create_autocmd("BufEnter", {
            desc = "Quit when nvim-tree is the last window",
            group = nvimtree_augroup,
            callback = function()
                local api = require("nvim-tree.api")
                if vim.fn.winnr("$") == 1 and api.tree.is_tree_buf() then
                    vim.cmd.q()
                end
            end,
        })
    end,

    keys = {
        { "-", ":NvimTreeToggle<cr>", desc = "Toggle nvim-tree" },
        { "<leader>-", ":NvimTreeFindFile<cr>", desc = "Open nvim-tree at current file" },
    },
}

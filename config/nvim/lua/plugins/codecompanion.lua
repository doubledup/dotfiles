return {
    "olimorris/codecompanion.nvim",
    version = "18.*",
    dependencies = {
        { "nvim-lua/plenary.nvim", version = "0.1.*" },
        "nvim-treesitter/nvim-treesitter",
        -- Enable for one-off setup. See its README for auth.
        { "zbirenbaum/copilot.lua", version = "2.*" },
    },

    init = function(_)
        vim.cmd("cabbrev c CodeCompanion")
    end,

    opts = {
        interactions = {
            chat = {
                adapter = {
                    name = "copilot",
                    model = "claude-opus-4.6",
                },
            },
        },
    },

    cmd = {
        "CodeCompanion",
        "CodeCompanionCmd",
        "CodeCompanionChat",
        "CodeCompanionActions",
    },

    keys = {
        {
            mode = { "n", "v" },
            "<leader>n",
            "<cmd>CodeCompanionActions<cr>",
            desc = "Open AI chat menu",
            noremap = true,
            silent = true,
        },
        {
            mode = { "n", "v" },
            "<leader>m",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "Toggle AI chat",
            noremap = true,
            silent = true,
        },
        {
            mode = { "v" },
            "ga",
            "<cmd>CodeCompanionChat Add<cr>",
            desc = "Add selection to AI chat",
            noremap = true,
            silent = true,
        },

        -- vim.keymap.set("n", "<leader>ai", ":CodeCompanion<cr>")
        -- vim.keymap.set("n", "<leader>ac", ":CodeCompanionChat Toggle<cr>")
        -- vim.keymap.set("v", "<leader>ac", ":CodeCompanionChat Toggle<cr>")
        -- vim.keymap.set("n", "<leader>am", ":CodeCompanionCmd<cr>")
        -- vim.keymap.set("n", "<leader>at", ":CodeCompanionActions<cr>")
        -- vim.keymap.set("v", "<leader>at", ":CodeCompanionActions<cr>")
    },
}

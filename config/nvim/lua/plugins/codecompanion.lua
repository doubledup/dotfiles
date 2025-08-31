return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        -- Enable for one-off setup. See its README for auth.
        "zbirenbaum/copilot.lua",
    },
    init = function(_)
        vim.cmd("cabbrev c CodeCompanion")
    end,
    opts = {
        strategies = {
            chat = {
                adapter = {
                    name = "anthropic",
                    model = "claude-sonnet-4-20250514",
                },
            },
            inline = {
                adapter = {
                    name = "anthropic",
                    model = "claude-sonnet-4-20250514",
                },
            },
        },
        adapters = {
            http = {
                -- anthropic = function()
                --     return require("codecompanion.adapters").extend("anthropic", {
                --         env = {
                --             api_key = "MY_OTHER_ANTHROPIC_KEY",
                --         },
                --     })
                -- end,
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                default = function()
                                    return "claude-sonnet-4"
                                end,
                            },
                        },
                    })
                end,
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
            noremap = true,
            silent = true,
        },
        {
            mode = { "n", "v" },
            "<leader>m",
            "<cmd>CodeCompanionChat Toggle<cr>",
            noremap = true,
            silent = true,
        },
        {
            mode = { "v" },
            "ga",
            "<cmd>CodeCompanionChat Add<cr>",
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

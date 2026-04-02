return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },

    config = function()
        local lint = require("lint")

        -- sh/bash: bashls runs shellcheck (from PATH) internally
        lint.linters_by_ft = {
            fish = { "fish" },
            sql = { "sqlfluff" },
            terraform = { "tflint" },
            yaml = { "yamllint" },
        }

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = function()
                if vim.opt_local.modifiable:get() then
                    lint.try_lint()
                end
            end,
        })
    end,
}

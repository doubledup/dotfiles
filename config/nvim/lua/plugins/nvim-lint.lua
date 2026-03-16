return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },

    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            sql = { "sqlfluff" },
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

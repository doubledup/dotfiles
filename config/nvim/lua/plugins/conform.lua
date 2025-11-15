return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>=",
            mode = "",
            desc = "Format buffer",

            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
        },
        {
            "<cr>",
            mode = "n",
            desc = "Format and save all buffers (except in quickfix)",

            function()
                if vim.bo.buftype == "quickfix" then
                    -- In quickfix, leave <cr> behavior as-is
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "n", false)
                else
                    vim.cmd.checktime()

                    -- Format all buffers
                    local conform = require("conform")
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modifiable then
                            conform.format({ async = false, lsp_format = "fallback", bufnr = buf })
                        end
                    end
                    vim.cmd.wall()
                end
            end,
        },
    },

    opts = {
        notify_on_error = false,

        -- format_on_save = function(bufnr)
        --     -- Disable "format_on_save lsp_fallback" for languages that don't
        --     -- have a well standardized coding style.
        --     local disable_filetypes = { c = true, cpp = true }
        --     if disable_filetypes[vim.bo[bufnr].filetype] then
        --         return nil
        --     else
        --         return {
        --             timeout_ms = 500,
        --             lsp_format = "fallback",
        --         }
        --     end
        -- end,

        formatters_by_ft = {
            java = { "google-java-format" },
            lua = { "stylua" },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },

        formatters = {
            google_java_format = function(bufnr)
                return {
                    command = require("conform.util").find_executable({
                        "/opt/homebrew/bin/google-java-format",
                    }, "google-java-format"),
                    env = {
                        JAVA_HOME = vim.system({ "/usr/libexec/java_home", "-v", "21" }, { text = true })
                            :wait().stdout
                            :gsub("\n$", ""),
                    },
                }
            end,
        },
    },
}

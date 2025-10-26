return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>=",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "Format buffer",
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

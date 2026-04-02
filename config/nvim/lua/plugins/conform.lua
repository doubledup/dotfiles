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
    },

    opts = {
        notify_on_error = false,

        format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
        },

        formatters_by_ft = {
            fish = { "fish_indent" },
            java = { "google-java-format" },
            lua = { "stylua" },
            sql = { "sqlfluff" },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },

        formatters = {
            google_java_format = function(_) -- bufnr
                return {
                    command = require("conform.util").find_executable({
                        "/opt/homebrew/bin/google-java-format",
                    }, "google-java-format"),
                    env = {
                        JAVA_HOME = vim.system(
                            { "/usr/libexec/java_home", "-v", "21" },
                            { text = true }
                        )
                            :wait().stdout
                            :gsub("\n$", ""),
                    },
                }
            end,
        },
    },
}

return {
    "stevearc/conform.nvim",
    version = "9.*",
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

    config = function(_, opts)
        require("conform").setup(opts)

        vim.api.nvim_create_user_command("W", function()
            vim.g._skip_format = true
            vim.cmd.write()
            vim.g._skip_format = false
        end, { desc = "Save without formatting" })

        vim.api.nvim_create_user_command("Wall", function()
            vim.g._skip_format = true
            vim.cmd.wall()
            vim.g._skip_format = false
        end, { desc = "Save all without formatting" })
    end,

    opts = {
        notify_on_error = false,

        format_on_save = function()
            if vim.g._skip_format then
                return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,

        formatters_by_ft = {
            css = { "prettier" },
            fish = { "fish_indent" },
            html = { "prettier" },
            java = { "google-java-format" },
            javascript = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            sh = { "shfmt" },
            sql = { "sqlfluff" },
            terraform = { "terraform_fmt" },
            typescript = { "prettier" },
            yaml = { "prettier" },
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

return {
    "nvim-lualine/lualine.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
        options = {
            theme = "tokyonight",
            always_show_tabline = false,
        },

        sections = {
            lualine_a = { "mode" },
            lualine_b = { "filename" },
            lualine_c = { "diff", "diagnostics", "lsp_status" },

            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "branch" },
            lualine_z = { "searchcount", "selectioncount", "progress", "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = { "filename" },
            lualine_c = { "diff" },
            lualine_x = { "filetype" },
            lualine_y = {},
            lualine_z = { "location" },
        },
        tabline = {
            lualine_a = {},
            lualine_b = {
                {
                    "tabs",
                    max_length = function()
                        -- using a function here sets max_length dynamically so that the tabline
                        -- handles resizing
                        return vim.o.columns
                    end,
                    mode = 2,
                    path = 1,
                    fmt = function(_, context) -- name and context
                        -- prepend filetype icon to tab name
                        local buflist = vim.fn.tabpagebuflist(context.tabnr)
                        local winnr = vim.fn.tabpagewinnr(context.tabnr)
                        local bufnr = buflist[winnr]

                        local icon = vim.fn.WebDevIconsGetFileTypeSymbol(nil)
                        local filename = vim.fn.bufname(bufnr)
                        if bufnr then
                            icon = vim.fn.WebDevIconsGetFileTypeSymbol(vim.fn.bufname(bufnr))

                            local home = os.getenv("HOME")
                            if home ~= nil then
                                filename = filename:gsub(home, "~")
                                filename = filename:gsub(".*/([^/]*/[^/]*/[^/]*)$", "%1")
                            end
                        end

                        return icon .. " " .. filename
                    end,
                },
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    },

    config = function(_, opts)
        vim.o.showmode = false
        vim.o.showtabline = 1

        require("lualine").setup(opts)
    end,
}

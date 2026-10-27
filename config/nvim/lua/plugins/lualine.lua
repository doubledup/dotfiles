return {
    "nvim-lualine/lualine.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = function()
        -- Custom filepath component with smart eliding
        ---@diagnostic disable-next-line: unused-local, unused-function
        local function elided_filepath()
            local bufnr = vim.api.nvim_get_current_buf()
            local filepath = vim.api.nvim_buf_get_name(bufnr)

            if filepath == "" then
                return "[No Name]"
            end

            -- Get relative path from cwd
            -- :~ replaces home dir with ~
            -- :. makes the path relative to cwd
            local relpath = vim.fn.fnamemodify(filepath, ":~:.")

            local parts = {}
            for part in relpath:gmatch("[^/]+") do
                table.insert(parts, part)
            end

            if #parts <= 5 then
                return relpath
            end

            -- Keep top 1, bottom 2 dirs + filename, elide middle
            local result = table.concat({ parts[1] }, "/")
                .. "/…/"
                .. table.concat({ parts[#parts - 2], parts[#parts - 1], parts[#parts] }, "/")

            return result
        end

        return {
            options = {
                theme = "catppuccin-nvim",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                always_show_tabline = false,
                globalstatus = true,
            },

            sections = {
                lualine_a = {
                    {
                        "mode",
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = {
                    {
                        "filename",
                        path = 1,
                        -- elided_filepath,
                        -- icon = "",
                    },
                },
                lualine_c = { "diff", "diagnostics", "lsp_status" },

                lualine_x = { "filetype" },
                lualine_y = { "branch" },
                lualine_z = {
                    "searchcount",
                    "selectioncount",
                    "progress",
                    { "location", separator = { right = "" } },
                },
            },

            inactive_sections = {
                lualine_a = {
                    {
                        "filename",
                        path = 1,
                        -- elided_filepath,
                        -- icon = "",
                    },
                },
                lualine_b = { "diff", "diagnostics" },
                lualine_c = {},
                lualine_x = {},
                lualine_y = { "filetype" },
                lualine_z = { "progress", "location" },
            },

            tabline = {
                lualine_a = {},
                lualine_b = {
                    {
                        "tabs",
                        -- TODO: set up consistent padding in the first tab when inactive vs when
                        -- active, so that separators don't appear when the first tab is active and
                        -- shift the other tabs.
                        -- separator = { left = "", right = "" },
                        max_length = function()
                            -- using a function here sets max_length dynamically so that the tabline
                            -- handles resizing
                            return vim.o.columns
                        end,
                        mode = 2,
                        path = 1,
                        fmt = function(_, context) -- name and context
                            -- prepend filetype icon to tab name and abbreviate $HOME & file path
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
        }
    end,

    config = function(_, opts)
        vim.o.showmode = false
        vim.o.showtabline = 1

        require("lualine").setup(opts)
    end,
}

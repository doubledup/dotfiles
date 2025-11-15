return {
    "nvim-lualine/lualine.nvim",

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
        options = {
            theme = "tokyonight",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            always_show_tabline = false,
            -- globalstatus = true,
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
                    function()
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

                        -- Keep top 1, bottom 3 dirs + filename, elide middle
                        local result = table.concat({ parts[1] }, "/")
                            .. "/…/"
                            .. table.concat(
                                { parts[#parts - 3], parts[#parts - 2], parts[#parts - 1], parts[#parts] },
                                "/"
                            )

                        return result
                    end,
                    icon = "",
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
            lualine_a = { "filename" },
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
    },

    config = function(_, opts)
        vim.o.showmode = false
        vim.o.showtabline = 1

        -- -- Make window separators more visible with globalstatus
        -- local winsep_augroup = vim.api.nvim_create_augroup("window_separator", {})
        -- vim.api.nvim_create_autocmd("ColorScheme", {
        --     desc = "Make window separators more visible",
        --     group = winsep_augroup,
        --     pattern = "*",
        --     callback = function()
        --         local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        --
        --         vim.api.nvim_set_hl(0, "WinSeparator", {
        --             fg = "#545c7e",
        --             bg = normal_bg,
        --         })
        --     end,
        -- })
        --
        -- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#545c7e" })

        -- set lualine theme based on background, preserving existing options
        local function update_lualine_theme()
            local theme = vim.o.background == "dark" and "tokyonight" or "tokyonight-day"

            local new_opts = vim.deepcopy(opts)
            new_opts.options.theme = theme

            require("lualine").setup(new_opts)
        end

        update_lualine_theme()

        -- Listen for auto-dark-mode.nvim changes
        vim.api.nvim_create_autocmd("User", {
            pattern = "AutoDarkModeChanged",
            group = vim.api.nvim_create_augroup("LualineThemeSync", { clear = true }),
            callback = update_lualine_theme,
            desc = "Update lualine theme when system appearance changes",
        })
    end,
}

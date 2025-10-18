return {
    -- https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
    -- "nvim-lualine/lualine.nvim"
    "itchyny/lightline.vim",

    dependencies = {
        "tpope/vim-fugitive",
    },

    config = function()
        vim.o.showmode = false
        vim.g.lightline = {
            colorscheme = "tokyonight",
            active = {
                left = {
                    { "mode", "paste" },
                    { "readonly", "modified", "relativepath" },
                    {},
                },
                right = {
                    { "lineinfo" },
                    { "filetype", "gitbranch" },
                    { "fileformat", "fileencoding" },
                },
            },
            inactive = {
                left = { { "relativepath" } },
                right = {
                    { "lineinfo" },
                    { "filetype" },
                    {},
                },
            },
            -- component = {},
            component_function = {
                gitbranch = "LightlineGitHead",
                filetype = "LightlineFiletype",
            },
            tab_component_function = {
                tabfileicon = "LightlineTabFileicon",
                tabfilename = "LightlineTabFilename",
            },
            tab = {
                active = { "tabfileicon", "tabnum", "readonly", "tabfilename", "modified" },
                inactive = { "tabfileicon", "tabnum", "readonly", "tabfilename", "modified" },
            },
            tabline = {
                left = { { "tabs" } },
            },
        }

        function LightlineGitHead()
            return " " .. vim.fn.FugitiveHead()
        end

        function LightlineFiletype()
            if vim.fn.winwidth(0) > 70 then
                if #vim.bo.filetype > 0 then
                    return vim.fn.WebDevIconsGetFileTypeSymbol() .. " " .. vim.bo.filetype
                else
                    return "no ft"
                end
            else
                return ""
            end
        end

        function LightlineTabFileicon(tabnum)
            local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
            if bufnr then
                return vim.fn.WebDevIconsGetFileTypeSymbol(vim.fn.bufname(bufnr))
            else
                return vim.fn.WebDevIconsGetFileTypeSymbol(nil)
            end
        end

        function CwdTrimmed(cwd)
            local home = os.getenv("HOME")
            cwd = cwd:gsub(home, "~")
            return cwd:gsub(".*/([^/]*/[^/]*/[^/]*)$", "%1")
        end

        function LightlineTabFilename(tabnum)
            local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
            if bufnr then
                local filename = vim.fn.bufname(bufnr)
                return CwdTrimmed(filename)
            else
                return ""
            end
        end

        vim.cmd([[
            function! LightlineGitHead()
            return luaeval("LightlineGitHead()", {})
            endfunction
            function! LightlineFiletype()
            return luaeval("LightlineFiletype()", {})
            endfunction
            function! LightlineTabFileicon(tabnum)
            return luaeval("LightlineTabFileicon(_A.tabnum)", {"tabnum": a:tabnum})
            endfunction
            function! LightlineTabFilename(tabnum)
            return luaeval("LightlineTabFilename(_A.tabnum)", {"tabnum": a:tabnum})
            endfunction
        ]])
    end,
}

return {
    -- "jreybert/vimagit"
    -- "tpope/vim-git",
    -- "tpope/vim-rhubarb"
    "tpope/vim-fugitive",
    -- Github code reviews
    -- pwntester/octo.nvim

    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gitsigns = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]d", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]d", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[d", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[d", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>ga", gitsigns.stage_hunk)
                map("v", "<leader>ga", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)
                map("n", "<leader>gr", gitsigns.reset_hunk)
                map("v", "<leader>gr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)

                map("n", "<leader>gA", gitsigns.stage_buffer)
                map("n", "<leader>gR", gitsigns.reset_buffer)
                map("n", "<leader>gi", gitsigns.preview_hunk_inline)
                map("n", "<leader>gv", gitsigns.undo_stage_hunk)

                -- Text object
                map({ "o", "x" }, "id", gitsigns.select_hunk)
            end,
        },
    },

    -- "williamboman/mason.nvim" -- and
    -- "williamboman/mason-lspconfig.nvim" -- and
    -- "neovim/nvim-lspconfig"
    --
    -- "ms-jpq/coq_nvim",
    -- "autozimu/LanguageClient-neovim",
    { "neoclide/coc.nvim", branch = "release" },

    -- ui
    {
        "Luxed/ayu-vim",
        lazy = false,
        priority = 1000, -- load before other plugins
    },

    {
        "folke/snacks.nvim",
        opts = {
            bigfile = {},
        },
    },
    "folke/which-key.nvim",
    "junegunn/fzf",
    "junegunn/fzf.vim",
    "norcalli/nvim-colorizer.lua",
    -- TODO: disable <leader>rwp
    "powerman/vim-plugin-AnsiEsc",
    "ryanoasis/vim-devicons",

    {
        -- https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
        -- "nvim-lualine/lualine.nvim"
        "itchyny/lightline.vim",
        config = function()
            vim.o.showmode = false
            vim.g.lightline = {
                colorscheme = "ayu_mirage",
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
    },

    -- less jank: nvim-neo-tree/neo-tree.nvim
    -- edit filesystem in buffer: stevearc/oil.nvim
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            view = {
                width = 60,
            },
            renderer = {
                group_empty = true,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set("n", "-", api.tree.toggle, opts("Toggle tree"))
                -- vim.keymap.set("n", "<c-k>", api.tree.change_root_to_parent, opts("Up"))
                -- vim.keymap.set("n", "<c-j>", api.tree.change_root_to_node, opts("Down"))
                -- vim.keymap.del("n", "<c-x>", { buffer = bufnr })
                vim.keymap.set("n", "<c-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
            end,
        },
    },

    -- editing
    "andrewradev/linediff.vim",
    { "smoka7/hop.nvim", opts = {} },
    -- "honza/vim-snippets",

    "jpalardy/vim-slime",

    {
        "mizlan/iswap.nvim",
        keys = {
            { "<leader>h", ":ISwapNodeWithLeft<cr>", desc = "Swap with left node" },
            { "<leader>l", ":ISwapNodeWithRight<cr>", desc = "Swap with right node" },
            { "<leader>j", ":ISwapNodeWith<cr>", desc = "Swap with selected node" },
            { "<leader>k", ":ISwapNode<cr>", desc = "Swap node" },
        },
    },

    { "numToStr/Comment.nvim", opts = {}, lazy = false },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    -- languages
                    "c",
                    "commonlisp",
                    "dockerfile",
                    "eex",
                    "elixir",
                    "elm",
                    "erlang",
                    "java",
                    "javascript",
                    "jsdoc",
                    "go",
                    "gomod",
                    "gowork",
                    "heex",
                    "python",
                    "ruby",
                    "rust",
                    "tsx",
                    "typescript",
                    "zig",
                    -- version control
                    "diff",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    -- web
                    "css",
                    "html",
                    "http",
                    -- config
                    "hcl",
                    "ini",
                    "json",
                    "jsonc",
                    "nix",
                    "terraform",
                    "toml",
                    "yaml",
                    "xml",
                    -- scripting
                    "bash",
                    "fish",
                    "jq",
                    "lua",
                    "vim",
                    -- queries
                    "graphql",
                    "regex",
                    "sql",
                    -- docs "help",
                    "markdown",
                    "markdown_inline",
                    "rst",
                },

                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { "python" },
                },
            })
        end,
    },

    -- Enable for one-off setup. See its README for auth.
    -- { "zbirenbaum/copilot.lua", opts = {} },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            strategies = {
                chat = {
                    adapter = {
                        name = "anthropic",
                        model = "claude-sonnet-4-20250514",
                    },
                },
                inline = {
                    adapter = {
                        name = "anthropic",
                        model = "claude-sonnet-4-20250514",
                    },
                },
            },
            adapters = {
                http = {
                    -- anthropic = function()
                    --     return require("codecompanion.adapters").extend("anthropic", {
                    --         env = {
                    --             api_key = "MY_OTHER_ANTHROPIC_KEY",
                    --         },
                    --     })
                    -- end,
                    copilot = function()
                        return require("codecompanion.adapters").extend("copilot", {
                            schema = {
                                model = {
                                    default = function()
                                        return "claude-sonnet-4"
                                    end,
                                },
                            },
                        })
                    end,
                },
            },
        },
        cmd = {
            "CodeCompanion",
            "CodeCompanionCmd",
            "CodeCompanionChat",
            "CodeCompanionActions",
        },
        keys = {
            {
                mode = { "n", "v" },
                "<leader>n",
                "<cmd>CodeCompanionActions<cr>",
                noremap = true,
                silent = true,
            },
            {
                mode = { "n", "v" },
                "<leader>m",
                "<cmd>CodeCompanionChat Toggle<cr>",
                noremap = true,
                silent = true,
            },
            {
                mode = { "v" },
                "ga",
                "<cmd>CodeCompanionChat Add<cr>",
                noremap = true,
                silent = true,
            },
            -- vim.keymap.set("n", "<leader>ai", ":CodeCompanion<cr>")
            -- vim.keymap.set("n", "<leader>ac", ":CodeCompanionChat Toggle<cr>")
            -- vim.keymap.set("v", "<leader>ac", ":CodeCompanionChat Toggle<cr>")
            -- vim.keymap.set("n", "<leader>am", ":CodeCompanionCmd<cr>")
            -- vim.keymap.set("n", "<leader>at", ":CodeCompanionActions<cr>")
            -- vim.keymap.set("v", "<leader>at", ":CodeCompanionActions<cr>")
        },
    },

    "pbrisbin/vim-mkdir",
    "raimondi/delimitmate",
    "tpope/vim-abolish",
    "tpope/vim-obsession",
    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "wellle/targets.vim",

    -- included for folding
    -- "preservim/vim-markdown",
    -- "elixir-tools/elixir-tools.nvim"
    -- {
    --     "fatih/vim-go", build = ":GoUpdateBinaries"
    -- },
    "ChrisWellsWood/roc.vim",

    -- as needed
    -- "dstein64/vim-startuptime",
    -- "mattn/emmet-vim",
    -- "tpope/vim-dadbod",
    -- "lervag/vimtex", let g:tex_flavor = "latex"

    -- new plugins to try

    -- {
    --     "nvim-telescope/telescope.nvim",
    --     branch = "0.1.x",
    --     dependencies = { "nvim-lua/plenary.nvim" }
    -- }

    -- "iamcco/markdown-preview.nvim"
    -- "tpope/vim-rsi"
    -- "mbbill/undotree",
    -- "her/central.vim",
    -- "mfussenegger/nvim-dap",
    -- "ThePrimeagen/harpoon",
    -- "folke/trouble.nvim",
    -- "tpope/vim-dispatch",
    -- "janko-m/vim-test",
    -- "tpope/projectionist",
    -- { "codota/tabnine-nvim", build = "./dl_binaries.sh" },
    -- "jameshiew/nvim-magic",
    -- "rest-nvim/rest.nvim",
    -- "kana/vim-textobj-entire",
    -- "kana/vim-textobj-user",
    -- "michaeljsmith/vim-indent-object",
    -- { "glacambre/firenvim", build = function() return vim.fn.firenvim.install(0) end },

    -- "tpope/vim-afterimage",
    -- "tpope/vim-eunuch",
    -- "folke/todo-comments.nvim",
    -- "wfxr/minimap.vim",
    -- "kannokanno/previm",
    -- "nathom/filetype.nvim",
    -- "APZelos/blamer.nvim",
    -- "f-person/git-blame.nvim",
    -- "sjl/gundo.vim",
    -- "Konfekt/FastFold",

    -- if !empty(glob("~/.config/nvim/plugs.os.vim"))
    --     source ~/.config/nvim/plugs.os.vim
    -- endif
    -- if !empty(glob("~/.config/nvim/plugs.local.vim"))
    --     source ~/.config/nvim/plugs.local.vim
    -- endif
}

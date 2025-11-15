return {
    {
        -- "jreybert/vimagit"
        -- "tpope/vim-git",
        -- "tpope/vim-rhubarb"
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        keys = {
            { "<leader>gs", ":vert Git<cr>:vert resize 100<cr>", desc = "Git status" },
            { "<leader>gf", ":Git! fetch<cr>", desc = "Git fetch" },
            { "<leader>gz", ":Git stash<space>", desc = "Git stash" },
            { "<leader>gp", ":Git! pull<space>", desc = "Git pull" },
            { "<leader>gu", ":Git! push<space>", desc = "Git push" },
            { "<leader>go", ":Git checkout<space>", desc = "Git checkout" },
            { "<leader>gc", ":tab Git commit -v<cr>", desc = "Git commit" },
            { "<leader>gb", ":Git branch<space>", desc = "Git branch" },
            { "<leader>gd", ":Gvdiffsplit<cr>", desc = "Git diff split" },
            { "<leader>gm", ":Git blame<cr>", desc = "Git blame" },
            { "<leader>g.", ":GBrowse<cr>", desc = "Git browse", mode = { "n", "v" } },
        },
    },

    -- Github code reviews
    -- "pwntester/octo.nvim"

    -- ui

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },

    {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 400,
            fallback = "dark",

            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
                vim.api.nvim_exec_autocmds("User", { pattern = "AutoDarkModeChanged" })
            end,

            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
                vim.api.nvim_exec_autocmds("User", { pattern = "AutoDarkModeChanged" })
            end,
        },
    },

    { "folke/snacks.nvim", opts = { bigfile = {} } },

    "folke/which-key.nvim",
    "norcalli/nvim-colorizer.lua",
    -- TODO: disable <leader>rwp
    "powerman/vim-plugin-AnsiEsc",
    "ryanoasis/vim-devicons",

    -- editing
    {
        "andrewradev/linediff.vim",
        keys = {
            { "<leader>l", ":Linediff<cr>", desc = "Line diff", mode = "v" },
        },
    },

    {
        "glacambre/firenvim",
        build = ":call firenvim#install(0)"
    },

    { "smoka7/hop.nvim", opts = {} }, -- opts ensures that setup() gets called
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

    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    "pbrisbin/vim-mkdir",

    {
        "raimondi/delimitmate",
        event = "InsertEnter",
        init = function(_)
            vim.g.delimitMate_balance_matchpairs = 1
            vim.g.delimitMate_excluded_regions = ""
            vim.g.delimitMate_expand_cr = 2
            vim.g.delimitMate_expand_inside_quotes = 1
            vim.g.delimitMate_expand_space = 1
            vim.g.delimitMate_jump_expansion = 1
        end,
    },

    "tpope/vim-abolish",

    {
        "tpope/vim-obsession",
        keys = {
            { "<leader>st", ":Obsession<cr>", desc = "Start session tracking" },
            { "<leader>sl", ":source Session.vim<cr>", desc = "Load session" },
        },
    },

    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    "wellle/targets.vim",

    -- included for folding
    -- "preservim/vim-markdown",
    -- "elixir-tools/elixir-tools.nvim"

    {
        "fatih/vim-go",
        build = ":GoUpdateBinaries",
        ft = "go",
        init = function()
            -- Disable features handled by LSP
            vim.g.go_code_completion_enabled = 0
            vim.g.go_doc_keywordprg_enabled = 0
            vim.g.go_fmt_autosave = 0
            vim.g.go_def_mapping_enabled = 0
            vim.g.go_gopls_enabled = 0

            -- Terminal settings
            vim.g.go_term_mode = "split"
            vim.g.go_term_reuse = 1
            vim.g.go_term_enabled = 1
            vim.g.go_term_close_on_exit = 0
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "ChrisWellsWood/roc.vim",
        ft = "roc",
        opts = {},
    },

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

    -- "ThePrimeagen/harpoon",
    -- "folke/trouble.nvim",
    -- "mfussenegger/nvim-dap",
    -- "folke/todo-comments.nvim",

    -- "iamcco/markdown-preview.nvim"
    -- "tpope/vim-rsi"
    -- "mbbill/undotree",
    -- "her/central.vim",
    -- "tpope/vim-dispatch",
    -- "janko-m/vim-test",
    -- "tpope/projectionist",
    -- "jameshiew/nvim-magic",
    -- "rest-nvim/rest.nvim",
    -- "kana/vim-textobj-entire",
    -- "kana/vim-textobj-user",
    -- "michaeljsmith/vim-indent-object",

    -- "tpope/vim-afterimage",
    -- "tpope/vim-eunuch",
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

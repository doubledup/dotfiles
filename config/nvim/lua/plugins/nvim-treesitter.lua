return {
    "nvim-treesitter/nvim-treesitter",

    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",

    opts = {
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

        -- TODO: associate jsonc with json

        sync_install = false,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },

        indent = {
            enable = true,
            disable = { "python" },
        },
    },
}

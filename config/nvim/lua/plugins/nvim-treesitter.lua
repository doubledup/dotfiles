local parsers = {
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
    -- docs
    "markdown",
    "markdown_inline",
    "vimdoc",
}

return {
    "nvim-treesitter/nvim-treesitter",

    branch = "main",
    lazy = false,
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
                if vim.bo.filetype ~= "python" then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}

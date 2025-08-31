return {
    -- "jreybert/vimagit"
    -- "tpope/vim-git",
    -- "tpope/vim-rhubarb"
    "tpope/vim-fugitive",
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
    },
}

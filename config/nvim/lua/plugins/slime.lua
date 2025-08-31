return {
    "jpalardy/vim-slime",
    init = function()
        -- Set target to kitty terminal
        vim.g.slime_target = "kitty"
        -- Disable default mappings (we define our own)
        vim.g.slime_no_mappings = 1
        -- TODO: choose from active terminals b:terminal_job_id
    end,
    keys = {
        { "<leader>tc", "<plug>SlimeConfig", desc = "Configure slime target" },
        { "<leader>tx", "<plug>SlimeMotionSend", desc = "Send motion to terminal", mode = "n" },
        { "<leader>tx", "<plug>SlimeRegionSend", desc = "Send selection to terminal", mode = "x" },
        { "<leader>tl", "<plug>SlimeLineSend", desc = "Send line to terminal" },
    },
}

-- web search
vim.keymap.set("n", "<c-8>", function()
    local filetype = vim.bo.filetype
    local word = vim.fn.expand("<cword>")
    local url =
        string.format("https://search.brave.com/search?q=%s+%s&source=desktop", filetype, word)

    vim.fn.system({ "open", url })
end, { desc = "Web search filetype and word under cursor" })

vim.keymap.set("v", "<c-8>", function()
    local filetype = vim.bo.filetype
    -- simplified url encoding: replace spaces with +
    vim.cmd('normal! "zy')
    local selection = vim.fn.getreg("z"):gsub(" ", "+")
    local url =
        string.format("https://search.brave.com/search?q=%s+%s&source=desktop", filetype, selection)

    vim.fn.system({ "open", url })
end, { desc = "Web search filetype and words in selection" })

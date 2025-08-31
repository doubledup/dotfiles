-- non-plugin autocommands and user commands

vim.api.nvim_create_user_command("BuffersDeleteHidden", function()
    local shownBuffers = {}
    for i = 1, vim.fn.tabpagenr("$") do
        for _, j in pairs(vim.fn.tabpagebuflist(i)) do
            shownBuffers[j] = true
        end
    end

    local hiddenBuffers = {}
    for i = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and not shownBuffers[i] then
            table.insert(hiddenBuffers, i)
        end
    end

    if #hiddenBuffers > 0 then
        vim.cmd.bdelete(table.concat(hiddenBuffers, " "))
    end
end, { desc = 'Delete all "hidden" / not-shown buffers' })

vim.api.nvim_create_user_command("BuffersDeleteUnnamed", function()
    local emptyBuffers = {}
    for i = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and vim.fn.bufname(i) == "" then
            table.insert(emptyBuffers, i)
        end
    end

    if #emptyBuffers > 0 then
        vim.cmd.bdelete(table.concat(emptyBuffers, " "))
    end
end, { desc = "Delete all unnamed buffers" })

local onsave_augroup = vim.api.nvim_create_augroup("trim_whitespace_on_bufwrite", {})
vim.api.nvim_create_autocmd("BufWrite", {
    desc = "Trim trailing whitespace on save",
    group = onsave_augroup,
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})


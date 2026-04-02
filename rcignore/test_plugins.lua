-- Force-load all lazy.nvim plugins and check for errors.
-- Run with: nvim --headless +"luafile rcignore/test_plugins.lua"

local ok, lazy = pcall(require, "lazy")
if not ok then
    print("FAIL: lazy.nvim not available")
    vim.cmd("cquit 1")
end

-- Force-load all plugins
local failed = {}
for _, plugin in ipairs(lazy.plugins()) do
    if not plugin._.loaded then
        local load_ok, err = pcall(function()
            require("lazy").load({ plugins = { plugin.name } })
        end)
        if not load_ok then
            table.insert(failed, plugin.name .. ": " .. tostring(err))
        elseif not plugin._.loaded then
            table.insert(failed, plugin.name .. ": did not load")
        end
    end
end

if #failed > 0 then
    print("FAIL: " .. #failed .. " plugin(s) failed to load:")
    for _, name in ipairs(failed) do
        print("  - " .. name)
    end
    vim.cmd("cquit 1")
else
    print("OK: all " .. #lazy.plugins() .. " plugins loaded")
    vim.cmd("quit")
end

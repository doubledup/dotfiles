return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Useful status updates for LSP.
        { "j-hui/fidget.nvim", opts = {} },

        -- Allows extra capabilities provided by blink.cmp
        "saghen/blink.cmp",
    },

    config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lspconfig-lsp-attach", { clear = true }),
            callback = function(event)
                -- LSP mapping helper. Sets the mode, buffer and description.
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- TODO: Text objects for functions and classes

                -- Use [s and ]s to navigate diagnostics (replace spell checker)
                map("[s", vim.diagnostic.goto_prev, "Previous diagnostic")
                map("]s", vim.diagnostic.goto_next, "Next diagnostic")

                map("gd", function()
                    local ok, telescope = pcall(require, "telescope.builtin")
                    if ok then
                        telescope.lsp_definitions()
                    else
                        vim.lsp.buf.definition()
                    end
                end, "Go to definition")
                map("gy", function()
                    local ok, telescope = pcall(require, "telescope.builtin")
                    if ok then
                        telescope.lsp_type_definitions()
                    else
                        vim.lsp.buf.type_definition()
                    end
                end, "Go to type definition")
                map("gi", function()
                    local ok, telescope = pcall(require, "telescope.builtin")
                    if ok then
                        telescope.lsp_implementations()
                    else
                        vim.lsp.buf.implementation()
                    end
                end, "Go to implementation")
                map("gr", function()
                    local ok, telescope = pcall(require, "telescope.builtin")
                    if ok then
                        telescope.lsp_references()
                    else
                        vim.lsp.buf.references()
                    end
                end, "Go to references")

                -- Documentation hover
                map("K", function()
                    local cw = vim.fn.expand("<cword>")
                    if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
                        vim.api.nvim_command("h " .. cw)
                    else
                        -- TODO: hidden text still adds a lot of whitespace in doc windows
                        -- TODO: add esc to dismiss hover doc window
                        vim.lsp.buf.hover({
                            max_height = 20,
                            max_width = 80,
                        })
                    end
                end, "Show documentation")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- Rename symbol
                map("<leader>an", vim.lsp.buf.rename, "Rename symbol")

                -- Format code
                -- map("<leader>=", function()
                --     vim.lsp.buf.format({ async = true })
                -- end, "Format")
                -- map("<leader>=", function()
                --     vim.lsp.buf.format({
                --         async = true,
                --         range = {
                --             start = vim.api.nvim_buf_get_mark(0, "<"),
                --             ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                --         },
                --     })
                -- end, "Format selection", "x")

                -- Code actions
                -- TODO: targeted code actions
                -- map("<leader>ac", vim.lsp.buf.code_action, "Code action at cursor")
                -- map("<leader>ak", vim.lsp.buf.code_action, "Code action for file")
                map("<leader>ak", vim.lsp.buf.code_action, "Code action")
                map("<leader>a", vim.lsp.buf.code_action, "Code action on selection", "x")
                map("<leader>al", function()
                    vim.lsp.buf.code_action({
                        context = { only = { "quickfix" } },
                        range = {
                            start = { vim.fn.line("."), 0 },
                            ["end"] = { vim.fn.line("."), 0 },
                        },
                    })
                end, "Code action for line")

                -- Lists using telescope
                map("<leader>e", function()
                    local ok = pcall(vim.cmd, "Telescope diagnostics")
                    if not ok then
                        vim.diagnostic.setqflist()
                    end
                end, "List diagnostics")
                map("<leader>ao", function()
                    local ok = pcall(vim.cmd, "Telescope lsp_document_symbols")
                    if not ok then
                        vim.lsp.buf.document_symbol()
                    end
                end, "List outline")
                map("<leader>ay", function()
                    local ok = pcall(vim.cmd, "Telescope lsp_dynamic_workspace_symbols")
                    if not ok then
                        vim.lsp.buf.workspace_symbol("")
                    end
                end, "List symbols")

                -- TODO: LSP management commands (restart, logs, etc.)
                -- map("<c-;>", function()
                --     local ok = pcall(vim.cmd, "Telescope lsp_workspace_symbols")
                --     if not ok then
                --         vim.lsp.buf.workspace_symbol("")
                --     end
                -- end, "List commands")

                -- TODO: Range selection
                -- map("<c-q>", function()
                --     vim.lsp.buf.range_code_action()
                -- end, "Range select", { "n", "x" })

                -- Highlight references of the word under the cursor when the cursor rests on them
                -- for a little while. When the cursor moves, the highlights will be cleared (the
                -- second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    client
                    and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
                then
                    local highlight_augroup = vim.api.nvim_create_augroup("lspconfig-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("lspconfig-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "lspconfig-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map("<leader>ah", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            } or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, blink = pcall(require, "blink.cmp")
        if ok then
            capabilities = blink.get_lsp_capabilities(capabilities)
        end

        -- Enable the following language servers
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        -- Uncomment to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
            rust_analyzer = {},

            bashls = {},
            html = {},
            jsonls = {},
            lemminx = {}, -- XML
            sqlls = {},
            terraformls = {},
            yamlls = {},
        }

        -- Ensure the servers and tools above are installed
        --
        -- Check current status of installed tools and/or manually install other tools with :Mason.
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            -- "jdtls", -- TODO: Install here instead of with Homebrew, configure with nvim-jdtls
            -- `:h mason-how-to-use-packages`
            "stylua", -- Used to format Lua code
            "prettier", -- Formatter for HTML, CSS, JS, JSON, etc
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            ensure_installed = {}, -- explicitly set to an empty table: mason-tool-installer handles installs
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}

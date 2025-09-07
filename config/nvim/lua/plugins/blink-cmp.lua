return {
    "saghen/blink.cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "2.*",
            build = "make install_jsregexp",
            dependencies = {
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            opts = {},
        },

        "folke/lazydev.nvim",
    },

    event = "VimEnter",
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- All presets have the following mappings:
        -- C-k: Toggle signature help (if signature.enabled = true)
        keymap = { preset = "super-tab" },

        appearance = { nerd_font_variant = "mono" },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        -- Uncomment when needed for more info
                        { "kind" }, --, "source_name", gap = 1 }
                    },

                    -- TODO: xzbdmw/colorful-menu.nvim
                    treesitter = { "lsp" },
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 50,
            },
        },

        -- TODO: https://cmp.saghen.dev/configuration/sources.html#community-sources
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },

            per_filetype = {
                lua = { inherit_defaults = true, "lazydev" }
            },

            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },

        -- TODO: https://github.com/L3MON4D3/LuaSnip
        snippets = { preset = "luasnip" },

        cmdline = {
            keymap = {
                preset = "cmdline",
                ["<Tab>"] = {
                    -- Uncomment when enabling ghost text in cmdline
                    -- function(cmp)
                    --     if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                    --         return cmp.accept()
                    --     end
                    -- end,
                    "select_and_accept",
                },
                ["<S-Tab>"] = { "fallback_to_mappings" },
            },

            completion = {
                menu = {
                    ---@diagnostic disable-next-line: unused-local
                    auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ":"
                        -- enable for inputs as well, with:
                        -- or vim.fn.getcmdtype() == '@'
                    end,
                },
            },
        },

        -- TODO: terminal completion
        -- term = {}

        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Show LSP signature help: https://cmp.saghen.dev/configuration/signature.html
        signature = { enabled = true },
    },

    opts_extend = { "sources.default" },
}

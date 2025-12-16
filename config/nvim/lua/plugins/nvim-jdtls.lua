return {
    -- TODO: turn off automatic project builds and add manual trigger. Maven doesn't coordinate
    -- operations on the same module across processes, so LSP builds can clobber CLI commands and
    -- vice versa.
    "mfussenegger/nvim-jdtls",
    ft = "java",

    -- dependencies = {
    --     "mason-tool-installer",
    -- },

    ---@diagnostic disable-next-line: unused-local
    config = function(opts)
        local root_markers = { ".git", "gradlew", "mvnw" }
        local root_dir = require("jdtls.setup").find_root(root_markers)

        local home = os.getenv("HOME")
        if not string.match(root_dir, "^" .. home) then
            vim.notify("root_dir is outside $HOME", vim.log.levels.ERROR)
        end

        -- create workspace directory relative to home
        -- trim home dir, then trim leading slash to handle both a root_dir that's in home and one
        -- that's not. e.g. /home/user/org/proj gets trimmed to org/proj, and /tmp/org/proj gets
        -- trimmed to tmp/org/proj. This can cause conflicts e.g. ~/tmp/org/proj and /tmp/org/proj
        -- get the same workspace, but projects outside of home should be rare.
        local trimmed_root_dir = root_dir:gsub(home, ""):gsub("^/", "")
        local workspace_folder = home .. "/.local/share/jdtls/" .. trimmed_root_dir
        vim.notify("nvim-jdtls workspace_folder: " .. workspace_folder, vim.log.levels.INFO)

        -- TODO: `:h jdtls`
        -- https://github.com/mfussenegger/nvim-jdtls/wiki/Sample-Configurations
        vim.lsp.config("jdtls", {
            name = "jdtls",

            -- `cmd` defines the executable to launch eclipse.jdt.ls.
            -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
            --
            -- As alternative you could also avoid the `jdtls` wrapper and launch
            -- eclipse.jdt.ls via the `java` executable
            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
            cmd = {
                "jdtls",
                "--java-executable",
                vim.trim(vim.fn.system("/usr/libexec/java_home", "-v 21")) .. "/bin/java",
                "-data",
                workspace_folder,
                -- vim.fn.getcwd() .. "/.jdtls",
                "--jvm-arg=-javaagent:/Users/daviddunn/.m2/repository/org/projectlombok/lombok/1.18.38/lombok-1.18.38.jar",
            },

            -- `root_dir` must point to the root of your project.
            -- See `:help vim.fs.root`
            root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),

            -- Here you can configure eclipse.jdt.ls specific settings
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- for a list of options
            settings = {
                java = {
                    autobuild = { enabled = false },
                    configuration = {
                        -- maven = {},
                        runtimes = {},
                        updateBuildConfiguration = "interactive",
                    },
                    maven = {
                        downloadSources = true,
                        updateSnapshots = true,
                    },
                    format = { enabled = false },
                    import = {
                        gradle = { enabled = false },
                        maven = {
                            enabled = true,
                            offline = { enabled = true },
                        },
                    },
                    -- TODO: set up inlayHints
                    -- inlayHints = {
                    --     parameterNames = {
                    --         enabled = "all",
                    --     }
                    -- },
                    diagnostic = {
                        nullAnalysis = { mode = "automatic" },
                    },
                },
            },

            -- This sets the `initializationOptions` sent to the language server
            -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
            -- you'll need to set the `bundles`
            --
            -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
            --
            -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
            -- init_options = {
            --     bundles = {},
            -- },
        })

        -- TODO: add telescope: https://github.com/mfussenegger/nvim-jdtls/wiki/UI-Extensions

        vim.lsp.enable("jdtls")
    end,
}

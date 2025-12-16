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
        local home = os.getenv("HOME")
        local lombok_version = "1.18.42"
        local lombok_path = home
            .. "/.m2/repository/org/projectlombok/lombok/"
            .. lombok_version
            .. "/lombok-"
            .. lombok_version
            .. ".jar"

        local lombok_job
        if vim.fn.filereadable(vim.fn.expand(lombok_path)) == 0 then
            vim.notify("Lombok not found, downloading...", vim.log.levels.INFO)
            lombok_job = vim.fn.jobstart(
                "mvn dependency:get -Dartifact=org.projectlombok:lombok:" .. lombok_version,
                {
                    on_exit = function(job_id, exit_code)
                        if exit_code == 0 then
                            vim.notify("Downloaded Lombok v" .. lombok_version, vim.log.levels.INFO)
                        else
                            vim.notify(
                                "Failed to download Lombok (exit code " .. exit_code .. ")",
                                vim.log.levels.ERROR
                            )
                        end
                    end,
                    on_stdout = function(job_id, data, event)
                        vim.notify(table.concat(data, "\n"), vim.log.levels.DEBUG)
                    end,
                    on_stderr = function(job_id, data, event)
                        -- Maven outputs JDK deprecation warnings to stderr; use DEBUG to avoid noise
                        vim.notify(table.concat(data, "\n"), vim.log.levels.DEBUG)
                    end,
                }
            )
        end

        local root_markers = { { "gradlew", "mvnw" }, ".git" }
        local root_dir = vim.fs.root(0, root_markers)
            or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

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
        vim.notify("nvim-jdtls workspace_folder: " .. workspace_folder, vim.log.levels.DEBUG)

        if lombok_job then
            vim.fn.jobwait({ lombok_job })
        end

        -- TODO: `:h jdtls`
        -- https://github.com/mfussenegger/nvim-jdtls/wiki/Sample-Configurations
        vim.lsp.config("jdtls", {
            name = "jdtls",

            cmd = {
                "jdtls",
                "--java-executable",
                vim.trim(vim.fn.system("/usr/libexec/java_home", "-v 25")) .. "/bin/java",
                "-data",
                workspace_folder,
                -- vim.fn.getcwd() .. "/.jdtls",
                "--jvm-arg=-javaagent:" .. lombok_path,
            },

            root_dir = root_dir,

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

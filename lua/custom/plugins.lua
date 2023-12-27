---@type NvPluginSpec[]
local plugins = {

    -- Override plugin definition options

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- format & linting
            {
                "MunifTanjim/prettier.nvim",
                config = function()
                    require "custom.configs.prettier"
                end,
            },
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require "custom.configs.null-ls"
                end,
            },
        },
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end, -- Override to setup mason-lspconfig
    },

    -- new plugins
    ------ OVERSEER ------
    {
        "hammerlink/overseer.nvim",
        opts = {},
        dependencies = "stevearc/dressing.nvim",
        init = function()
            require "custom.configs.overseer"
        end,
    },
    {
        "stevearc/dressing.nvim",
        dependencies = "rcarriga/nvim-notify",
        opts = {},
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require "notify"
        end,
    },
    ------ SPECTRE TODO ------
    {
        "nvim-pack/nvim-spectre",
        opts = {},
        config = function()
            require "custom.configs.spectre"
        end,
    },
    ------ NEOTEST TODO ------
    {
        "antoinemadec/FixCursorHold.nvim",
    },
    { "haydenmeade/neotest-jest" },
    { "rouge8/neotest-rust" },
    { "marilari88/neotest-vitest" },
    { "MarkEmmons/neotest-deno" },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "haydenmeade/neotest-jest",
        },
        cmd = "Neotest",
        config = function()
            require("neotest").setup {
                adapters = {
                    require "neotest-jest" {
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    },
                    require "neotest-rust" {
                        args = { "--no-capture" },
                        dap_adapter = "codelldb", -- LLDB MISSING!!
                    },
                    require "neotest-vitest" {
                        cwd = function(path)
                            local closest_dir = custom_utils.find_closest_package_json_dir(path, vim.fn.getcwd())
                            return closest_dir
                        end,
                    },
                    require "neotest-deno" {},
                },
            }
        end,
    },
    ------ UNDOTREE ------
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
    },
    ------ GIT ------
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("neogit").setup {
                integrations = {
                    diffview = true,
                },
            }
        end,
    },
    ------ Aerial ------
    {
        "stevearc/aerial.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "AerialToggle",
        config = function()
            require("aerial").setup {
                layout = {
                    default_direction = "prefer_left",
                },
            }
        end,
    },
    ------ DAP ------
    {
        "mfussenegger/nvim-dap",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        event = "VeryLazy",
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        requires = { "mfussenegger/nvim-dap" },
        opt = true,
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    {
        "microsoft/vscode-js-debug",
        opt = true,
        -- run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        event = "VeryLazy",
        config = function()
            require("dap-vscode-js").setup {
                node_path = "/home/hendrik/.nvm/versions/node/v20.10.0/bin/node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                -- debugger_path = "/home/hendrik/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
                debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
                -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
            }
            for _, language in ipairs { "typescript", "javascript" } do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Debug Jest Tests",
                        -- trace = true, -- include debugger info
                        runtimeExecutable = "node",
                        runtimeArgs = {
                            "./node_modules/jest/bin/jest.js",
                            "--runInBand",
                        },
                        rootPath = "${workspaceFolder}",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                    },
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end
            local dap = require "dap"
            -- dap.adapters.lldb = {
            --     type = "executable",
            --     command = "/usr/bin/codelldb", -- adjust as needed, must be absolute path
            --     --command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
            --     name = "lldb",
            -- }
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    -- CHANGE THIS to your path!
                    command = "/home/hendrik/.local/share/nvim/mason/bin/codelldb",
                    args = { "--port", "${port}" },

                    -- On windows you may have to uncomment this:
                    -- detached = false,
                },
            }
            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},

                    -- 💀
                    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                    --
                    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                    --
                    -- Otherwise you might get the following error:
                    --
                    --    Error on launch: Failed to attach to the target process
                    --
                    -- But you should be aware of the implications:
                    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                    -- runInTerminal = false,
                },
            }

            -- If you want to use this for Rust and C, add something like this:

            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    initCommands = function()
                        -- Find out where to look for the pretty printer Python module
                        local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")

                        local script_import = 'command script import "'
                            .. rustc_sysroot
                            .. '/lib/rustlib/etc/lldb_lookup.py"'
                        local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                        local commands = {}
                        local file = io.open(commands_file, "r")
                        if file then
                            for line in file:lines() do
                                table.insert(commands, line)
                            end
                            file:close()
                        end
                        table.insert(commands, 1, script_import)

                        return commands
                    end,
                    -- ...,
                },
            }
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        cmd = { "TroubleToggle", "TroubleRefresh", "Trouble", "TroubleClose" },
    },
}

return plugins

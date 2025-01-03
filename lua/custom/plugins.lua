local custom_utils = require "custom.utils"
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
            require "plugins.configs.lspconfig" -- initializes LUA lsp
            require "custom.configs.lspconfig"
        end,                                    -- Override to setup mason-lspconfig
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
    { "nvim-neotest/nvim-nio" },
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
            "marilari88/neotest-vitest",
            "nvim-neotest/nvim-nio",
            "alfaix/neotest-gtest",
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
                    require("neotest-gtest").setup {
                        -- Optional config
                        root_pattern = "CMakeLists.txt", -- Pattern to find project root
                        executable_pattern = "build/*",  -- Pattern to find executables
                    },
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
        config = function()
            local actions = require "diffview.actions"
            require("diffview").setup {
                keymaps = {
                    view = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    diff1 = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    diff2 = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    diff3 = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    diff4 = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    file_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                    file_history_panel = { { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "close" } } },
                },
            }
        end,
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
                mappings = {
                    popup = {
                        ["g?"] = "HelpPopup",
                        ["?"] = false,
                    },
                },
            }
            vim.cmd "highlight NeogitDiffDelete gui=bold guifg=#FAEBE8 guibg=#D1321B"
            vim.cmd "highlight NeogitDiffDeleteCursor gui=bold guifg=#D1321B guibg=#FAEBE8"
            vim.cmd "highlight NeogitDiffDeleteHighlight gui=bold guifg=#FAEBE8 guibg=#D1321B"

            vim.cmd "highlight DiffviewDiffAddAsDelete guibg=#55433b guifg=NONE"
            vim.cmd "highlight DiffviewDiffDelete guibg=#533649 guifg=NONE"
            vim.cmd "highlight DiffviewDiffAdd guibg=#35533d guifg=NONE"
            vim.cmd "highlight DiffviewDiffChange guibg=#29446c guifg=NONE"
            vim.cmd "highlight DiffviewDiffText guibg=#3f426c guifg=NONE"
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
                -- node_path = "/home/hendrik/.nvm/versions/node/v20.11.0/bin/node",                            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                -- debugger_path = "/home/hendrik/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
                debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",                            -- Path to vscode-js-debug installation.
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
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    arg = { "~/.local/share/nvim/lazy/vscode-js-debug/out/src/dapDebugServer.js", "${port}" },
                },
            }
            dap.adapters["pwa-bun"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "bun",
                    arg = { "~/.local/share/nvim/lazy/vscode-js-debug/out/src/dapDebugServer.js", "${port}" },
                },
            }
        end,
    },
    ---- AI
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup {
                suggestion = {
                    auto_trigger = true,
                },
            }
        end,
    },
    {
        "David-Kunz/gen.nvim",
        cmd = "Gen",
        opts = {
            model = "llama3.1",
        },
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
            -- ["local"] = true,
            provider = "claude",
            vendors = {
                ---@type AvanteProvider
                ollama = {
                    ["local"] = true,
                    endpoint = "127.0.0.1:11434/v1",
                    model = "llama3.1",
                    parse_curl_args = function(opts, code_opts)
                        return {
                            url = opts.endpoint .. "/chat/completions",
                            headers = {
                                ["Accept"] = "application/json",
                                ["Content-Type"] = "application/json",
                            },
                            body = {
                                model = opts.model,
                                messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                                max_tokens = 2048,
                                stream = true,
                            },
                        }
                    end,
                    parse_response_data = function(data_stream, event_state, opts)
                        require("avante.providers").openai.parse_response(data_stream, event_state, opts)
                    end,
                },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",      -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}

return plugins

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
        "stevearc/overseer.nvim",
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
    ------ NEOTEST TODO ------
    {
        "antoinemadec/FixCursorHold.nvim",
    },
    {
        "haydenmeade/neotest-jest",
    },
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
                        -- jestCommand = "npm test --",
                        -- jestConfigFile = "custom.jest.config.ts",
                        -- env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
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
    ------ PRETTIER ------
    ------ DIFFVIEW ------
    -- {
    --   "sindrets/diffview",
    --   cmd = "DiffviewFileHistory",
    -- },
    ------ AUTOSAVE ------
    -- {
    --   "Pocco81/auto-save.nvim",
    --   cmd = "ASToggle",
    --   config = function()
    --       require("auto-save").setup {
    --
    --           }
    --   end,
    -- },
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
    ------ DAP ------
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },
    -- { "dap-vscode-js" },
    -- {
    --     "microsoft/vscode-js-debug",
    --     opt = true,
    --     run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    --     event = "VeryLazy",
    --     config = function()
    --         require("dap-vscode-js").setup {
    --             -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    --             -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    --             -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    --             adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    --             -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    --             -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    --             -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    --         }
    --         for _, language in ipairs { "typescript", "javascript" } do
    --             require("dap").configurations[language] = {
    --                 {
    --                     type = "pwa-node",
    --                     request = "launch",
    --                     name = "Debug Jest Tests",
    --                     -- trace = true, -- include debugger info
    --                     runtimeExecutable = "node",
    --                     runtimeArgs = {
    --                         "./node_modules/jest/bin/jest.js",
    --                         "--runInBand",
    --                     },
    --                     rootPath = "${workspaceFolder}",
    --                     cwd = "${workspaceFolder}",
    --                     console = "integratedTerminal",
    --                     internalConsoleOptions = "neverOpen",
    --                 },
    --                 {
    --                     type = "pwa-node",
    --                     request = "launch",
    --                     name = "Launch file",
    --                     program = "${file}",
    --                     cwd = "${workspaceFolder}",
    --                 },
    --                 {
    --                     type = "pwa-node",
    --                     request = "attach",
    --                     name = "Attach",
    --                     processId = require("dap.utils").pick_process,
    --                     cwd = "${workspaceFolder}",
    --                 },
    --             }
    --         end
    --     end,
    -- },
}

return plugins

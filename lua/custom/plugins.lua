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
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy"
    },
}

return plugins

return {
    ['mbbill/undotree'] = {},
    ['gelguy/wilder.nvim'] = {
        config = function()
            local present, nvchad_ui = pcall(require, "nvchad_ui")

            if present then
                nvchad_ui.setup()
            end
        end
    },
    -- ['theHamsta/nvim-dap-virtual-text'] = {},
    -- ['rcarriga/nvim-dap-ui'] = {},
    --    ['nvim-telescope/telescope-dap.nvim'] = {
    --        after = "nvim-telescope/telescope.nvim",
    --        config = function()
    --            require("telescope").load_extension("dap")
    --        end
    --    },
    -- ['jbyuki/one-small-step-for-vimkind'] = { module = "osv" },
    -- ['mxsdev/nvim-dap-vscode-js'] = {},
    -- ['microsoft/vscode-js-debug'] = {},
    ['mfussenegger/nvim-dap'] = {
        -- opt = true,
        -- keys = { [[<leader>d]] },
        opt = true,
        module = { "dap" },
        requires = {
            { "theHamsta/nvim-dap-virtual-text", module = { "nvim-dap-virtual-text" } },
            { "rcarriga/nvim-dap-ui",            module = { "dapui" } },
            { "mfussenegger/nvim-dap-python",    module = { "dap-python" } },
            "nvim-telescope/telescope-dap.nvim",
            { "leoluz/nvim-dap-go",                module = "dap-go" },
            { "jbyuki/one-small-step-for-vimkind", module = "osv" },
            { "mxsdev/nvim-dap-vscode-js",         module = { "dap-vscode-js" } },
            {
                "microsoft/vscode-js-debug",
                opt = true,
                run = "npm install --legacy-peer-deps && npm run compile",
                disable = false,
            },
        },
        -- config = function()
        --     require("custom.dap").setup()
        -- end,
        disable = false,
    },
}

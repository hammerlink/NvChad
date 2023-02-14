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
    ['simrat39/rust-tools.nvim'] = {
        config = function()
            -- local rt = require("rust-tools")
            --
            -- rt.setup({
            --     server = {
            --         on_attach = function(_, bufnr)
            --             -- Hover actions
            --             vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            --             -- Code action groups
            --             vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            --         end,
            --     },
            -- })
        end
    },
    ['mfussenegger/nvim-dap'] = {
        opt = true,
        -- keys = { [[<leader>d]] },
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

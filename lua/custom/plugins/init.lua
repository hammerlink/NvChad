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
    ['theHamsta/nvim-dap-virtual-text'] = {},
    ['rcarriga/nvim-dap-ui'] = {},
    ['mfussenegger/nvim-dap-python'] = {},
    ['nvim-telescope/telescope-dap.nvim'] = {},
    -- ['leoluz/nvim-dap-go'] = { module = "dap-go" },
    ['jbyuki/one-small-step-for-vimkind'] = { module = "osv" },
    ['mxsdev/nvim-dap-vscode-js'] = {},
    ['microsoft/vscode-js-debug'] = {
        opt = true,
        run = "npm i --legacy-peer-deps && npm run compile"
    },
    ['mfussenegger/nvim-dap'] = {
        after = { "nvim-dap-virtual-text", "mxsdev/nvim-dap-vscode-js" },
        opt = true,
        keys = { [[<leader>h]] },
        module = "dap",
        -- requires = {
        --     "theHamsta/nvim-dap-virtual-text",
        --     "rcarriga/nvim-dap-ui",
        --     "mfussenegger/nvim-dap-python",
        --     "nvim-telescope/telescope-dap.nvim",
        --     { "leoluz/nvim-dap-go",                module = "dap-go" },
        --     { "jbyuki/one-small-step-for-vimkind", module = "osv" },
        --     { "mxsdev/nvim-dap-vscode-js" },
        --     {
        --         "microsoft/vscode-js-debug",
        --         opt = true,
        --         run = "npm install --legacy-peer-deps && npm run compile",
        --     },
        -- },
        disable = false,
        config = function()
          print("start init dap")
          local present, dap = pcall(require, "dap")
          if present then
            print("loading dap")
            require("custom.plugins.dap").setup()
          end
          --   require("nvim-dap-virtual-text").setup {
          --       commented = true,
          --   }
          --
          --   local dap, dapui = require("dap"), require("dapui")
          --   dapui.setup({})
          -- end
        end
    },
}

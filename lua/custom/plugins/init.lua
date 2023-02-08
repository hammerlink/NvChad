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
  -- ['lukas-reineke/lsp-format'] = {
  --   after = 'nvim-lspconfig',
  --   config = function()
  --     local present, lsp_format = pcall(require, "lsp_format")
  --
  --     if present then
  --       lsp_format.setup {
  --         typescript = {
  --           tab_width = function()
  --             return vim.opt.shiftwidth:get()
  --           end,
  --         },
  --         yaml = { tab_width = 2 },
  --       }
  --     end
  --   end
  -- },


}

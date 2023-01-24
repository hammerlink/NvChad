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
}

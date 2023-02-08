-- First read our docs (completely) then check the example_config repo
require('custom.commands')

local M = {}

local opt = vim.opt
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.softtabstop = 4

M.ui = {
  theme = "onedark",
}
M.plugins = require('custom.plugins.init')
M.mappings = require('custom.mappings.init')


return M

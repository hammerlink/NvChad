-- First read our docs (completely) then check the example_config repo

local M = {}

M.ui = {
  theme = "onedark",
}
M.plugins = require('custom.plugins.init')
M.mappings = require('custom.mappings.init')

local prettier = {
    formatCommand = [[prettier --stdin-filepath ${INPUT} ${--tab-width:tab_width}]],
    formatStdin = true,
}

return M
